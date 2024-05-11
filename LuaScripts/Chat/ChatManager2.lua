--[[
	聊天管理器
]]

local ChatManager2 = BaseClass("ChatManager2", Singleton)
local ChatViewController = require "UI.UIChatNew.Controller.ChatViewUtils"

local CHAT_NONE		= 0
local CHAT_DB		= 1
local CHAT_NET		= 2
local CHAT_OK		= 3
local CHAT_ERROR	= -1

-- 构造函数
function ChatManager2:__init()

	self.cur_gameuid = ""
	self.status = CHAT_NONE

	self.DB = require("Chat.Controller.ChatDBManager").New()
	self.Net = require("Chat.Controller.ChatNetManager").New()
	self.Room = require("Chat.Controller.ChatRoomManager").New()
	self.User = require("Chat.Controller.UserManager").New()
	self.Translate = require("Chat.Controller.TranslateManager").New()
	self.Restrict = require("Chat.Controller.ChatRestrictManager").New()
	self.Filter = require("Chat.Controller.FilterWordsManager").New()
	self.Ctrl = require("Chat.Controller.ChatController").New()
	
	
end


-- 数据库初始化完毕
function ChatManager2:onDatabaseOK(status, reason)
	if status == "ok" then
		self.status = CHAT_DB
	end
	EventManager:GetInstance():Broadcast(EventId.ChatDBInitFinish)
end

-- 聊天初始化，要使用gameuid
function ChatManager2:Init(gameuid)

	self:Uninit()
	
	self.cur_gameuid = gameuid
	
	self.reportedChatDic = {}
	self:InitReportData()
	
	-- 初始化控制器
	self.Ctrl:Init()
	
	-- 首先初始化数据库
	self.DB:Init(function() self:onDatabaseOK() end)
	
	-- 然后初始化网络
	-- 网络连接过程中有选路，之后连接聊天服务器，然后收到服务器的各种聊天推送消息
	self.Net:Init(gameuid)
end

-- 卸载
function ChatManager2:Uninit()

	if self.DB then 
		self.DB:Uninit()
	end 
	
	if self.Net then 
		self.Net:Uninit()
	end
end

function ChatManager2:SetGiveLikeMsgTime(type)
	local timeStamp = self.Room:getChatServerTime()
	self.Restrict:SetGiveLikeMsgTime(type,timeStamp)
end

function ChatManager2:GetGiveLikeMsgTime(type)
	local timeStamp = self.Restrict:GetGiveLikeMsgTime(type)
	local time = self.Room:getChatServerTime()
	local delta = timeStamp-time
	return delta
end
function ChatManager2:SetGiveLikeAnim(type,num)
	self.Restrict:SetGiveLikeAnim(type,num)
end

function ChatManager2:GetGiveLikeAnim(type)
	return self.Restrict:GetGiveLikeAnim(type)
end
-- 是否创建ok
function ChatManager2:IsInitOK()
	if (self.status == CHAT_OK) then
		return true
	end
	return false
end

-- 聊天登录成功消息，至此开始聊天处理
function ChatManager2:onUserLoginSuccess(serverData)

	local roomManager = self.Room
	local playerUid = self.cur_gameuid

	-- 切换账号时，清空Rooms里的数据
	local tempClientId = serverData.server .. serverData.clientid
	ChatPrint("ClientId = %s, Uid = %s", tempClientId, serverData.data.uid)

	-- 如果和当前的playeruid不同
	if (self.cur_gameuid ~= serverData.data.uid) then
		roomManager:ClearRooms()
	end
	-- 初始化房间系统
	roomManager:UpdateChatServerTime(math.floor(serverData.serverTime/1000))
	roomManager:Init()
	-- 初始时先不请求用户信息，等到joinroom返回的时候再去处理
	self.User:SetRequestUserInfo(false)

	self.clientId = tempClientId
	self.cur_gameuid = serverData.data.uid
	self.serverData = serverData

	-- 至此算聊天可以正常工作了
	self.status = CHAT_OK

	local Net = ChatManager2:GetInstance().Net
	Net:SendMessage(ChatMsgDefines.UserSetInfo, ChatInterface.getLastUpdateTime())
	Net:SendMessage(ChatMsgDefines.SetSwitchFlag)

	-- 请求自定义频道列表（除去世界频道和联盟频道的其他频道）
	Net:SendMessage(ChatMsgDefines.GetCustomRoomList)
	-- 加入到指定频道(这个消息要放到最后！)
	Net:SendMessage(ChatMsgDefines.RoomJoinMulti)

	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_LOGIN_SUCCESS)

	ChatPrint("onUserLoginSuccess ok")
end

-- 聊天内部出错或者断开
function ChatManager2:onErrorOrDisconnect()
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ERROR_OR_DISCONNECT)
end

-- 发送给某人私聊
-- 如果是第一次的话，创建房间；否则先追加临时数据
function ChatManager2:__sendToPrivateNoRoom(uid, msg)
	local RoomManager = self.Room

	local t = RoomManager:getTempPersonMsg(uid)
	if t == nil then
		local myUid = ChatInterface.getPlayerUid()
		local myName = ChatInterface.getPlayerName()

		local tbl = {}
		tbl.type = 1
		tbl.name = "PRIVATE_" .. tostring(myUid) .. "_to_" .. tostring(uid)
		tbl.memberList = {myUid, uid}
		if (uid == ChatGMUserId) then
			tbl.type = 3
			for i = 1, ChatGMUserCnt do
				tbl.memberList[#tbl.memberList+1] = tostring(tonumber(ChatGMUserId)+i)
			end
		end
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_CREATE_COMMAND, tbl)
	end

	RoomManager:addTempPersonMsg(uid, msg)

end


-- 发送聊天到某个房间
function ChatManager2:__sendToRoom(roomId, msg)

	local RoomManager = self.Room
	local roomData = RoomManager:GetRoomData(roomId)
	local userMgr = ChatManager2:GetInstance().User
	
	-- 发送列表
	if not roomData then
		return
	end

	local playerUid = ChatInterface.getPlayerUid()
	if string.IsNullOrEmpty(playerUid) then
		ChatPrint("OnChatSendMsg  playerUid is null!!!!!!")
		return
	end
	
	local playerCharInfo = userMgr:getChatUserInfo(playerUid)

	local serverTime = RoomManager:getChatServerTime()
	local chatTabData = {
		sender 		= playerUid,
		--senderInfo 	= senderInfo,
		group 		= roomData.group,
		serverTime 	= serverTime,
		roomId 		= roomId,
		msg 		= msg,
		sendTime 	= serverTime,
		-- extra 		= { post = 0, media = "" },	
	};

	local seqId = RoomManager:GetSendingIndex()
	local chatData = RoomManager:CreateChatMessage()
	chatData:onParseServerData(chatTabData)
	chatData:setSeqId(-seqId)

	-- 自己的消息直接先加入数据库
	--RoomManager:AddSendingChat(chatData, true)
	local allianceRoomId = ChatInterface.getRoomMgr():GetAllianceRoomId()
	local countryRoomId = ChatInterface.getRoomMgr():GetCountryRoomId()

	chatData:setSendState(SendStateType.PENDING)
	if roomId == allianceRoomId then
		if chatData.post == PostType.Text_Normal then
			SFSNetwork.SendMessage(MsgDefines.UserChatStat,2)
			if LuaEntry.Player:GetRegDeltaTime()<=7 then
				local curCount = LuaEntry.Player:GetAllianceChatCount()
				curCount =curCount+1
				LuaEntry.Player:SetAllianceChatCount(curCount)
				if curCount ==1 then
					CS.GameEntry.Sdk:LogEvent("alliance_chat_1", playerUid)
				elseif curCount == 3 then
					CS.GameEntry.Sdk:LogEvent("alliance_chat_3", playerUid)
				elseif curCount == 10 then
					CS.GameEntry.Sdk:LogEvent("alliance_chat_10", playerUid)
				end
			end
		end
	elseif roomId == countryRoomId then
		SFSNetwork.SendMessage(MsgDefines.UserChatStat,3)
	else
		SFSNetwork.SendMessage(MsgDefines.UserChatStat,1)
	end
	-- 暂时先屏蔽
	--chatData.post = nil 
	--chatData.media = nil
	self.Net:SendMessage(ChatMsgDefines.ChatRoom, chatData)
	
	-- 如果是自己的消息，顺便处理一下头像修改；否则换了头像自己说话看不到自己头像改变
	local uinfo = playerCharInfo
	local lastUpdateTime = ChatInterface.getLastUpdateTime()
	if uinfo and (lastUpdateTime ~= uinfo.lastUpdateTime) then	
		local senderInfo = {
			lastUpdateTime = ChatInterface.getLastUpdateTime(),
		}	
		userMgr:__processSenderInfo(playerUid, senderInfo)
	end

	-- 发送给UI
	--EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, chatData)
	
end

-- 发送聊天消息
-- 参数table
--   roomId 房间id
--   msg    消息体
--   toUid	私聊时，当房间id为null时的私聊目标uid
function ChatManager2:SendChatMsg(msgTable)
	local roomId = msgTable.roomId
	local msg = msgTable.msg

	if string.IsNullOrEmpty(msg) then
		return
	end

	if string.IsNullOrEmpty(roomId) or
			ChatViewController:GetInstance():IsTmpPrivateChat(roomId) or
			roomId == ChatGMRoomId then
		if string.IsNullOrEmpty(msgTable.toUid) then
			return
		else
			if ChatInterface.getPlayerUid() == msgTable.toUid then
				return
			end

			self:__sendToPrivateNoRoom(msgTable.toUid, msg)
			return
		end
	end

	self:__sendToRoom(roomId, msg)
	return
end

function ChatManager2:SendChatUpMsg(msgTable)
	local roomId = msgTable.roomId
	local RoomManager = self.Room
	local roomData = RoomManager:GetRoomData(roomId)
	-- 发送列表
	if not roomData then
		return
	end
	local playerUid = ChatInterface.getPlayerUid()
	if string.IsNullOrEmpty(playerUid) then
		ChatPrint("OnChatSendMsg  playerUid is null!!!!!!")
		return
	end

	local serverTime = RoomManager:getChatServerTime()
	local chatTabData = {
		sender 		= playerUid,
		--senderInfo 	= senderInfo,
		group 		= roomData.group,
		serverTime 	= serverTime,
		roomId 		= roomId,
		sendTime 	= serverTime,
		msgSeq   = msgTable.msgSeq,
		interactLike = msgTable.interactLike,
		interactDislike = msgTable.interactDislike,
		-- extra 		= { post = 0, media = "" },	
	};
	self.Net:SendMessage(ChatMsgDefines.ChatUpRoom, chatTabData)
end


-- 处理聊天消息
function ChatManager2:OnHandleMessage(cmd, t)
	if self.Net then
		return self.Net:OnHandleMessage(cmd, t)
	end
	
	return false
end


function ChatManager2:ReportChat(chatData, type, reportType)
	self:SetAsReported(chatData)
	
	self.lastReportTime = UITimeManager:GetInstance():GetServerTime()
	
	local reportUid = chatData.senderUid
	local content = chatData.msg
	local msgCreateTime = chatData:getServerTime()
	
	SFSNetwork.SendMessage(MsgDefines.ReportChat, reportUid, content, type, reportType, msgCreateTime)
end

function ChatManager2:InitReportData()
	self.reportedChatDic = {}
	local strK = LuaEntry.Player.uid .. "_ChatReport"
	local reported = CS.GameEntry.Setting:GetString(strK, "")
	if not string.IsNullOrEmpty(reported) then
		local arr = string.split(reported, ";")
		for i, v in pairs(arr) do
			if not string.IsNullOrEmpty(v) then
				self.reportedChatDic[v] = 1
			end
		end
	end
end

function ChatManager2:SetAsReported(chatData)
	local uid = chatData.senderUid .. "_" .. chatData:getServerTime()
	self.reportedChatDic[uid] = 1
	local strK = LuaEntry.Player.uid .. "_ChatReport"
	local reported = CS.GameEntry.Setting:GetString(strK, "")
	CS.GameEntry.Setting:SetString(strK, uid .. ";" .. reported)
end

function ChatManager2:CheckReportTime()
	if not self.lastReportTime then
		return true
	end
	
	local serverTime = UITimeManager:GetInstance():GetServerTime()
	if serverTime - self.lastReportTime >= 300000 then
		return true
	else
		return false
	end
end

function ChatManager2:CheckIfReported(chatData)
	local uid = chatData.senderUid .. "_" .. chatData:getServerTime()
	return self.reportedChatDic[uid]
end

return ChatManager2

