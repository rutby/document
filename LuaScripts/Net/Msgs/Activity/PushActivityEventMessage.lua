---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/11 11:33
---

local PushActivityEventMessage = BaseClass("PushActivityEventMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ActivityListDataManager:AddOneActivity(1, t)
    EventManager:GetInstance():Broadcast(EventId.OnUpdateActivityEventData)
    
end

PushActivityEventMessage.OnCreate = OnCreate
PushActivityEventMessage.HandleMessage = HandleMessage

return PushActivityEventMessage