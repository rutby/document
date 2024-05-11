---
--- Created by shimin.
--- DateTime: 2020/8/26 15:54
---
local PushArmyChangeMessage = BaseClass("PushArmyChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ArmyManager:PushArmyChangeHandle(t)
end

PushArmyChangeMessage.OnCreate = OnCreate
PushArmyChangeMessage.HandleMessage = HandleMessage

return PushArmyChangeMessage