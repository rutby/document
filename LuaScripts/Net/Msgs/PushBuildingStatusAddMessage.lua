---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/29 16:21
---

local PushBuildingStatusAddMessage = BaseClass("PushBuildingStatusAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildStatusManager:HandleAdd(t)
end

PushBuildingStatusAddMessage.OnCreate = OnCreate
PushBuildingStatusAddMessage.HandleMessage = HandleMessage

return PushBuildingStatusAddMessage