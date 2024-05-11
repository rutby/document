---
--- Created by shimin.
--- DateTime: 2020/10/10 14:49
---
local UserCleanPostMessage = BaseClass("UserCleanPostMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    CS.ApplicationLaunch.Instance:ReStartGame()
end

UserCleanPostMessage.OnCreate = OnCreate
UserCleanPostMessage.HandleMessage = HandleMessage

return UserCleanPostMessage