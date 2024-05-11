--[[
	离开房间调用的websocket协议
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local LeaveRoomCommand = BaseClass("LeaveRoomCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId)

    self.tableData.roomId = roomId
end

local function HandleMessage(self, msg)

	if msg.result.status ~= true then
		ChatPrint("leave room error?")
	end
	
	ChatPrint("leave room id = " .. tostring(msg.result.id) .. ", status = " .. tostring(msg.result.status))
	
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_REFRESH_CHANNEL)
end

LeaveRoomCommand.OnCreate = OnCreate
LeaveRoomCommand.HandleMessage = HandleMessage

return LeaveRoomCommand