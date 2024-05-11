--[[
    这个类是聊天的数据信息管理
    是从C#层 chatRoomManager.cs 搬过来的
]]

local ChatMessage = require "Chat.Model.ChatMessage"
local ChatRoomData = require "Chat.Model.ChatRoomData"
local rapidjson = require "rapidjson"
local Localization = CS.GameEntry.Localization
local ChatRoomManager = BaseClass("ChatRoomManager")

function ChatRoomManager:__init()
    self:resetData()
end

function ChatRoomManager:resetData()
    self.roomDatas = {}  -- 存放<string, ChatRoomData> 
	self.requestRoomMsg = {}  -- 正在请求聊天信息的房间列表
	self.diffServerTime  = 0
	
    -- 红包
    self.redpacks = {} -- 存放 <string, RedPackInfo>
	
    --个人聊天临时消息；因为要先创建房间再发送私聊；但是在UI上是同时进行，所以要先缓存一下
    self.personTempMsgTab = {}

    -- 存放 <roomId,time>   用于处理红点
    self.timeStamps = {}  
	
	-- 世界频道的名称
	self.countryRoomId = ""
	-- 当前联盟频道的名称
	self.allianceRoomId = ""
	
	self.crossServerRoomId = ""
	--语言频道的名称
	self.langRoomId = ""
	-- 存储我的正在发送中消息
	self.sendingDataArr = {}   
	self.sendingIndex = 1

	-- 游戏初始时的房间缓存
	self.cacheRoomInfos = nil
end

function ChatRoomManager:CreateChatRoomData(roomId, group)
	return ChatRoomData.New(roomId, group)
end

function ChatRoomManager:CreateChatMessage()
	return ChatMessage.New()
end

--[[
    跃猛说:
    游戏服务器时间调慢了2个小时
    服务器时间0点  是北京时间的8点，好多活动会在0点重置。那时我们都没上班，出了问题也没人管。所以调慢了，10点
    所以下面的时间调整下
]]
function ChatRoomManager:UpdateChatServerTime(time)
    self.diffServerTime  = time - os.time()
    ChatPrint("聊天服务器时间差值：%d",self.diffServerTime)
end

function ChatRoomManager:getChatServerTime()
    return self.diffServerTime  + os.time()
end


-- 整个聊天房间初始化
function ChatRoomManager:Init()
	if tonumber(ChatInterface.getPlayerServerId()) == 0 then
		return
	end
	
	ChatPrint("-------------初始化聊天所有房间----------")
	
	
	local defaultRoom = self:GenCountryRoomId()
	self.countryRoomId = defaultRoom
	
	self:CreateChatRoom(defaultRoom, ChatGroupType.GROUP_COUNTRY, true)
	self:AddAllianceRoom(true)
	self:AddCrossServerRoom(true)
	self:AddLangRoom(true)
	self:AddDragonRoom(true)
	self:AddEdenCampRoom(true)
end

-- 获取房间id
function ChatRoomManager:GetCountryRoomId()
	return self.countryRoomId
end

-- 获取联盟id
function ChatRoomManager:GetAllianceRoomId()
	return self.allianceRoomId
end
function ChatRoomManager:GetCrossServerRoomId()
	 return self.crossServerRoomId
end
function ChatRoomManager:GetDragonServerRoomId()
	return self.dragonRoomId
end
function ChatRoomManager:GetEdenCampRoomId()
	return self.edenCampRoomId
end
function ChatRoomManager:GetLangRoomId()
	return self.langRoomId
end
-- 获取发送id
function ChatRoomManager:GetSendingIndex()
	return self.sendingIndex
end

-- 添加联盟频道
-- init初始的时候，如果有联盟，需要去数据库拉消息；其他时候不用
function ChatRoomManager:AddAllianceRoom(pullDBMsg)
	if ChatInterface.isInAlliance() then
		self.allianceRoomId = self:GenAllianceRoomId()
		return self:CreateChatRoom(self.allianceRoomId, ChatGroupType.GROUP_ALLIANCE, pullDBMsg)
	end
	return nil
end

function ChatRoomManager:AddCrossServerRoom(pullDBMsg)
	if ChatInterface.isCrossServerOpen() then
		self.crossServerRoomId = self:GenCrossServerRoomId()
		return self:CreateChatRoom(self.crossServerRoomId, ChatGroupType.GROUP_CROSS_SERVER, pullDBMsg)
	end
	return nil
end

function ChatRoomManager:AddDragonRoom(pullDBMsg)
	if ChatInterface.isDragonServerOpen() then
		self.dragonRoomId = self:GenDragonRoomId()
		return self:CreateChatRoom(self.dragonRoomId, ChatGroupType.GROUP_DRAGON_SERVER, pullDBMsg)
	end
	return nil
end

function ChatRoomManager:AddEdenCampRoom(pullDBMsg)
	if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
		local selfCamp = DataCenter.RobotWarsManager:GetSelfCamp()
		if selfCamp and selfCamp ~= -1 then
			self.edenCampRoomId = self:GenEdenCampRoomId(selfCamp)
			return self:CreateChatRoom(self.edenCampRoomId, ChatGroupType.GROUP_EDEN_CAMP, pullDBMsg)
		end
		
	end
	return nil
end

function ChatRoomManager:AddLangRoom(pullDBMsg)
	if ChatInterface.isLangOpen() then
		self.langRoomId = self:GenLangRoomId()
		return self:CreateChatRoom(self.langRoomId, ChatGroupType.GROUP_CUSTOM, pullDBMsg)
	end
	return nil
end

-- 删除联盟频道
function ChatRoomManager:RemoveAllianceRoom()
	local roomId = self:GetAllianceRoomId()
	self:RemoveRoomData(roomId)
	self.allianceRoomId = ""
end
function ChatRoomManager:RemoveCrossServerRoom()
	local roomId = self:GetCrossServerRoomId()
	self:RemoveRoomData(roomId)
	self.crossServerRoomId = ""
end

function ChatRoomManager:RemoveDragonSeverRoom()
	local roomId = self:GetDragonServerRoomId()
	self:RemoveRoomData(roomId)
	self.dragonRoomId = ""
end

-- 是否有联盟频道
function ChatRoomManager:HasAllianceRoom()
	local roomId = self:GetAllianceRoomId()
	local room = self:GetRoomData(roomId)
	if room then
		return true
	end
	
	return false
end

function ChatRoomManager:HasCrossServerRoom()
	local roomId = self:GetCrossServerRoomId()
	local room = self:GetRoomData(roomId)
	if room then
		return true
	end

	return false
end

--添加临时私人聊天信息  LF的私人聊天频道创建是先发消息再创建房间 
function ChatRoomManager:addTempPersonMsg(uid, msg)
	local t = self.personTempMsgTab[uid] or {}
	table.insert(t, msg)
	self.personTempMsgTab[uid] = t
	return
end

function ChatRoomManager:getTempPersonMsg(uid)
    return self.personTempMsgTab[uid]
end

function ChatRoomManager:clearTempPersonMsg(uid)
    self.personTempMsgTab[uid] = nil
end


---释放数据  用于切号的时候
function ChatRoomManager:releaseData()
    self:resetData()
end

function ChatRoomManager:ClearRooms()
    self.roomDatas = {}
end

function ChatRoomManager:GetRoomIdPrefix()
    if not ChatInterface.isExternalNetDebug() and ChatInterface.isDebug() then 
        return "test_"
    end 
    return ""
end

function ChatRoomManager:GenCountryRoomId()
    local serverId = ChatInterface.getPlayerServerId()
    ChatPrint("SelfServerId = %d",serverId);
    return string.format("%scountry_%d", self:GetRoomIdPrefix(), serverId);
end

-- 生成allianceId，应该是固定格式的处理
function ChatRoomManager:GenAllianceRoomId()
    local sid = ChatInterface.getSrcServerId()
	local aid = ChatInterface.getAllianceId()
    return string.format("%salliance_%d_%s", self:GetRoomIdPrefix(), sid, aid);
end

function ChatRoomManager:GenCrossServerRoomId()
	local cid = ChatInterface.getCrossServerIdFlag()
	return string.format("%scustom_crossbattle_%s", self:GetRoomIdPrefix(),cid);
end

function ChatRoomManager:GenLangRoomId()
	local serverId = ChatInterface.getPlayerServerId()
	local sendLang = ChatManager2:GetInstance().Translate:GetLangString(ChatInterface.getLanguageName())
	if string.find(sendLang,"zh") then
		sendLang = "zh-Hant"
	end
	local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
	if seasonId >= 2 and seasonId <= 4 then
		local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.RobotWars.Type)
		if dataList ~= nil and dataList[1] and next(dataList[1]) then
			local data = dataList[1]
			local groupId = data.groupId
			if groupId~=nil then
				return string.format("%scustom_lang_%s_g%s",self:GetRoomIdPrefix(),sendLang,data.groupId);
			end
			
		end
	end
	return string.format("%scustom_lang_%s_%s",self:GetRoomIdPrefix(),sendLang,serverId);
end

function ChatRoomManager:GenDragonRoomId()
	local serverId = LuaEntry.Player:GetCurServerId()
	local worldId = LuaEntry.Player:GetCurWorldId()
	return string.format("%scustom_starwar_%s_%s",self:GetRoomIdPrefix(),serverId,worldId);
end
function ChatRoomManager:GenEdenCampRoomId(camp)
	local serverId = LuaEntry.Player:GetCurServerId()
	return string.format("%scustom_eden_camp_%s_%s",self:GetRoomIdPrefix(),camp,serverId);
end
function ChatRoomManager:GetAllianceRoomData()
    local allianceID = self:GenAllianceRoomId()
    local allianceRoom = self:GetRoomData(allianceID)
    return allianceRoom
end

---获取所有房间的房间数据----
function ChatRoomManager:GetRoomDatas()
    return table.values(self.roomDatas)
end

function ChatRoomManager:GetPrivateRoomByUserId( userId )
	local temp = self:GetRoomDatas()
	for k,roomData in pairs(temp) do
		if (roomData:isPrivateChat()) then
			local memlist = roomData:getMemberList()
			for _, memId in pairs(memlist) do
				if (memId == userId) then
					return roomData.roomId
				end
			end
		end
	end
	return ""
end

-- 获取可以分享的房间列表
function ChatRoomManager:GetShareRoom()
	local shareRooms = self:GetSortRoomDatas()
	local tabArray = {}
	for _, room in pairs(shareRooms) do
		if (not room:IsGmRoom()) and room:getRoomGroup() ~= ChatGroupType.GROUP_CROSS_SERVER then
			tabArray[#tabArray+1] = room
		end
	end
	return tabArray
end

--检查世界聊天是否存在
function ChatRoomManager:CheckGroupCountry()
	local rooms = self:GetSortRoomDatas()
	for _, room in pairs(rooms) do
		if room:getRoomGroup() == ChatGroupType.GROUP_COUNTRY then
			return true
		end
	end
	return false
end

---获取所有房间的房间数据----
function ChatRoomManager:GetSortRoomDatas()
	local temp = self:GetRoomDatas()
	local mainLv = DataCenter.BuildManager.MainLv
	local roomArray = {}
	for k,v in pairs(temp) do
		if (v:getRoomGroup() == ChatGroupType.GROUP_COUNTRY) then
			if (mainLv >= ChatChannelShowMinLevel) then
				table.insert(roomArray, v)
			end
		else
			table.insert(roomArray, v)
		end
	end

	-- ldata及rdata都是roomData
	table.sort(roomArray,
			function (ldata, rdata)
				if ldata.roomId == QuestRoomId then
					return true
				end
				if rdata.roomId == QuestRoomId then
					return false
				end
				local ldataGroupId = ChatGroupId[ldata.group] or 10000
				local rdataGroupId = ChatGroupId[rdata.group] or 10000
				if ldata.group == ChatGroupType.GROUP_EDEN_CAMP then
					ldataGroupId = 1.4
				end
				if rdata.group == ChatGroupType.GROUP_EDEN_CAMP then
					rdataGroupId = 1.4
				end
				if ldataGroupId == ChatGroupId[ChatGroupType.GROUP_CUSTOM] and string.find(ldata.roomId,"lang") then
					ldataGroupId = 1.5
				end
				if rdataGroupId == ChatGroupId[ChatGroupType.GROUP_CUSTOM] and string.find(rdata.roomId,"lang") then
					rdataGroupId = 1.5
				end
				if ldataGroupId < rdataGroupId then
					return true
				elseif ldataGroupId > rdataGroupId then
					return false
				elseif ldataGroupId == ChatGroupId[ChatGroupType.GROUP_CUSTOM] and 
						rdataGroupId == ChatGroupId[ChatGroupType.GROUP_CUSTOM] then
					local l_IsGMRoom = ldata:IsGmRoom()
					local r_IsGMRoom = rdata:IsGmRoom()
					if (l_IsGMRoom == true and r_IsGMRoom) then
						return false
					elseif l_IsGMRoom then
						return true
					elseif r_IsGMRoom then
						return false
					end
				end
				return ldata:GetLastChatTime() > rdata:GetLastChatTime()
			end)

	return roomArray
end

function ChatRoomManager:IsExistRoomId(roomId)
    for k, v in pairs(self.roomDatas) do
        if roomId == k then 
            ChatPrint("已经存在房间id : %s",roomId)
            return true
        end
    end
    return false
end

-- 是否存在GM频道 true存在,false不存在
function ChatRoomManager:IsExistGmChannel()
	local temp = self:GetRoomDatas()
	for k,roomData in pairs(temp) do
		if (roomData:IsGmRoom()) then
			return true
		end
	end
	return false
end

-- 请求自定义房间OK（只处理第一次情况）
function ChatRoomManager:onJoinRoomOK()
	-- 合并一下和现在数据库的房间
	self:__syncFromCache()	
	
	-- 所有房间都保存起来
	self:SaveRoomDatas()
end

-- 创建一个房间，如果有的话，返回新房间
function ChatRoomManager:CreateChatRoom(roomId, group, queryDB)
	local isNew = false
	local room = self:GetRoomData(roomId)
	if (room == nil) then
		room = self:CreateChatRoomData(roomId, group)
		self.roomDatas[roomId] = room
		isNew = true
		
		ChatPrint("createChatRoom: " .. roomId)
		
		-- 每次创建房间之后，就直接去DB获取最新数据
		--if queryDB == true then
			--ChatManager2:GetInstance().DB:QueryLatestChat(roomId, 
				--function (results)
					--if results == nil then 
						--ChatPrint("QueryLatestChat error!!!!!")
						--return 
					--end
					--self:onDBLatestChat(roomId, results)
				--end)
		--end
	else
		ChatPrint("createChatRoom but exist!!! : " .. roomId)
	end
	
	return room, isNew
end

-- 最新的数据库聊天信息返回，
-- 聊天最新数据返回之后发一个刷新消息
function ChatRoomManager:onDBLatestChat(roomId, results)
	ChatPrint("onDBLatestChat: " .. roomId .. ", results: " .. #results)
	if #results == 0 then
		return
	end
	
	local room = self:GetRoomData(roomId)
	if room == nil then
		ChatPrint("no room???!!!")
		return
	end
	
	-- 插入到聊天频道里
	room:__addChatDatas(results)
	
	-- 从数据库请求的聊天消息回来，也需要检测一下是否有这个用户消息
	-- 有这种情况：请求聊天数据回来，插库之后，再去请求用户数据，但是用户数据还没返回的时候关游戏
	--if #self.requestRoomMsg == 0 then
		--local UserMgr = ChatManager2:GetInstance().User
		--User:processAllUserInfos()
	--end
end

-- 请求多个房间的最近20条聊天数据
-- 一般就是刚进入游戏的时候处理的
function ChatRoomManager:requestMultiRoomLatestMsg(roomIds)
	
	if roomIds == nil then
		ChatPrint("requestMultiRoomLatestMsg param error!")
		return
	end
	
	-- 首先排除已经正在申请的
	table.removebyfunc(roomIds, 
		function (roomId)
			if table.hasvalue(self.requestRoomMsg, roomId) then
				return true
			end
			if roomId == QuestRoomId then
				return true
			end
		end)
	
	if #roomIds > 0 then
		ChatPrint("requestMultiRoomLatestMsg")
		table.insertto(self.requestRoomMsg, roomIds)
		ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, roomIds)
	end
	return true
end


function ChatRoomManager:requestLatestMsg(roomId)
	if table.hasvalue(self.requestRoomMsg, roomId) then
		return false
	end
	
	table.insert(self.requestRoomMsg, roomId)
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {roomId})
	return true
end

-- 请求房间信息回来
function ChatRoomManager:onRequestLatestMsg(serverData)
		
	ChatPrint("onRequestLatestMsg")
	
	if (serverData.result.rooms == nil) then
		ChatPrint("request error!")
		return 
	end
	
	for _,data in pairs(serverData.result.rooms) do
		local roomData = self:GetRoomData(data.roomId)
		if roomData == nil then
			--roomData = self:createChatRoom(data)
			ChatPrint("no room?? error !!")
		end
		roomData:onParseServerData(data)
		self:onParseServerChatData(data.roomId, data.msgs)
		
		table.removebyvalue(self.requestRoomMsg, data.roomId)
	end
	
	-- 如果请求的都回来了，统一处理一下
	if #self.requestRoomMsg == 0 then
		local User = ChatManager2:GetInstance().User
		User:SetRequestUserInfo(true)
	end

	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_UPDATE_ROOM_HISTORY_MSG)
end

-- 处理登录请求的一批网络回来的聊天消息
function ChatRoomManager:onParseServerChatData(roomId, msgs)
	
	ChatPrint("onParseServerChatData : roomId = " .. roomId .. ", count = " .. #msgs)
	
	local room = self:GetRoomData(roomId)
	local isPrivateChat = room:isPrivateChat()
	local UserMgr = ChatManager2:GetInstance().User
	
	-- FXIME: 从网络回来的消息要强制覆盖本地的
	-- 因为目前聊天还有翻译等数据暂时没有，所以这里先不处理
	
	local addChats = {}
	local index = 1
	for i = 1, #msgs do
				
		---- 解析聊天数据本体数据
		local newchatData = self:CreateChatMessage()
		newchatData:onParseServerData(msgs[i])
		if (newchatData.post ~= PostType.Text_Normal and 
			newchatData.post ~= PostType.Text_ChatRoomSystemMsg and
			--newchatData.post ~= PostType.Text_MemberJoin and
			newchatData.post ~= PostType.Text_MemberQuit and 
			newchatData.post ~= PostType.Text_FightReport and
			newchatData.post ~= PostType.Text_FBAlliance_missile_share and
			newchatData.post ~= PostType.Text_Formation_Fight_Share and 
			newchatData.post ~= PostType.Text_MailScoutResultShare and 
			newchatData.post ~= PostType.Text_AllianceTaskShare and 
			newchatData.post ~= PostType.Text_Formation_Share and
			newchatData.post ~= PostType.Text_ChampionBattleReportShare and
			newchatData.post ~= PostType.RedPackge and
			newchatData.post ~= PostType.Text_PointShare and
			newchatData.post ~= PostType.Text_AllianceRecruitShare and
			newchatData.post ~= PostType.Text_BattleReportContentShare and
			newchatData.post ~= PostType.Text_ScoutReportContentShare and
			newchatData.post ~= PostType.Text_ScoutAlertContentShare and
			newchatData.post ~= PostType.Text_ActMonsterTowerHelp and
		    newchatData.post ~= PostType.Text_MsgShare and 
				newchatData.post ~= PostType.Text_Missile_Attack) then
			goto continue
		end
		if ChatManager2:GetInstance().Restrict:isInRestrictList(newchatData.senderUid, RestrictType.BLOCK) then
			goto continue
		end
		ChatPrint("++ msg seqId(%d), time : %f", 
			newchatData:getSeqId(), 
			newchatData:getServerTime())
		
		if self:AddChat(newchatData, false) then
			table.insert(addChats, newchatData)
		end
		
		::continue::
	end

	-- 把增加的聊天数据入库
	if #addChats > 0 then
		ChatManager2:GetInstance().DB:InsertChatInfos(addChats)
	end
	
	room:sort()
	
	room:PrintRoomMsgTime()
end

-- 获取某个房间的所有消息的所有用户
-- tbl 必须是一个table
function ChatRoomManager:GetAllUserInRoom(roomId, tbl)
	if type(tbl) ~= "table" then
		return
	end	
	
	local roomData = self:GetRoomData(roomId)
	if (roomData == nil) then
		return
	end
	
	-- 插入到当前表里
	for _, msg in ipairs(roomData.msgs) do
		if not table.hasvalue(tbl, msg.senderUid) then
			table.insert(tbl, msg.senderUid)
		end
	end
	
end

-- 获取所有房间的所有消息的所有用户
-- tbl 必须是一个table
function ChatRoomManager:GetAllUserInRooms(tbl)
	for _, room in pairs(self.roomDatas) do
		self:GetAllUserInRoom(room.roomId, tbl)
	end
	
	return tbl
end


----更新历史聊天信息 同时请求聊天成员信息
--function ChatRoomManager:SetRoomHistory(roomId, chatDataList, saveToDatabase)
    ---- local userIds = {} 
    ---- local temp = {}
    --for _, v in ipairs(chatDataList) do
        --self:AddChat(v)
        ---- local isExistUserInfo = ChatInterface.getUserManagerInst():isExistUserInfoByUid(_chatData.senderUid)
        ---- if not temp[_chatData.senderUid] and not isExistUserInfo then 
        ----     table.insert(userIds,_chatData.senderUid)
        ----     temp[_chatData.senderUid] = true
        ---- end 
    --end

    --if saveToDatabase then 
        ----local roomData = self:GetRoomData(roomId)
        ----if roomData then 
            ----roomData:saveAllChatsToDB(chatDataList)
        ----end 
		--ChatManager2:GetInstance().DB:InsertChatInfos(chatDataList)
    --end 


    ---- if #userIds > 0 then 
    ----     ChatInterface.getUserManagerInst():requestUserInfo(userIds)
    ---- end 


    --self:GetLast2MsgChat(roomId)
   
--end


---根据id 获取房间数据
function ChatRoomManager:GetRoomData(roomId)
    if type(roomId) ~= "string" then 
    	printError("ChatRoomManager:GetRoomData error !!!!!!!!!!!")
		return nil
    end 
	
	local t = self.roomDatas[roomId]
    return t
end 

--移除房间
function ChatRoomManager:RemoveRoomData(roomId)
	ChatPrint("RemoveRoomData:" .. roomId)
	local t = self.roomDatas[roomId]
	self.roomDatas[roomId] = nil
	
	ChatManager2:GetInstance().DB:RemoveChatRoom(roomId)
end

---添加发送中的消息---
function ChatRoomManager:__addSendingData(chatData)
	table.insert(self.sendingDataArr,chatData)
end

----移除发送中的消息----
function ChatRoomManager:__removeSendingChat(chatData)
	table.removebyvalue(self.sendingDataArr,chatData)
end

---查找发送中的消息---
function ChatRoomManager:__findSendingData(chatData)
	local findChatData = nil
	for k,v in pairs(self.sendingDataArr) do
		if v.sendLocalTime == chatData.sendLocalTime and
			v.senderUid == chatData.senderUid then
			findChatData = v
			break
		end
	end

	return findChatData
end

-- 设置用户缓存的房间
function ChatRoomManager:SetCacheRoomInfos(roomInfos)
	local t = {}
	table.walk(roomInfos, 
		function(k, v)
			t[v.roomId] = v
		end)
	self.cacheRoomInfos = t
end

--[[
	缓存房间和线上返回的房间列表相比较处理
 	主要有几件事
	1. 把数据库记录的最后一次点击房间频道的时间设置给房间（红点）
	2. 如果缓存有但是服务器没有，表示你被踢出房间（这个可能暂时不需要？）
	3. 如果缓存没有但是服务器有，表示你离线的时候被加入房间了
]]
function ChatRoomManager:__syncFromCache()
	
	if table.IsNullOrEmpty(self.roomDatas) or table.IsNullOrEmpty(self.cacheRoomInfos) then
		ChatPrint("__syncFromCache nil")
		return 
	end
	
	-- 目前主要是取最后点击时间和pin状态
	table.walk(self.roomDatas,
		function (k, v)
			local cache = self.cacheRoomInfos[k]
			if cache then
				v:SetLastClickTime(cache.lastClickTime)
				v:SetPin(cache.isPin)
			end
		end)

end

function ChatRoomManager:__syncToCache()
	if table.IsNullOrEmpty(self.roomDatas) or table.IsNullOrEmpty(self.cacheRoomInfos) then
		ChatPrint("__syncFromCache nil")
		return
	end

	table.walk(self.roomDatas,
		function (k, v)
			local cache = self.cacheRoomInfos[k]
			if cache then
				cache.lastClickTime = v.lastClickTime
				cache.isPin = v.isPin
			end
		end)

end

-- 添加我发送的聊天
function ChatRoomManager:AddSendingChat(chatData)
	if self:AddChat(chatData, true) then
		if chatData.sendState == SendStateType.PENDING then
			self:__addSendingData(chatData)
		end
	end
	self.sendingIndex = self.sendingIndex + 1
end


function ChatRoomManager:AddChat(chatData, inDB)
    if chatData == nil then 
		return false
	end
	
	local roomData = self:GetRoomData(chatData.roomId)
	if not roomData then
		return false
	end
	
	local ret = roomData:__addChatData(chatData)
	
	-- 请求该条目的玩家信息
	local userMgr = ChatManager2:GetInstance().User
    local chatUserInfo = userMgr:getChatUserInfo(chatData.senderUid)
    if not chatUserInfo then 
		userMgr:requestUserInfo({ chatData.senderUid })
    end 
	
	-- 是否入库
	if inDB ~= nil and inDB == true then
		ChatManager2:GetInstance().DB:SaveChatItem(chatData,
			function (r)
			end)
	end
	
	return ret
end

----根据组类来获取房间数据
function ChatRoomManager:GetRoomDataByGroup(group)
    for roomId , roomData in pairs(self.roomDatas) do
        if roomData.group == group then 
            --roomData:sort()
            return roomData
        end 
    end 
    return nil 
end

---获取拥有的房间数
function ChatRoomManager:GetOwnerRoomCount()
    local playerUid = ChatInterface.getPlayerUid()
    local ownerRoomNum = 0
    for roomId , roomData in pairs(self.roomDatas) do
        if roomData.owner == playerUid then 
            ownerRoomNum = ownerRoomNum + 1
        end 
    end 
    return ownerRoomNum
end


function ChatRoomManager:UserBanTime(uid)
    local chatUserInfo = ChatInterface.getUserManagerInst():getChatUserInfo(uid)
    if chatUserInfo then 
        return chatUserInfo.chatBantime
    end
    return 0  
end

--根据seqId 获取聊天信息
function ChatRoomManager:GetChat(roomId,seqId)
    local roomData = self:GetRoomData(roomId)
	if roomData~=nil then
		return roomData:getChatDataBySeqId(seqId)
	end
    return nil
end

function ChatRoomManager:UpdateChatData(chatData)
	if not chatData then
		ChatPrint("服务器返回发送失败的result，目前没有")
		return
	end

	ChatPrint("服务器返回消息")

	-- 移除正在发送的数据
	local findChatData = self:GetChat(chatData.roomId,chatData.seqId)
	if findChatData then
		local oldSeqId = findChatData.seqId
		findChatData.seqId = chatData.seqId
		findChatData.serverTime = chatData.serverTime
		findChatData.interactLike = chatData.interactLike
		findChatData.interactDisLike = chatData.interactDisLike
		findChatData:setSendState(SendStateType.OK)
		ChatManager2:GetInstance().DB:UpdateChatData(oldSeqId, findChatData)
	else
		ChatPrint("UpdateSendingChat but not found ?!!!")
	end

end

--根据房间号获取最后一条聊天信息
function ChatRoomManager:GetLastChatByRoom(roomId)
    local roomData = self:GetRoomData(roomId)
    if roomData then
        return roomData:getLastChatData()
    end 
    return nil
end
----获取当前所在房间最后一条聊天信息
--function ChatRoomManager:GetLastChat()
    --return self:GetLastChatByRoom(self.currentRoomId);
--end

function ChatRoomManager:GetLast2MsgChat(roomId)
    local roomData = self:GetRoomData(roomId)
	local msglist = {}
    if roomData then--and (roomData.group == ChatGroupType.GROUP_ALLIANCE or roomData.group == ChatGroupType.GROUP_COUNTRY) 
		--msglist = roomData:GetLastChatDatas(true, 3)
		msglist = roomData:GetLastChatDatas(true, 1)
    end
	return msglist
end

function ChatRoomManager:GetLastUnblockedChat()
    local lastChatData = self:GetLastChat()
    --这个先不翻译 不知道什么意思
    -- while (last != null /*&& customData.ChatShieldInfo.IsShield(last.senderUid)*/)
    --     {
    --         last = GetChat(last.roomId, last.sequenceId - 1);
    --     }
    return  lastChatData;
end

-- 是否有自定义房间
function ChatRoomManager:HasCustomRoom()
	for _ , roomData in pairs(self.roomDatas) do
		if roomData.group == ChatGroupType.GROUP_CUSTOM then
			return true
		end
	end
	return false
end

--[[
    发送消息回调 会调用此方法 更新聊天数据
	主要是处理我自己发送的消息
]]
function ChatRoomManager:UpdateSendingChat(chatData)
    if not chatData then 
        ChatPrint("服务器返回发送失败的result，目前没有")
        return 
    end 
	
    ChatPrint("服务器返回消息")
	
	-- 移除正在发送的数据
    local findChatData = self:__findSendingData(chatData)
    if findChatData then 
		
		-- 此时的findChatData就是之前发送的数据引用
		local oldSeqId = findChatData.seqId
		findChatData.seqId = chatData.seqId
		-- 这一步很关键，因为之前自己的消息都是客户端模拟的，
		-- 所以这里要把这个从服务器返回的时间进行校正
		findChatData.serverTime = chatData.serverTime
		findChatData.interactLike = chatData.interactLike
		findChatData.interactDisLike = chatData.interactDisLike
		findChatData:setSendState(SendStateType.OK)
		ChatManager2:GetInstance().DB:UpdateChatData(oldSeqId, findChatData)
		self:__removeSendingChat(findChatData)
    else
		ChatPrint("UpdateSendingChat but not found ?!!!")
	end
	
end

-- 获取所有房间新消息的数量
function ChatRoomManager:GetAllRoomNewMsgCount()
    local count = 0
    local roomDatas = self:GetRoomDatas()
    for _, roomData in ipairs(roomDatas) do
        count = count + roomData:getNewMsgNum()
    end
    return count
end

--获取私聊的未读消息数量
--function ChatRoomManager:GetPrivateRoomsNewMsgCount()
    --local count = 0
    --local roomDatas = self:GetRoomDatas()
    --for _, roomData in ipairs(roomDatas) do
        --if roomData:isPrivateChat() then 
            --count = count + roomData:getNewMsgNum()
        --end 
    --end
    --return count
--end

--添加红包
function ChatRoomManager:AddRedpack(pack)
    if not self.redpacks[pack.uuid] then 
        self.redpacks[pack.uuid] = pack
    end 
end 


function ChatRoomManager:GetRedpack(uuid)
    return self.redpacks[uuid]
end

--刷新红包状态 红包id_serverid|status
function ChatRoomManager:refreshRedPacketStatus(redPacketAttachmentIdStr)
    ChatPrint("redPacketAttachmentIdStr = %s",redPacketAttachmentIdStr)
    local updateRedPaketAttachId = function (roomData,attachmentId,where)
        local dbChatDatas = roomData:searchByWhere(where)
        if dbChatDatas ~= nil then
            for i = 1, #dbChatDatas do 
                local chatData = roomData:getChatDataBySeqId(dbChatDatas[i].seqId)  
                if not chatData then 
                    chatData = self:CreateChatMessage() --ChatMessage.New()
                end 
                --chatData:parseDBData(dbChatDatas[i])
                local tArr = string.split(chatData.attachmentId,"|")
                chatData.attachmentId = attachmentId
                if #tArr == 3 then 
                    chatData.attachmentId = string.format("%s|%s",chatData.attachmentId,tArr[3])
                end 
                --chatData:saveToDB()
				
				ChatManager2:GetInstnce().DB:SaveChatItem(chatData)
            end 
        end
    end
    local attachmentArr = string.split(redPacketAttachmentIdStr,",")
    for _,attachmentId in pairs(attachmentArr) do 
        local attachArr = string.split(attachmentId,"|")
        -- ((post ='12' AND ( attachmentId LIKE '%d2a39ef9d7fe46bc9979e0616a94264e_1%')))
        local attachMentIDString = "%" .. attachArr[1] .. "%";
        local where = string.format("((post ='%s' AND ( attachmentId LIKE '%s')))",PostType.RedPackge,attachMentIDString)
        local countryRoomData = self:GetRoomDataByGroup(ChatGroupType.GROUP_COUNTRY)
        if countryRoomData then 
            updateRedPaketAttachId(countryRoomData,attachmentId,where)
        end 

        local allianceRoomData = self:GetRoomDataByGroup(ChatGroupType.GROUP_ALLIANCE)
        if allianceRoomData then 
            updateRedPaketAttachId(allianceRoomData,attachmentId,where)
        end 
    end 
    
end

--获取私聊房间频道
function ChatRoomManager:getPrivateRoomData(toUid)
    if string.IsNullOrEmpty(toUid) or ChatInterface.getPlayerUid() == toUid then 
        return nil
    end 
    local roomDatas = self:GetRoomDatas()
    for _, roomData in ipairs(roomDatas) do
        if roomData:isPrivateChat() then 
            if string.find(roomData.roomId, toUid) then 
                return roomData
            end 
        end 
    end
    return nil
end

function ChatRoomManager:GetCanShareChannel()
    local values = {}
    for k, v in pairs(self.roomDatas) do
        values[#values + 1] = v
    end
    return values
end

-- 保存房间信息
function ChatRoomManager:SaveRoomDatas()
	-- 每次保存的时候先做一个缓存
	self:__syncToCache()
	ChatManager2:GetInstance().DB:InsertRoomDatas(self.roomDatas)
end

function ChatRoomManager:GetMyCreateRooms()
	local list = {}
	for _, roomData in pairs(self.roomDatas) do
		if not roomData:isPrivateChat() and roomData.owner == LuaEntry.Player.uid then
			table.insert(list, roomData)
		end
	end
	return list
end

return ChatRoomManager

