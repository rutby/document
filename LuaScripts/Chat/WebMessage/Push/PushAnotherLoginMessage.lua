--[[
	
	另一个用户登录？
]]

local WebSocketBaseMessage = require("Chat.WebMessage.Config.WebSocketBaseMessage")
local PushAnotherLoginMessage = BaseClass("PushAnotherLoginMessage", WebSocketBaseMessage)
local ChatService = CS.ChatService.Instance

local function OnCreate(self)
    --base.OnCreate(self)
end

local function HandleMessage(self, serverData)
    --base.HandleMessage(self, serverData)
	ChatPrint("Another user login!")
    --ChatService:CloseWebSocket()
	ChatManager2:GetInstance().Net:CloseWebSocket()
end

PushAnotherLoginMessage.OnCreate = OnCreate
PushAnotherLoginMessage.HandleMessage = HandleMessage
return PushAnotherLoginMessage