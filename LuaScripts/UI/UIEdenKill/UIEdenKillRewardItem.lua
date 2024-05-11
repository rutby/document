---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/8/3 16:00
---

local UIEdenKillRewardItem = BaseClass("UIEdenKillRewardItem", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local rank_path = "Rank"
local rank_icon_path = "RankIcon"
local reward_path = "Rewards/Reward%s"

local RewardCount = 6

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.rank_text = self:AddComponent(UIText, rank_path)
    self.rank_icon_image = self:AddComponent(UIImage, rank_icon_path)
    self.reward_items = {}
    for i = 1, RewardCount do
        self.reward_items[i] = self:AddComponent(UICommonItem, string.format(reward_path, i))
    end
end

local function ComponentDestroy(self)

end

local function DataDefine(self)

end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, data)
    if data["start"] == data["end"] then
        local rank = data["start"]
        if rank <= 3 then
            self.rank_text:SetActive(false)
            self.rank_icon_image:SetActive(true)
            self.rank_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg0" .. rank)
        else
            self.rank_text:SetActive(true)
            self.rank_text:SetText(rank)
            self.rank_icon_image:SetActive(false)
        end
    else
        self.rank_text:SetActive(true)
        self.rank_text:SetText(data["start"] .. "-" .. data["end"])
        self.rank_icon_image:SetActive(false)
    end
    
    -- reward
    local rewardList = DataCenter.RewardManager:ReturnRewardParamForView(data.reward) or {}
    for i, reward in ipairs(rewardList) do
        reward.i = i
    end
    table.sort(rewardList, function(rewardA, rewardB)
        if rewardA.rewardType == RewardType.GOODS and rewardB.rewardType ~= RewardType.GOODS then
            return false
        elseif rewardA.rewardType ~= RewardType.GOODS and rewardB.rewardType == RewardType.GOODS then
            return true
        else
            return rewardA.i < rewardB.i
        end
    end)
    for i = 1, RewardCount do
        if i <= #rewardList then
            self.reward_items[i]:SetActive(true)
            self.reward_items[i]:ReInit(rewardList[i])
        else
            self.reward_items[i]:SetActive(false)
        end
    end
end

UIEdenKillRewardItem.OnCreate = OnCreate
UIEdenKillRewardItem.OnDestroy = OnDestroy
UIEdenKillRewardItem.OnEnable = OnEnable
UIEdenKillRewardItem.OnDisable = OnDisable
UIEdenKillRewardItem.ComponentDefine = ComponentDefine
UIEdenKillRewardItem.ComponentDestroy = ComponentDestroy
UIEdenKillRewardItem.DataDefine = DataDefine
UIEdenKillRewardItem.DataDestroy = DataDestroy
UIEdenKillRewardItem.OnAddListener = OnAddListener
UIEdenKillRewardItem.OnRemoveListener = OnRemoveListener

UIEdenKillRewardItem.SetData = SetData

return UIEdenKillRewardItem