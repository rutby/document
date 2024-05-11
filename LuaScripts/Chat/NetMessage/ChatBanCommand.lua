--[[
    禁言协议
]]

local ChatBanCommand = BaseClass("ChatBanCommand", SFSBaseMessage)

local function OnCreate(self, uid, time)
    self.sfsObj:PutUtfString("uid", uid)
    self.sfsObj:PutUtfString("time", time)
end

local function HandleMessage(self, msg)
    ChatInterface.flyHint(ChatInterface.getString("105209"))
end

ChatBanCommand.OnCreate = OnCreate
ChatBanCommand.HandleMessage = HandleMessage

return ChatBanCommand

