---
--- Created by shimin.
--- DateTime: 2021/7/13 16:38
---
local PushBuildingInfoMessage = BaseClass("PushBuildingInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:PushBuildingInfoHandle(t)
end

PushBuildingInfoMessage.OnCreate = OnCreate
PushBuildingInfoMessage.HandleMessage = HandleMessage

return PushBuildingInfoMessage