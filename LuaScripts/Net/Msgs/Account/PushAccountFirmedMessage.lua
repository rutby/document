---
--- Created by shimin.
--- DateTime: 2020/10/22 21:56
---
local PushAccountFirmedMessage = BaseClass("PushAccountFirmedMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:PushAccountFirmedHandle(t)
end

PushAccountFirmedMessage.OnCreate = OnCreate
PushAccountFirmedMessage.HandleMessage = HandleMessage

return PushAccountFirmedMessage