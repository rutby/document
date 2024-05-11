---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/5/31 18:24
---

local PushUserRewardControlMessage = BaseClass("PushUserRewardControlMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.ActivityListDataManager:UpdateRewardControlInfo(message)
    EventManager:GetInstance():Broadcast(EventId.UpdateRewardControlInfo)
end

PushUserRewardControlMessage.OnCreate = OnCreate
PushUserRewardControlMessage.HandleMessage = HandleMessage

return PushUserRewardControlMessage