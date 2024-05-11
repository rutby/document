--[[
	非群主退出房间;
	自定义房间，私聊都用这个退出
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local ChatRoomQuitCommand = BaseClass("ChatRoomQuitCommand", WebSocketBaseMessage)

local function OnCreate(self, roomId)

	self.tableData.group = "custom"
	self.tableData.roomId = roomId
	
end

local function HandleMessage(self, serverData)
    ChatPrint("room quit : %s", serverData.result.status)
	if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIChatRoomSetting) then
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatRoomSetting)
	end
end

ChatRoomQuitCommand.OnCreate = OnCreate
ChatRoomQuitCommand.HandleMessage = HandleMessage

return ChatRoomQuitCommand