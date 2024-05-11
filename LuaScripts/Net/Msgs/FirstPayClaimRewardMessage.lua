---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/16 10:25
---
local FirstPayClaimRewardMessage = BaseClass("FirstPayClaimRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        --t.state
        --t.reward
        DataCenter.PayManager:UpdateFirstPayStatus(t.state)
        
        local cacheRewards = DataCenter.PayManager:GetCacheFirstPayReward()
        if cacheRewards and cacheRewards.reward then
            table.insertto(t.reward, cacheRewards.reward)
        end
        DataCenter.RewardManager:ShowCommonReward(t)
        for k,v in pairs(t["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
        Setting:SetInt(LuaEntry.Player.uid..LuaEntry.Player.pushMark..SettingKeys.FIRST_PAY_BUY_CLICK, 1)
        EventManager:GetInstance():Broadcast(EventId.PlayerChangeHeadRedPot)
        EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
    end
end

FirstPayClaimRewardMessage.OnCreate = OnCreate
FirstPayClaimRewardMessage.HandleMessage = HandleMessage

return FirstPayClaimRewardMessage