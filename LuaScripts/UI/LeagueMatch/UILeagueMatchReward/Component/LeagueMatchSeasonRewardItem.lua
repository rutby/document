---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/2 17:56
--- LeagueMatchSeasonRewardItem.lua


local LeagueMatchSeasonRewardItem = BaseClass("LeagueMatchSeasonRewardItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LeagueMatchRewardItem = require "UI.LeagueMatch.UILeagueMatchReward.Component.LeagueMatchRewardItem"

local seasonRank_path = "head/headSeason"
local seasonNum_path = "head/Text_num32"
local headRank_path = "head/headRank"
local headReward_path = "head/headReward"
local content_path = "content"

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
    self.seasonRankN = self:AddComponent(UITextMeshProUGUIEx, seasonRank_path)
    self.seasonRankN:SetLocalText(280137)
    self.seasonNumN = self:AddComponent(UITextMeshProUGUIEx, seasonNum_path)
    self.headRankN = self:AddComponent(UITextMeshProUGUIEx, headRank_path)
    self.headRankN:SetLocalText(372819)
    self.headRewardN = self:AddComponent(UITextMeshProUGUIEx, headReward_path)
    self.headRewardN:SetLocalText(302181)
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.seasonRankN = nil
    self.headRankN = nil
    self.headRewardN = nil
    self.contentN = nil
end

--变量的定义
local function DataDefine(self)
    self.rewardList = nil
    self.rewardItems = {}
end

--变量的销毁
local function DataDestroy(self)
    self.rewardList = nil
    self.rewardItems = nil
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
        self.seasonNumN:SetText(rewardInfo.start)
    else
        self.seasonNumN:SetText(rewardInfo.start .. "-" .. rewardInfo["end"])
    end
    
    self.rewardList = rewardInfo.userRankRewards
    if #self.rewardItems < #self.rewardList then
        self:ClearLoadingReq()
        self.reqList = {}
        for i = #self.rewardItems + 1, #self.rewardList do
            self.reqList[i] = self:GameObjectInstantiateAsync(UIAssets.LeagueMatchRewardItem, function(request)
                if request.isError then
                    return
                end
                self.reqList[i] = nil
                local go = request.gameObject;
                go:SetActive(false)
                --go.gameObject:SetActive(true)
                go.transform:SetParent(self.contentN.transform)
                go.transform:Set_localScale(1, 1, 1)
                --go.transform:Set_localPosition(0, -50,0)
                go.name ="item" .. i
                local cell = self.contentN:AddComponent(LeagueMatchRewardItem, go.name)
                table.insert(self.rewardItems, cell)
                if #self.rewardItems == table.count(self.rewardList) then
                    self:RefreshRewards()
                end
            end)
        end
    else
        self:RefreshRewards()
    end
end


local function RefreshRewards(self)
    for i, v in ipairs(self.rewardItems) do
        if i <= #self.rewardList then
            v:SetActive(true)
            v:SetItem(self.rewardList[i])
        else
            v:SetActive(false)
        end
    end
end

local function ClearLoadingReq(self)
    if self.reqList~=nil then
        for k,v in pairs(self.reqList) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

LeagueMatchSeasonRewardItem.OnCreate = OnCreate
LeagueMatchSeasonRewardItem.OnDestroy = OnDestroy
LeagueMatchSeasonRewardItem.ComponentDefine = ComponentDefine
LeagueMatchSeasonRewardItem.ComponentDestroy = ComponentDestroy
LeagueMatchSeasonRewardItem.DataDefine = DataDefine
LeagueMatchSeasonRewardItem.DataDestroy = DataDestroy
LeagueMatchSeasonRewardItem.OnAddListener = OnAddListener
LeagueMatchSeasonRewardItem.OnRemoveListener = OnRemoveListener

LeagueMatchSeasonRewardItem.SetItem = SetItem
LeagueMatchSeasonRewardItem.RefreshRewards = RefreshRewards
LeagueMatchSeasonRewardItem.ClearLoadingReq = ClearLoadingReq

return LeagueMatchSeasonRewardItem