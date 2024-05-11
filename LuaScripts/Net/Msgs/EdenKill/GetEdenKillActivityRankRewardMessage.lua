---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/8/3 15:35
---

local GetEdenKillActivityRankRewardMessage = BaseClass("GetEdenKillActivityRankRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, actId)
    self.sfsObj:PutInt("activityId", actId)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    EventManager:GetInstance():Broadcast(EventId.EdenKillGetRankReward, t)
end

GetEdenKillActivityRankRewardMessage.OnCreate = OnCreate
GetEdenKillActivityRankRewardMessage.HandleMessage = HandleMessage

return GetEdenKillActivityRankRewardMessage