---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2023/2/23 16:16
---

local DailyMustRewardMessage = BaseClass("DailyMustRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local function OnCreate(self,index)
    base.OnCreate(self)
    self.sfsObj:PutInt("index", index)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        DataCenter.RewardManager:ShowCommonReward(t)
        for k,v in pairs(t["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
        if t['dailyMustList'] then
            DataCenter.DailyMustBuyManager:UpdateData(t)
        else
            DataCenter.DailyMustBuyManager:AddNewClaimedReward(t["index"])
        end

    end
end

DailyMustRewardMessage.OnCreate = OnCreate
DailyMustRewardMessage.HandleMessage = HandleMessage

return DailyMustRewardMessage