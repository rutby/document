--[[
    这个类是房间的数据结构
    是从C#层 chatRoomManager.cs 拆出来的
    有的变量名词不达意！！！先还原之后再说吧
]]

local ChatRoomData = BaseClass("ChatRoomData")
local rapidjson = require "rapidjson"
local Localization = CS.GameEntry.Localization
--没备注是因为我也不知道具体什么意思
function ChatRoomData:__init(roomId,group)
    self.roomId     = roomId or ""    --房间id
    self.group      = group or ""    --聊天室类别  竞技场 国家 联盟  战区聊天室 自定义等等
    self.owner      = ""             --房主uid
    self.firstSeqId = 0
    self.lastSeqId  = 0
    self.firstMsgTime = 0           -- 服务器最小时间戳(浮点数)
    self.lastMsgTime  = 0           -- 服务器最大时间戳(浮点数)
    self.appId      = ""            -- appId
    self.name       = ""            -- 如"CHAT_SYSTEM"
    self.msgs         = {}          --存储ChatMessage数据结构链表 
    self.memberList   = {}          --成员id列表 存储stirng 数组
	self.lastClickTime = 0			-- 频道最后点击的时间，和红点有关系（浮点数）
    if self.roomId~=nil and self.roomId~="" then
        local time = tonumber(Setting:GetPrivateString("ChatRoomClickTime"..self.roomId, ""))
        if time~=nil and time>0 then
            self.lastClickTime = time
        end
    end
    
	self.isPin		= 0			-- 是否锁定
	self.info_ok	= false			-- 频道还没有
end

function ChatRoomData:setGroup(group)
    self.group = group
end

--是否是自定义房间
function ChatRoomData:isCustomRoom()
    return self.group == ChatGroupType.GROUP_CUSTOM
end

function ChatRoomData:setAppId(appId)
    self.appId = appId
end

--是不是房主
function ChatRoomData:isMyCreateRoom()
    return self.owner == ChatInterface.getPlayerUid()
end

function ChatRoomData:setName(name)
    self.name = name
end

---设置聊天数据
function ChatRoomData:onParseServerData(roomData)
    if type(roomData) ~= "table" then 
        return
    end 
    -- table_merge(self, roomData)
    if roomData.roomId then 
        self.roomId = roomData.roomId
    end
    if roomData.group then 
        self.group = roomData.group
        if self.group == ChatGroupType.GROUP_CUSTOM then --跨服聊天特殊处理一下
            if string.contains(self.roomId, ChatGroupType.GROUP_CROSS_SERVER) then
                self.group = ChatGroupType.GROUP_CROSS_SERVER
            elseif string.contains(self.roomId,ChatGroupType.GROUP_DRAGON_SERVER) then
                self.group = ChatGroupType.GROUP_DRAGON_SERVER
            elseif string.contains(self.roomId,ChatGroupType.GROUP_EDEN_CAMP) then
                self.group = ChatGroupType.GROUP_EDEN_CAMP
            end
        end
    end 

    if roomData.firstSeqId then 
        self.firstSeqId = roomData.firstSeqId
    end

    if roomData.lastSeqId then 
        self.lastSeqId = roomData.lastSeqId
    end

    if roomData.firstMsgTime then 
        self.firstMsgTime = roomData.firstMsgTime
    end 

    if roomData.lastMsgTime and roomData.lastMsgTime>0 then 
        self.lastMsgTime = roomData.lastMsgTime
    end

    if roomData.appId then 
        self.appId = roomData.appId
    end

    if roomData.name and roomData.name ~= "CHAT_SYSTEM" then 
        self.name = roomData.name
    end

    if roomData.owner and roomData.owner ~= "CHAT_SYSTEM" then 
        self.owner = roomData.owner
    end

    if self.group == "" and string.find(self.roomId, "custom") then
        self:setGroup(ChatGroupType.GROUP_CUSTOM)
    end

    if roomData.members then
        local memberArr = rapidjson.decode(roomData.members)
        if memberArr == nil or type(memberArr) ~= "table" then
            memberArr = string.split(roomData.members, '|')
        end

        if memberArr then
            self.memberList = memberArr
        else
            ChatPrint("member string error??")
        end
    else
        -- 这个地方没有办法,在新创建的房间中,member竟然没有，需要重启后才存在.......后端暂时没有人,前端先临时处理下
        if (self:isPrivateChat()) then
            local tabName = string.split(self.name, "_");
            if (table.count(tabName) == 4) then
                self.memberList[#self.memberList+1] = tabName[2]
                self.memberList[#self.memberList+1] = tabName[4]
            end
        end
    end 

    
	
	--if roomData.msgs then
		--self:onParseServerChatData(roomData.msgs)
	--end

end

function ChatRoomData:IsGmRoom()
    if (table.count(self.memberList) == 0) then
        if (self.roomId == ChatGMRoomId) then
            return true
        end
        return false
    end
    for _, memberId in pairs(self.memberList) do
        if (memberId == ChatGMUserId) then
            return true;
        end
    end
    --if (string.endswith(self.roomId, "_10000_v2") or self.roomId == ChatGMRoomId) then
    --    return true
    --end
    return false
end

function ChatRoomData:HasUserByUid( userId )
    for _, memberId in pairs(self.memberList) do
        if (memberId == userId) then
            return true;
        end
    end 
    return false
end

-- 设置房间最后点击的时间
-- 取最后一条消息的时间
function ChatRoomData:SetLastClickTime(clicktime)
	local time = clicktime or self.lastMsgTime
	local time2 = 0
	
	if self.lastClickTime ~= time and self.lastClickTime<time then
		local oldTime = self.lastClickTime
		self.lastClickTime = time
        Setting:SetPrivateString("ChatRoomClickTime"..self.roomId, self.lastClickTime)
		if not table.IsNullOrEmpty(self.msgs) then
			time2 = self.msgs[#self.msgs].serverTime
		end
		
		--ChatPrint("*** set room: %s , old :%f, clicktime : %f, time2 : %f", 
			--self.roomId, oldTime, self.lastClickTime, time2)
		
		-- nil 表示是UI每次设置的时间
		if clicktime == nil then
			ChatManager2:GetInstance().Room:SaveRoomDatas()
		end
	end
    

    if not table.IsNullOrEmpty(self.msgs) then
        time2 = self.msgs[#self.msgs].serverTime
    end
end

-- 强制同步时间,这个是如果当前显示的聊天界面是本房间,最新的消息来的时候,拿最新的消息servertime做本房间的click时间
function ChatRoomData:ForceAsynClickTime()
    if (table.count(self.msgs) > 0) then
        local lastMessage = self.msgs[#self.msgs]:getServerTime()
        self.lastClickTime = lastMessage
        Setting:SetPrivateString("ChatRoomClickTime"..self.roomId, self.lastClickTime)
    end
end

function ChatRoomData:getMemberList()
    local list = {}
    for _, uid in ipairs(self.memberList) do
        if not table.hasvalue(list, uid) then
            table.insert(list, uid)
        end
    end
    return list
end

--是否是私聊
function ChatRoomData:isPrivateChat()
	-- 自定义房间
	if not self:isCustomRoom() then
		return false
	end
	
	-- 暂时先使用名字来判断
	if not string.startswith(self.name, "PRIVATE") then
		return false
	end
	
	return true
end

--获取到私聊目标
-- 私聊房间的名称为PRIVAVTE_myuid_to_targetuid
-- 接受者拿到的房间id为PRIVAVTE_targetuid_to_myuid
function ChatRoomData:GetPrivateUser()
	if self:isPrivateChat() then
		local arr = string.split(self.name, "_")
		if #arr ~= 4 then
			return ""
		end
		
		if arr[1] == "PRIVATE" and arr[3] == "to" then
			if arr[2] == ChatInterface.getPlayerUid() then
				return arr[4]
			elseif arr[4] == ChatInterface.getPlayerUid() then
				return arr[2]
			end
		end
	end
	
	return ""
end

--更新
function ChatRoomData:getFirstSeqId()
    if not self.msgs or #self.msgs == 0 then 
        return -1
    end 
    --self:sort()
    return self.msgs[1].seqId
end

-- 获取第一条消息的时间
function ChatRoomData:GetFirstMsgServerTime()
	if #self.msgs == 0 then
		return 0
	end
	
	return self.msgs[1]:getServerTime()
end

--获取消息总数
function ChatRoomData:getToTalNum()
    return #self.msgs
end

---获取最后一条消息
function ChatRoomData:getLastChatData(noSYS)
    --self:sort()
	local restrict = ChatManager2:GetInstance().Restrict
	
    for i = #self.msgs, 1, -1 do
        local msg = self.msgs[i]
        if noSYS then
            if not msg:CheckSYS() and not restrict:isInRestrictList(msg.senderUid, RestrictType.BLOCK) then
                return msg
            end
        else
            if not restrict:isInRestrictList(msg.senderUid, RestrictType.BLOCK) then
                return msg
            end
        end
    end
end

-- 获取最后N条数据
function ChatRoomData:GetLastChatDatas(noSYS, totalCnt)
    totalCnt = totalCnt or 1
    local msglist = {}
    local restrict = ChatManager2:GetInstance().Restrict

    for i = #self.msgs, 1, -1 do
        local msg = self.msgs[i]
        if noSYS then
            if not msg:CheckSYS() and not restrict:isInRestrictList(msg.senderUid, RestrictType.BLOCK) then
                msglist[#msglist+1] = msg;
                if (#msglist >= totalCnt) then
                    return msglist
                end
            end
        else
            if not restrict:isInRestrictList(msg.senderUid, RestrictType.BLOCK) then
                msglist[#msglist+1] = msg;
                if (#msglist >= totalCnt) then
                    return msglist
                end
            end
        end
    end
    return msglist;
end

-- 获取最后一条消息的时间戳
function ChatRoomData:GetLastChatTime()
	return self.lastMsgTime
end

---添加成员列表---
function ChatRoomData:addMembers(memberUids)
    if type(memberUids) ~= "table" then 
        ChatPrint("addMembers error")
        return
    end 
	
    for _,memberUid in pairs(memberUids) do 
        if table.hasvalue(self.memberList,memberUid) == false then 
            table.insert(self.memberList,memberUid)
        end 
    end 
	
	ChatManager2:GetInstance().User:requestUserInfo(memberUids)
end

--移除成员列表----
function ChatRoomData:removeMember(uid)
	if type(uid) ~= "string" then
		ChatPrint("removeMember error")
		return
	end
	table.removebyvalue(self.memberList, uid)
end

function ChatRoomData:removeMembers(memberUids)
    if type(memberUids) ~= "table" then 
        ChatPrint("removeMembers error")
        return
    end 
    for _,memberUid in pairs(memberUids) do 
        table.removebyvalue(self.memberList, memberUid)
    end 
end

function ChatRoomData:isExistChatData(chatData)
    for k, _chatData in ipairs(self.msgs) do 
        if _chatData.seqId == chatData.seqId and
			_chatData.sendLocalTime == chatData.sendLocalTime and
			_chatData.senderUid == chatData.senderUid then 
            self.msgs[k] = chatData
            return true
        end 
    end 
    return false
end

-- 检测聊天是否存在
function ChatRoomData:isExistSeqId(seqId)
	for _,v in ipairs(self.msgs) do
		if (v.seqId == seqId) then
			return true
		end
	end
		
	return false
end

----添加聊天消息---
function ChatRoomData:__addChatDatas(chatDataArray)
	if chatDataArray == nil or #chatDataArray == 0 then
		return 
	end

	for _,v in ipairs(chatDataArray) do
		self:__addChatData(v)
	end
	self:sort()
end

function ChatRoomData:__addChatData(chatData)

    if self:isPrivateChat() and chatData.post == PostType.Text_ChatRoomSystemMsg then
        return false
    end

    if chatData:CheckHide() then
        return false
    end
	
    if not self:isExistChatData(chatData) then 
        table.insert(self.msgs, chatData)
		
		-- 插入消息的时候更新一下时间
		if self.lastMsgTime < chatData:getServerTime() then 
			self.lastMsgTime = chatData:getServerTime()
		end
		return true
    end 
	
	return false
end

---移除聊天消息--
function ChatRoomData:removeChatData(chatData)
    table.removebyvalue(self.msgs, chatData)
end

function ChatRoomData:updateChatData(chatData)
    for _ , chatDataMsg in pairs(self.msgs) do 
        if chatDataMsg.sendLocalTime == chatData.sendLocalTime then 
            if chatData.appId then
                chatDataMsg.appId = chatData.appId
            end
            if chatData.roomId then
                chatDataMsg.roomId = chatData.roomId
            end
            if chatData.group then
                chatDataMsg.group = chatData.group
            end
			if chatData.type then
				chatDataMsg.type = chatData.type
			end
            --if chatData.isNew then
                --chatDataMsg.isNew = chatData.isNew
            --end
            if chatData.isTranslating then
                chatDataMsg.isTranslating = chatData.isTranslating
            end
            if chatData.isTranslationFailed then
                chatDataMsg.isTranslationFailed = chatData.isTranslationFailed
            end
            if chatData._id then
                chatDataMsg._id = chatData._id
            end
            if chatData.seqId then
                chatDataMsg.seqId = chatData.seqId
            end
            if chatData.senderUid then
                chatDataMsg.senderUid = chatData.senderUid
            end
			if chatData.senderName then
				chatDataMsg.senderName = chatData.senderName
			end
            if chatData.serverTime then
                chatDataMsg.serverTime = chatData.serverTime
            end
            if chatData.post then
                chatDataMsg.post = chatData.post
            end
            if chatData.msg then
                chatDataMsg.msg = chatData.msg
            end
            if chatData.translateMsg then
                chatDataMsg.translateMsg = chatData.translateMsg
            end
            if chatData.originalLang then
                chatDataMsg.originalLang = chatData.originalLang
            end
            if chatData.translatedLang then
                chatDataMsg.translatedLang = chatData.translatedLang
            end
            if chatData.sendState then
                chatDataMsg.sendState = chatData.sendState
            end
            if chatData.attachmentId then
                chatDataMsg.attachmentId = chatData.attachmentId
            end
            if chatData.media then
                chatDataMsg.media = chatData.media
            end
            if chatData.msgMask then
                chatDataMsg.msgMask = chatData.msgMask
            end
        end 
    end 
end

function ChatRoomData:getChatDataBySeqId(seqId)
    for _ , chatData in ipairs(self.msgs) do 
        if chatData.seqId == seqId then 
            return chatData
        end 
    end 

    return nil
end

--[[
    排序  先按时间排序 时间一致的话按序列id排序
]]
function ChatRoomData:sort()
    table.sort( 
		self.msgs, 
		function (chatData1, chatData2)
	        if chatData1.serverTime ~= chatData2.serverTime then 
	            return chatData1.serverTime < chatData2.serverTime
	        else
	            return chatData1.seqId < chatData2.seqId
	        end 
	    end)
end

-- 获取新消息的数量
-- 如果消息的时间戳大于当前最后房间点击的时间，就算新消息
function ChatRoomData:getNewMsgNum()
	--检查是否屏蔽过
	if self:isWorldRoom() or self:isAllianceRoom() or self:isLangRoom() or self:IsCross() or self:IsGroupChatRoom() or self:IsDragonServer() or self:IsEdenCampRoom() then
		local roomParam = ChatGroupId[self.group]
		if self:isLangRoom() then
			roomParam = "lang"
		elseif self:IsGroupChatRoom() then
			roomParam = "memberList"
		end
		local isShield = Setting:GetBool(SettingKeys.CHAT_GROUP_SHIELD..LuaEntry.Player.uid..roomParam,false)
		if isShield then
			return 0
		end
	end
	local lastClickTime = self.lastClickTime
	
	-- 从后向前遍历
	local count = 0
	for i = #self.msgs, 1, -1 do
		local m = self.msgs[i]
        if (m.senderUid == "system" and m.group == "alliance") then
            goto continue
        end 
		local t = m:getServerTime()
		if lastClickTime >= t then
			break
		end
		count = count + 1
        ::continue::
	end

	return count
end

-- 返回频道id
function ChatRoomData:getRoomId()
    return self.roomId
end

--返回房间名字
function ChatRoomData:getRoomName()
    local name = "";
    if self.group == ChatGroupType.GROUP_COUNTRY then
        if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
            name = ChatInterface.getString("111169");
        else
            name = ChatInterface.getString("100171");
        end
        
    elseif self.group == ChatGroupType.GROUP_ALLIANCE then
        name = ChatInterface.getString(GameDialogDefine.ALLIANCE);
    elseif self.group == ChatGroupType.GROUP_AL_AUTO_INVITE then
        name = ChatInterface.getString("311025");
    elseif self.group == ChatGroupType.GROUP_CROSS_SERVER then
        name = ChatInterface.getString("104263")
    elseif self.group == ChatGroupType.GROUP_DRAGON_SERVER then
        name = ChatInterface.getString("376129")
    elseif self.group == ChatGroupType.GROUP_EDEN_CAMP then
        name = ChatInterface.getString("111170")
    elseif self.group == ChatGroupType.GROUP_CUSTOM then
        name = self.name
        if self:isPrivateChat() then
            local targetMemberId = self:GetPrivateUser()
            if (targetMemberId == ChatGMUserId) then
                return ChatInterface.getString("100619");
            end
            local chatUserInfo = ChatManager2:GetInstance().User:getChatUserInfo(targetMemberId)
            if chatUserInfo then
                if not string.IsNullOrEmpty(chatUserInfo.allianceSimpleName) then
                    name = string.format("(%s)%s",chatUserInfo.allianceSimpleName,chatUserInfo.userName)
                else
                    name = string.format("%s",chatUserInfo.userName)
                end
            end
        else
            if string.find(self.roomId, "lang") then
				if Localization:GetLanguage() == Language.ChineseSimplified or Localization:GetLanguage() == Language.ChineseTraditional then
					name = ChatInterface.getString("290049",ChatInterface.getString("390759"))
				else
					name = ChatInterface.getString("290049",SuportedLanguagesName[Localization:GetLanguage()])
				end
            end
        end
    elseif self.group == ChatGroupType.GROUP_QUEST then
        name = ChatInterface.getString(GameDialogDefine.TASK)
    elseif self.group == ChatGroupType.GROUP_RADAR then
        name = ChatInterface.getString(GameDialogDefine.RADAR)
    elseif self.group == ChatGroupType.GROUP_TMPRoom then
        name = self.name
    end 
    return name 
end

-- 返回频道图标
function ChatRoomData:getRoomImg()
    if self:isCustomRoom() then
        if string.find(self.roomId, "lang") then
            return string.format(LoadPath.ChatFolder, "UIchat_tabicon_local02")
        else
            return ""
        end
    elseif self.group == ChatGroupType.GROUP_DRAGON_SERVER then
        return "Assets/Main/Sprites/UI/UIDragon/UIbattlefield_icon_Relic"
    elseif self.group == ChatGroupType.GROUP_EDEN_CAMP then
        local path =  "Assets/Main/Sprites/LodIcon/eden_camp_1"
        local selfCamp = DataCenter.RobotWarsManager:GetSelfCamp()
        if selfCamp and selfCamp ~= -1 then
            path =  "Assets/Main/Sprites/LodIcon/eden_camp_" ..selfCamp
        end
        return path
    else
        return string.format(LoadPath.ChatFolder, ChatGroupTypeImg[self.group])
    end
end

-- 返回频道分类
function ChatRoomData:getRoomGroup()
    return self.group
end

-- 是否为世界频道
function ChatRoomData:isWorldRoom()
	if self.group == ChatGroupType.GROUP_COUNTRY then
		return true
	end
	return false
end

-- 是否为联盟频道
function ChatRoomData:isAllianceRoom()
	if self.group == ChatGroupType.GROUP_ALLIANCE then
		return true
	end
	return false
end

-- 是否联盟对决
function ChatRoomData:IsCross()
	if self.group == ChatGroupType.GROUP_CROSS_SERVER then
		return true
	end
	return false
end
function ChatRoomData:IsDragonServer()
    if self.group == ChatGroupType.GROUP_DRAGON_SERVER then
        return true
    end
    return false
end
function ChatRoomData:IsEdenCampRoom()
    if self.group == ChatGroupType.GROUP_EDEN_CAMP then
        return true
    end
    return false
end
--是否是语言频道
function ChatRoomData:isLangRoom()
     if self.group == ChatGroupType.GROUP_CUSTOM and string.find(self.roomId, "lang") then 
        return true
    end
    return false
end

--是否是群聊
function ChatRoomData:IsGroupChatRoom()
	if self:isCustomRoom() and not self:isLangRoom() and not self:isPrivateChat() then
		return  true
	end
	return false
end

-- 是否pin
function ChatRoomData:IsPin()
	return IntToBool(self.isPin)
end

function ChatRoomData:SetPin(p)
	self.isPin = BoolToInt(p)
end

function ChatRoomData:PrintRoomMsgTime()
	for k, v in pairs(self.msgs) do
		ChatPrint("--- msg id(%d), time: %f", v.seqId, v:getServerTime())
	end
end

--获取私聊房间对方的uid
--function ChatRoomData:getPrivateRoomTargetUid()
    --local targetMemberId = ""
		
	--if self:isPrivateChat() then
	    --for key,memberId in pairs(self.memberList) do 
	         --if memberId and memberId ~= ChatInterface.getPlayerUid()then 
	             --targetMemberId = memberId
	             --break
	         --end 
	    --end 
	--end
    --return targetMemberId
--end


return ChatRoomData
