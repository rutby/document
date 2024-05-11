--[[
	聊天室踢人，聊天室的剩余人会收到这个消息
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomKickMessage = BaseClass("PushRoomKickMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")
local rapidjson = require "rapidjson"

local function OnCreate(self)

end

local function HandleMessage(self, serverData)
	local msgs = RoomDataParser.DecodeMsgs(serverData)
	if msgs == nil then
		ChatPrint("Kick error!")
		return
	end
	
	-- 踢人消息
	local chatData = RoomDataParser.ProcessMsgs(msgs, "remove")
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, chatData)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_Enum_UpdateRoomOperateInfo)
end


PushRoomKickMessage.OnCreate = OnCreate
PushRoomKickMessage.HandleMessage = HandleMessage
return PushRoomKickMessage