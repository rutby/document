--[[
	聊天室改名
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChangeRoomNameCommand = BaseClass("ChangeRoomNameCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId, roomName)
	
	self.tableData.group = "custom"
	self.tableData.roomId = roomId
	self.tableData.name = roomName
	
end

local function HandleMessage(self, serverData)

	if serverData.result.status ~= 1 then
        UIUtil.ShowTipsId(errCode) 
    end
	EventManager:GetInstance():Broadcast(EventId.ChatRoomChangeName, serverData.result.id) -- roomId
end

ChangeRoomNameCommand.OnCreate = OnCreate
ChangeRoomNameCommand.HandleMessage = HandleMessage

return ChangeRoomNameCommand