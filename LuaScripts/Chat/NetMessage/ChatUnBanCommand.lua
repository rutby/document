--[[
    解除禁言
]]

local ChatUnBanCommand = BaseClass("ChatUnBanCommand", SFSBaseMessage)

local function OnCreate(self, uid)
    self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, msg)
    ChatInterface.flyHint(ChatInterface.getString("110068"))
end

ChatUnBanCommand.OnCreate = OnCreate
ChatUnBanCommand.HandleMessage = HandleMessage

return ChatUnBanCommand