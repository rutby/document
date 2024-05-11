---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
---
local PushAllianceAlertInfoRemoveMessage = BaseClass("PushAllianceAlertInfoRemoveMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.AllianceAlertDataManager:RemoveAlertKey(t)
end

PushAllianceAlertInfoRemoveMessage.OnCreate = OnCreate
PushAllianceAlertInfoRemoveMessage.HandleMessage = HandleMessage

return PushAllianceAlertInfoRemoveMessage