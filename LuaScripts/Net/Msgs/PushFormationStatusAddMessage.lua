---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/1/3 20:34
---

local PushFormationStatusAddMessage = BaseClass("PushFormationStatusAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.FormStatusManager:HandleAdd(t)
end

PushFormationStatusAddMessage.OnCreate = OnCreate
PushFormationStatusAddMessage.HandleMessage = HandleMessage

return PushFormationStatusAddMessage