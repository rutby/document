--[[
    发送联盟聊天开关值
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local SetSwitchFlagCommand = BaseClass("SetSwitchFlagCommand", WebSocketBaseMessage)

local function OnCreate(self, tbl)
    self.tableData.blockwords_new = 1
end

local function HandleMessage(self, msg)
end

SetSwitchFlagCommand.OnCreate = OnCreate
SetSwitchFlagCommand.HandleMessage = HandleMessage

return SetSwitchFlagCommand