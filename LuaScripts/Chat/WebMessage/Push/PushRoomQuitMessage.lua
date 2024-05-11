--[[
	某个玩家退出房间了，其他人要收到这个消息
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomQuitMessage = BaseClass("PushRoomQuitMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")

local function OnCreate(self)
end

local function HandleMessage(self, serverData)
	
	local msgs = RoomDataParser.DecodeMsgs(serverData)
	if msgs == nil then
		print("data nil")
		return
	end
	
	-- 如果是我自己离开；直接删了聊天室完事
	if msgs.sender == ChatInterface.getPlayerUid() then		
		local roomMgr = ChatManager2:GetInstance().Room
		roomMgr:RemoveRoomData(msgs.roomId)
		EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
		return
	end
	
	-- 其他人退出房间，就显示一条xx退出的消息
	local chatData = RoomDataParser.ProcessMsgs(msgs, "quit")
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, chatData)
	
end


PushRoomQuitMessage.OnCreate = OnCreate
PushRoomQuitMessage.HandleMessage = HandleMessage
return PushRoomQuitMessage