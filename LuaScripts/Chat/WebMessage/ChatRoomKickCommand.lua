--[[
	聊天室踢人
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomKickCommand = BaseClass("ChatRoomKickCommand", WebSocketBaseMessage)


local function OnCreate(self, roomId, uidArr)
	self.tableData.group = "custom"
	self.tableData.roomId = roomId
	self.tableData.members = table.concat(uidArr, '|')
end

local function HandleMessage(self, serverData)
    EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().ROOM_KICK_PLAYER_RESULT, serverData.result.status)
	ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.GetCustomRoomList)
end

ChatRoomKickCommand.OnCreate = OnCreate
ChatRoomKickCommand.HandleMessage = HandleMessage

return ChatRoomKickCommand

