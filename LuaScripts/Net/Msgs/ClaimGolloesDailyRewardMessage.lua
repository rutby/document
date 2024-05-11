---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/11/4 10:51
---


local ClaimGolloesDailyRewardMessage = BaseClass("ClaimGolloesDailyRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self, monthCardId)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("itemId", monthCardId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        --EventManager:GetInstance():Broadcast(EventId.ShowGolloesMonthCardRewards, t)
        if not t["reward"] then
            t["reward"] = {}
        end
        DataCenter.RewardManager:ShowCommonReward(t, Localization:GetString(320337))
        if t["reward"] ~= nil then
            for k,v in pairs(t["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end
        DataCenter.MonthCardNewManager:UpdateMonthCardData(t)
    end
end

ClaimGolloesDailyRewardMessage.OnCreate = OnCreate
ClaimGolloesDailyRewardMessage.HandleMessage = HandleMessage

return ClaimGolloesDailyRewardMessage