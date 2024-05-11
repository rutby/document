---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/10/25 15:41
---
local PushAllianceCityDefendChangeMessage = BaseClass("PushAllianceCityDefendChangeMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    AllianceBuildBloodManager:GetInstance():ShowAllianceBloodEffect(t)
    EventManager:GetInstance():Broadcast(EventId.AllianceCityStaminaUpdate,t) 
end

PushAllianceCityDefendChangeMessage.OnCreate = OnCreate
PushAllianceCityDefendChangeMessage.HandleMessage = HandleMessage

return PushAllianceCityDefendChangeMessage