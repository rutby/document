---
--- Created by shimin.
--- DateTime: 2020/10/22 21:51
---
local PushAccountChangePwdMessage = BaseClass("PushAccountChangePwdMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AccountManager:PushAccountChangePwdHandle(t)
end

PushAccountChangePwdMessage.OnCreate = OnCreate
PushAccountChangePwdMessage.HandleMessage = HandleMessage

return PushAccountChangePwdMessage