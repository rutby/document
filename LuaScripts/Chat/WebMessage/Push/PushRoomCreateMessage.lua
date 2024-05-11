--[[
    创建房间推送
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomCreateMessage = BaseClass("PushRoomCreateMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")
local ChatViewController = require "UI.UIChatNew.Controller.ChatViewUtils"

local rapidjson = require "rapidjson"

local function OnCreate(self)

end

-- 如果是我发的私聊，此时才把信息发出去[目的是为了仿照我们SLG的史诗级宇宙超大作：文明觉醒！！]
-- 因为从UI测来看是先发消息再创建房间，而数据层面要先创建房间再发送消息
-- 比较遗憾的是整个过程没有Context，所以有可能恰巧服务器推了一个房间过来，就会导致房间混乱
-- 所以这里的处理要“近似”：如果这个房间看起来是我创建的一个私聊房间，就把缓存的消息加进去
local function DoFirstPersonalTalk(roomData)

	local myUserId = ChatInterface.getPlayerUid()
	if roomData.owner == myUserId and roomData:isPrivateChat() then
		--roomManager:SetCurrentRoomId(roomId)
		local roomManager = ChatManager2:GetInstance().Room

		-- 强制UI选择此私聊房间
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_ChatCellSelect, roomData.roomId)

		-- 从临时的消息中遍历然后追加到房间
		local tragetUid = roomData:GetPrivateUser()
		local remainMsg = roomManager:getTempPersonMsg(tragetUid)
		
		-- 理论上remainMsg不应该为nil，同时要把缓存的这些消息一条一条发给服务器
		if remainMsg ~= nil then
			local msgId = ChatInterface.getEventEnum().CHAT_SEND_ROOM_MSG_COMMAND
			for _, msg in ipairs(remainMsg) do
				local t = {
					roomId = roomData.roomId,
					msg = msg
				}
				EventManager:GetInstance():Broadcast(msgId, t)
			end
		end
		
		roomManager:clearTempPersonMsg(tragetUid)
	end
end

local function HandleMessage(self, serverData)

	-- 必须要逐步分解
	local roomInfo = RoomDataParser.DecodeRoomInfo(serverData)
	local msgs = RoomDataParser.DecodeMsgs(serverData)
	if roomInfo == nil or msgs == nil then
		print("data nil")
		return
	end
	ChatViewController:GetInstance():SetPrivateUserInfo(nil)
	-- 创建房间并且处理房间数据
	local roomManager = ChatManager2:GetInstance().Room
	local roomData = roomManager:CreateChatRoom(roomInfo.roomId, roomInfo.group)
	-- 将新创建房间的lastMsgTime置为最新,这样新创建的房间可以放在最上面
	roomInfo["lastMsgTime"] = UITimeManager:GetInstance():GetServerTime()
	roomData:onParseServerData(roomInfo)

	-- 解析消息及成员
	local chatData = RoomDataParser.ProcessMsgs(msgs, "add")
	
	-- 通知UI
   	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_ROOM_CREATE_RESULT, roomData.roomId)
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, chatData)
	
	-- 第一次个人私聊信息处理
	DoFirstPersonalTalk(roomData)

end


PushRoomCreateMessage.OnCreate = OnCreate
PushRoomCreateMessage.HandleMessage = HandleMessage
return PushRoomCreateMessage