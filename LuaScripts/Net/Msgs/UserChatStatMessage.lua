---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/6/14 16:22
---
local UserChatStatMessage = BaseClass("UserChatStatMessage", SFSBaseMessage)
local base = SFSBaseMessage
local function OnCreate(self, type)
    base.OnCreate(self)
    self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
end

UserChatStatMessage.OnCreate = OnCreate
UserChatStatMessage.HandleMessage = HandleMessage

return UserChatStatMessage