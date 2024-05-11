---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/22 12:03
--- LeagueMatchRewardItem.lua

local LeagueMatchRewardItem = BaseClass("LeagueMatchRewardItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local LMRewardItemCell = require "UI.LeagueMatch.UILeagueMatchReward.Component.LMRewardItemCell"

local rank_path = "rank"
local rankImg_path = "rankImg"
local rewards_path = "rewards/reward_"
local decoration_path = "Rect_Decoration"

-- 创建 
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.rankN = self:AddComponent(UITextMeshProUGUIEx, rank_path)
    self.rankImgN = self:AddComponent(UIImage, rankImg_path)
    self.rewardsTbN = {}
    for i = 1, 8 do
        local reward = self:AddComponent(LMRewardItemCell, rewards_path .. i)
        table.insert(self.rewardsTbN, reward)
    end
    self._decoration_rect = self:AddComponent(UICommonItem,decoration_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.rankN = nil
    self.rewardsTbN = nil
end

--变量的定义
local function DataDefine(self)
    
end

--变量的销毁
local function DataDestroy(self)
    
end


local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnCandidateInfoUpdated)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnCandidateInfoUpdated)
end

local function SetItem(self, rewardInfo)
    if rewardInfo.start == rewardInfo["end"] then
        if tonumber(rewardInfo.start) <= 3 then
            self.rankImgN:SetActive(true)
            self.rankN:SetText("")
            self.rankImgN:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/rank/UIalliance_rankingbg0" .. rewardInfo.start)
        else
            self.rankImgN:SetActive(false)
            self.rankN:SetText(rewardInfo.start)
        end
    else
        self.rankImgN:SetActive(false)
        self.rankN:SetText(rewardInfo.start .. "-" .. rewardInfo["end"])
    end

    local rewardCount = 0
    local rewardsList = DataCenter.RewardManager:ReturnRewardParamForMessage(rewardInfo.reward)
    if rewardsList ~= nil then
        rewardCount = #rewardsList
        for i, v in ipairs(rewardsList) do
            if v.rewardType == RewardType.GOLD then
                local tempR = v
                table.remove(rewardsList, i)
                table.insert(rewardsList, 1, tempR)
                break
            end
        end
    end
    for i, v in ipairs(self.rewardsTbN) do
        if i <= rewardCount then
            v:SetActive(true)
            v:ReInit(rewardsList[i])
        else
            v:SetActive(false)
        end
    end
    if rewardInfo.titleSkinId then
        local param = {}
        param.rewardType = RewardType.DECORATION
        param.itemId = rewardInfo.titleSkinId
        self._decoration_rect:ReInit(param)
        self._decoration_rect:SetActive(true)
    else
        self._decoration_rect:SetActive(false)
    end
end

LeagueMatchRewardItem.OnCreate = OnCreate
LeagueMatchRewardItem.OnDestroy = OnDestroy
LeagueMatchRewardItem.ComponentDefine = ComponentDefine
LeagueMatchRewardItem.ComponentDestroy = ComponentDestroy
LeagueMatchRewardItem.DataDefine = DataDefine
LeagueMatchRewardItem.DataDestroy = DataDestroy
LeagueMatchRewardItem.OnAddListener = OnAddListener
LeagueMatchRewardItem.OnRemoveListener = OnRemoveListener

LeagueMatchRewardItem.SetItem = SetItem

return LeagueMatchRewardItem