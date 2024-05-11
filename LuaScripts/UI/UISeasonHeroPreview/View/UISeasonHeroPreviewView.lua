--- Created by shimin.
--- DateTime: 2020/8/17 15:18
--- UISeasonHeroPreviewView.lua

local UISeasonHeroPreviewView = BaseClass("UISeasonHeroPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIMapHeroRow = require "UI.UIHero2.UIHeroList.Component.UIMapHeroRow"

local title_path = "Root/UICommonRewardPopUpTitleBg/TextTitle"
local tips_path = "Root/tip"
local heroRow_path = "Root/PanelMap/Scroll View/Viewport/HeroRow"
local backBtn_path = "Root/backBtn"
local backBtnTxt_path = "Root/backBtn/backBtnTxt"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitData()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.titleN:SetLocalText(110484)
    self.tipsN = self:AddComponent(UIText, tips_path)
    self.tipsN:SetLocalText(110485)
    self.backBtnN = self:AddComponent(UIButton, backBtn_path)
    self.backBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.backBtnTxtN = self:AddComponent(UIText, backBtnTxt_path)
    self.backBtnTxtN:SetLocalText(300520)
    self.heroRowN = self:AddComponent(UIMapHeroRow, heroRow_path)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.tipsN = nil
    self.backBtnN = nil
    self.backBtnTxtN = nil
    self.heroRowN = nil
end


local function DataDefine(self)
    self.seasonId = 2
end

local function DataDestroy(self)
    self.seasonId = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function InitData(self)
    self.seasonId = DataCenter.SeasonDataManager:GetSeasonId()
    self.seasonId = self.seasonId + 1
    
    self:RefreshAll()
end

local function RefreshAll(self)
    self.pureDataList = self:GenerateMapDataList()
    self.heroRowN:SetData(self.pureDataList, self.pureDataList)
end

local function GenerateMapDataList(self)
    local selectCamp = -1
    local rarityDict = {}

    LocalController:instance():visitTable(HeroUtils.GetHeroXmlName(), function(id, line)
        local camp = tonumber(line["camp"])
        --过滤阵营
        if camp < 0 or (selectCamp ~= -1 and camp ~= selectCamp) then
            return
        end
        local state = tonumber(line['state'])
        if state == HeroUtils.HeroStateType.HeroStateType_NPC then
            return
        end
        local checkSeason = self.seasonId
        if checkSeason ~= nil then
            local season = tonumber(line['season'])
            if season ~= checkSeason then
                return
            end
        end
        local rarity = tonumber(line['rarity'])
        local maxQuality = tonumber(line[HeroUtils.GetHeroMaxQualityLevelName()])
        local maxRankId = line['max_rank_level']
        local maxLevel = tonumber(HeroUtils.GetHeroCurrentMaxLevel(id, maxQuality, maxRankId))
        local season = tonumber(line['season'])

        if rarityDict[100] == nil then
            rarityDict[100] = {}
        end

        table.insert(rarityDict[100], {heroId = id, camp = camp, rarity = rarity, quality = maxQuality, level = maxLevel, season = season})
    end)


    for _, heroList in pairs(rarityDict) do
        table.sort(heroList, function (a, b)
            return self.view.ctrl:SortHero(a, b, nil, nil, true)
        end)
    end

    local keys = table.keys(rarityDict)
    table.sort(keys, function(a, b) return a < b end)

    local pureDataList = {}
    for _, rarity in ipairs(keys) do
        local heroList = rarityDict[rarity]
        table.insertto(pureDataList, heroList)
    end
    
    return pureDataList
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

local function OnClickInfoBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRobotWarsIntro, { anim = true, hideTop = true})
end

UISeasonHeroPreviewView.OnCreate = OnCreate
UISeasonHeroPreviewView.OnDestroy = OnDestroy
UISeasonHeroPreviewView.OnEnable = OnEnable
UISeasonHeroPreviewView.OnDisable = OnDisable
UISeasonHeroPreviewView.ComponentDefine = ComponentDefine
UISeasonHeroPreviewView.ComponentDestroy = ComponentDestroy
UISeasonHeroPreviewView.DataDefine = DataDefine
UISeasonHeroPreviewView.DataDestroy = DataDestroy

UISeasonHeroPreviewView.InitData = InitData
UISeasonHeroPreviewView.RefreshAll = RefreshAll
UISeasonHeroPreviewView.GenerateMapDataList = GenerateMapDataList
UISeasonHeroPreviewView.OnClickCloseBtn = OnClickCloseBtn
UISeasonHeroPreviewView.OnClickInfoBtn = OnClickInfoBtn

return UISeasonHeroPreviewView