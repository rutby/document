---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/6/29 10:27
---
local UserShareMailMessage = BaseClass("UserShareMailMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,uid)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("uid", uid)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message["errorCode"] then
        UIUtil.ShowTipsId(message["errorCode"])
    end
end

UserShareMailMessage.OnCreate = OnCreate
UserShareMailMessage.HandleMessage = HandleMessage

return UserShareMailMessage