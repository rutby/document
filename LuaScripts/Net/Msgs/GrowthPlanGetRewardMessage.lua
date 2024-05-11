---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/14 16:55
---

local GrowthPlanGetRewardMessage = BaseClass("GrowthPlanGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, param)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("exchangeId", param.packId)
    self.sfsObj:PutUtfString("id", param.id)
    self.sfsObj:PutInt("type", param.type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    
    DataCenter.RewardManager:ShowGiftReward(t, Localization:GetString("320320"))
    
    if t["reward"] ~= nil then
        for _, v in pairs(t["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
    
    local packId = t["exchangeId"]
    if packId then
        -- Cache
        local cacheDict = WelfareController.getWelfareCache(WelfareMessageKey.GrowthPlanInfo) or {}
        local cache = cacheDict[packId]
        if cache then
            for _, data in ipairs(cache.stageInfo) do
                if data.id == cache.id then
                    if cache.type == GetRewardType.Normal then
                        data.normalState = 1
                    elseif cache.type == GetRewardType.Special then
                        data.specialState = 1
                    end
                    break
                end
            end
            WelfareController.setWelfareCache(WelfareMessageKey.GrowthPlanInfo, cacheDict)
            
            -- 礼包中心页面
            EventManager:GetInstance():Broadcast(EventId.GrowthPlanGetReward, t)
            
            -- 礼包中心红点
            EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
        end
    end
end

GrowthPlanGetRewardMessage.OnCreate = OnCreate
GrowthPlanGetRewardMessage.HandleMessage = HandleMessage

return GrowthPlanGetRewardMessage