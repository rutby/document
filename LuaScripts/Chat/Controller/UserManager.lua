--[[
	存储所有聊天玩家信息
	
	玩家信息要入数据库，因为获取玩家信息走的是游戏服，服务器可能要跨服查询可能比较慢
	所以前端这里也存库，同时增加数据库相关的操作
]]

local UserManager = BaseClass("UserManager")
local ChatUserInfo = require "Chat.Model.ChatUserInfo"
local rapidjson = require "rapidjson"

function UserManager:__init()
    self:resetData()
end 

function UserManager:resetData()
    -- 聊天室用户 存放 <string, ChatUserInfo>, string = uid
    self.chatUserInfos = {} 
    -- 正在向服务器请求的用户列表<string, bool>, string = uid
    self.fetchingUids = {} 
	
    -- 举报聊天
    self.reportedChatList       = {}
    -- 举报头像
    self.reportedUserHeadList   = {}
	
    --[[
        数据库不存在的玩家信息id 字典表 
        用于防止用于一直获取不到玩家信息而一直查询数据库造成的性能影响
        如果玩家信息入库了就从该列表中清除
    ]]
    self.noneDBUserInfoList = {}
	
    -- 用于标记是否需要合并请求
    self.requestUser = true
	
    -- 目前缓存的要发网络消息请求的用户uids
    self.cacheRequestUids = {}
end

function UserManager:releaseData()
    self:resetData()
end

function UserManager:CreateUserInfo()
	return ChatUserInfo.New()
end

--设置是否需要合并请求
-- 这里没有必要去请求所有，因为肯定消耗比较大
-- 如果数据库里已经有这个人物信息了，就不去申请了
-- 等到下次这个人说话的时候，会自动更新的。
function UserManager:SetRequestUserInfo(requestUser)
	if self.requestUser == requestUser then
		return 
	end
	
	ChatPrint("SetRequestUserInfo: " .. tostring(requestUser))
    self.requestUser = requestUser
	if self.requestUser == true then
		self:__processAllUserInfos()
	end
end

-- 遍历所有房间的所有消息，把没有的用户信息的uid收集起来，
-- 并去服务器拉取用户信息
function UserManager:__processAllUserInfos()
	ChatPrint("processAllUserInfos all is ok!")
	local RoomMgr = ChatManager2:GetInstance().Room
	local allUsers = {}
	RoomMgr:GetAllUserInRooms(allUsers)
	
	if #allUsers > 0 then
		self:requestUserInfo(allUsers)
	end
end

--[[
获取聊天用户信息
如果当前没有的话，先给一个虚拟的userInfo，然后去数据库及网络请求，
等到数据请求回来之后，给UI发一个通知消息，然后UI再刷新即可
]]
function UserManager:getChatUserInfo(uid, req)
	req = req or true
	
	if type(uid) ~= "string" or uid == "" then
		ChatPrint("uid error!!!")
		return nil
	end

	local userInfo = self.chatUserInfos[uid]
	if not userInfo then
		userInfo = self:CreateUserInfo()
		userInfo.uid = uid
		self.chatUserInfos[uid] = userInfo

		ChatPrint("This is new player uid : %s", uid)

		-- 同时去请求用户信息
		if req == true then
			self:requestUserInfo({uid})
		end
	end

	return userInfo
end

-- 预处理用户的信息
-- 没有的话，先从数据库取，还没有的话，直接去服务器请求
-- skipDB = bool，表示是否跳过数据库，强制去网络刷新（譬如数据库中存的是过期数据）
-- skipRemove = bool,表示是否跳过检查排除已有用户，通常是为了获取用户最新数据
function UserManager:requestUserInfo(idTable, skipDB, skipRemove)
	
	if type(idTable) ~= "table" then
		ChatPrint("requestUserInfo but type error!!")
		return 
	end
	
	skipDB = skipDB or false
	
	ChatPrint("preCacheUserInfo :" .. #idTable)

	if not skipRemove then
		-- 先处理一遍，把已经有了的用户排除掉
		self:__removeExistUserInfo(idTable)
	end
	
	if #idTable == 0 then
		return
	end
	
	if skipDB == true then
		self:__requestUserInfoFromNet(idTable)
	else
		-- 剩余的去数据库里找一遍，数据库返回之后，插入到用户表
		-- 如果还没有的话，就去网络请求
		-- 这里做一个closure把idTable传下去
		ChatManager2:GetInstance().DB:QueryUserInfos(idTable, 
			function (r)
				self:__onDBCacheUserInfo(idTable, r)
			end)
	end
end

-- 处理DB回来的UserInfo数据
function UserManager:__onDBCacheUserInfo(idTable, result)
	
	if result ~= nil then
		for _,userInfo in ipairs(result) do
			self:addChatUserInfo(userInfo)
		end
	
		-- 数据库也许只返回了部分的UserInfo，其余的要去网络查找
		self:__removeExistUserInfo(idTable)
	else
		ChatPrint("query user info error!")
	end

	-- 如果数据库已经都处理完了，那么久
	if #idTable > 0 then
		self:__requestUserInfoFromNet(idTable)
	else
		EventManager:GetInstance():Broadcast(EventId.UPDATE_MSG_USERINFO)
	end
end

-- 排除已经存在的用户
function UserManager:__removeExistUserInfo(idTable)
	if idTable == nil then
		return
	end
	
	-- 先处理一遍，把已经有了的用户排除掉
	-- 同时排除掉uid和写死的'system'
	table.removebyfunc(idTable, 
		function (uid)
			if ChatInterface.isChatGM(uid) then
				return true
			end
			
			if uid == 'system' then
				return true
			end
			
			local chatInfo = self.chatUserInfos[uid]
			if chatInfo and chatInfo.info_ok == true then
				return true
			end
		end)
end

--请求聊天室用户信息
function UserManager:__requestUserInfoFromNet(reqUserIds)

	if self.requestUser == false then
		ChatPrint("requestUserInfo but false!!!")
		return
	end
	
	ChatPrint("requestUserInfo to net.")

	local userIds = {}
	for _,uid in ipairs(reqUserIds) do
		if not self.fetchingUids[uid] then
			userIds[#userIds + 1] = uid
			self:__addFetchingUid(uid)
		end
	end

	if #userIds > 0 then
		ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GetUserInfoMulti, userIds)
	end
end

-- 网络用户数据返回
function UserManager:__onReceiveUserInfos(userTbls)
	ChatPrint("onReceiveUserInfos")

	if type(userTbls) ~= "table" then
		ChatPrint("UserManager:onReceiveUserInfos error")
		return
	end

	local chatUserInfos = {}
	
	for _,userTbl in ipairs(userTbls) do
		local uid = userTbl.uid
		self:__removeFetchingUid(uid)

		local tempUserInfo = self.chatUserInfos[uid]
		if tempUserInfo == nil then
			tempUserInfo = self:CreateUserInfo()
		end

		-- 解析用户数据本体
		tempUserInfo:onParseServerData(userTbl)
		-- 从网络收回来的数据也算info_ok = true
		tempUserInfo:SetInfoOK()

		self:addChatUserInfo(tempUserInfo)
		table.insert(chatUserInfos, tempUserInfo)
		EventManager:GetInstance():Broadcast(EventId.PlayerMessageInfo,uid)
	end

	-- 将用户数据插入数据库
	if #chatUserInfos > 0 then
		ChatPrint("insertuserinfos:" .. #chatUserInfos)
		ChatManager2:GetInstance().DB:InsertUserInfos(chatUserInfos,
			function (r)
				ChatPrint("insertuserinfos return: " .. tostring(r))
			end)
	end

	-- 最后通知用户信息修改
	EventManager:GetInstance():Broadcast(EventId.UPDATE_MSG_USERINFO)
end

-- 搜索用户数据返回
-- 注意这个信息相比请求玩家数据的信息要少很多，所以不能作为此用户信息完整！
-- 所以这个数据只能做一个临时数据
function UserManager:__onSearchUserInfos(userTbls)
	ChatPrint("__onSearchUserInfos")

	if type(userTbls) ~= "table" then
		ChatPrint("UserManager:__onSearchUserInfos error")
		return
	end

	for _,userTbl in ipairs(userTbls) do
		local uid = userTbl.uid

		local tempUserInfo = self.chatUserInfos[uid]
		if tempUserInfo == nil then
			tempUserInfo = self:CreateUserInfo()
		end

		-- 解析用户数据本体
		tempUserInfo:onParseServerData(userTbl)

		self:addChatUserInfo(tempUserInfo)
	end
end

-- 检测时间戳！！
-- 这个代码逻辑超级烂，但是没有办法，因为PlayerInfo没有发送lastUpdateTime的
-- 所以这里做一个关于头像的检测
-- 参数：picVer表示用户自定义头像的序列号；而pic表示系统头像的名称。（用户有可能换自定义或者系统头像）
function UserManager:CheckUserNameAndPicVer(uid, abbr, name, picVer, pic)
	abbr = abbr or ""
	name = name or ""
	picVer = picVer or 0
	pic = pic or ""
	
	local userInfo = self:getChatUserInfo(uid)
	if userInfo then
		-- 如果都相同的话，表示用户没有更新
		if userInfo.userName == name and
			userInfo.allianceSimpleName == abbr and
			userInfo.headPicVer == picVer and
			userInfo.pic == pic then
				return
			-- 其他情况就表示不同！
		end
		userInfo.info_ok = false
	end
	if uid ~= nil then
		ChatPrint("CheckLastUpdate request userinfo: " .. uid)
		self:requestUserInfo({uid}, true)
	end
end

-- 添加正在拉取信息的玩家id到缓存中
-- 主要是用来防止重复去服务器申请
function UserManager:__addFetchingUid(uid)
	self.fetchingUids[uid]  = true
end

function UserManager:__removeFetchingUid(uid)
	self.fetchingUids[uid]  = nil
end

-- 通过玩家名字获取uid
function UserManager:getUIDWithUserName(userName)
    local uid = ''
    if userName then
        local userArr = self.chatUserInfos
        if userArr then
            for key, value in pairs(userArr) do
                if value.userName == userName then
                    uid = key
                    break
                end
            end
        end
    end
    return uid
end

--[[ 
	添加senderInfo
	senderInfo是一个短小结构，里面仅包含了用户的名称和最后更新日期
	添加这个info，第一是让需要使用的时候，可以方便显示用户名字
	第二是如果最后更新日期有变化，表示用户数据修改过，需要去服务器重新拉取用户信息
]]
function UserManager:__processSenderInfo(uid, senderInfo)
	if senderInfo == nil then
		return 
	end
	
	local req = false
	local uinfo = self.chatUserInfos[uid]
	if uinfo then
		-- 注意这个地方不能判断 ~=，而是必须判断>
		if (senderInfo.lastUpdateTime ~= uinfo.lastUpdateTime) then
			if toInt(senderInfo.lastUpdateTime) > toInt(uinfo.lastUpdateTime) then
				req = true
			end 
		end
	else
		-- 这里理论上不会走到了
		uinfo = self:CreateUserInfo()
		uinfo.uid = uid
		uinfo.userName = senderInfo.userName
		uinfo.lastUpdateTime = senderInfo.lastUpdateTime
		uinfo.lang = senderInfo.lang
		uinfo.allianceSimpleName = senderInfo.abbr
		self:addChatUserInfo(uinfo)
		req = true
	end
	
	-- 如果需要信息请求的话，就去请求
	if req == true then
		uinfo.info_ok = false
		self:requestUserInfo({uid}, true)
	end
	
end


function UserManager:addChatUserInfo(chatUserInfo)
    if not chatUserInfo then 
        return 
    end 
    
	self.chatUserInfos[chatUserInfo.uid] = chatUserInfo
end

function UserManager:isExistUserInfoByUid(uid)
	return self:getChatUserInfo(uid) ~= nil
end

--举报消息
function UserManager:recordChatMsg(uid)
    if not table.hasvalue(self.reportedChatList,uid) then 
        table.insert(self.reportedChatList,uid);
    else
    end 
end

--消息是否是被举报的
function UserManager:isReportedChatMsg(uid)
    return table.hasvalue(self.reportedChatList,uid)
end

--举报头像
function UserManager:recordUserHead(uid )
    if not table.hasvalue(self.reportedUserHeadList,uid) then 
        table.insert(self.reportedUserHeadList,uid);
    end 
end

--是否是被举报的
function UserManager:isReportedUserHead(uid )
    return table.hasvalue(self.reportedUserHeadList,uid)
end

function UserManager:updateBanTime(uid,banTime)
    --self:getChatUserInfoAsync(uid ,function (userInfo)
        --if userInfo and userInfo.chatBantime ~= banTime then 
            --userInfo:setChatBantime(banTime)
            --self:saveToDB(userInfo)
        --end
    --end)
    
end


return UserManager


