---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/21 16:18
---
local PushArmyReturnMessage = BaseClass("PushArmyReturnMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ArmyFormationDataManager:InitArmyFormationListData(t)
end

PushArmyReturnMessage.OnCreate = OnCreate
PushArmyReturnMessage.HandleMessage = HandleMessage

return PushArmyReturnMessage