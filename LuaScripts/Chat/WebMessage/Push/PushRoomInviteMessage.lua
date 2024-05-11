--[[
    房间邀请推送
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushRoomInviteMessage = BaseClass("PushRoomInviteMessage", WebSocketBaseMessage)
local RoomDataParser = require("Chat.WebMessage.Push.RoomDataParser")

local function OnCreate(self)

end

local function HandleMessage(self, serverData)
	
	-- 必须要逐步分解
	--local roomInfo = RoomDataParser.DecodeRoomInfo(serverData)
	local msgs = RoomDataParser.DecodeMsgs(serverData)
	if msgs == nil then
		print("data nil")
		return
	end

	local chatData = RoomDataParser.ProcessMsgs(msgs, "add")
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_RECIEVE_ROOM_MSG, chatData)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_Enum_UpdateRoomOperateInfo)
    --EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
end


PushRoomInviteMessage.OnCreate = OnCreate
PushRoomInviteMessage.HandleMessage = HandleMessage
return PushRoomInviteMessage