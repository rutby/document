---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wsf.
--- DateTime: 2023/11/3 10:55 AM
---

local UIParkourBattleStatisticHeroList = BaseClass("UIParkourBattleStatisticHeroList", UIBaseContainer)
local base = UIBaseContainer

local UIStatisticEntry = require "UI.UIParkour.WinUI.Component.UIParkourBattleStatisticHeroEntry"

-- 创建
function UIParkourBattleStatisticHeroList:OnCreate(statisticalFieldName)
    base.OnCreate(self)
    self:ComponentDefine()
    self.statisticalFieldName = statisticalFieldName
end

-- 销毁
function UIParkourBattleStatisticHeroList:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIParkourBattleStatisticHeroList:OnEnable()
    base.OnEnable(self)
    self.active = true
end

-- 隐藏
function UIParkourBattleStatisticHeroList:OnDisable()
    base.OnDisable(self)
    self.active = false
end

function UIParkourBattleStatisticHeroList:ComponentDefine()
    self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))

    self.heroEntries = {}
    for i = 1, 5 do
        self.heroEntries[i] = self:AddComponent(UIStatisticEntry, "Viewport/Content/HeroEntry_" .. i)
    end
end

function UIParkourBattleStatisticHeroList:ComponentDestroy()
    if not IsNull(self.fadeTween) then
        self.fadeTween:Kill()
        self.fadeTween = nil
    end
end

function UIParkourBattleStatisticHeroList:FadeIn()
    if not IsNull(self.fadeTween) then
        self.fadeTween:Kill()
        self.fadeTween = nil
    end

    self.canvasGroup.alpha = 0
    self.fadeTween = DOTween.To(function()
        return self.canvasGroup.alpha
    end, function(value)
        self.canvasGroup.alpha = value
    end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIParkourBattleStatisticHeroList:RefreshView()
    local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
    local team = battleLogic.team.teamInitUnits
    local statisticalData = battleLogic.heroStatisticalData[self.statisticalFieldName]
    local heroDeathData = battleLogic.heroStatisticalData.death
    local maxValue = 0
    local heroDatas = {}
    local heroDeaths = {}
    for i = 1, 5 do
        local hero = team[i]
        if hero then
            --HeroInfo
            local heroData = hero.hero
            table.insert(heroDatas, heroData)
            local value = statisticalData[heroData.uuid] or 0
            if maxValue < value then
                maxValue = value
            end
            table.insert(heroDeaths, heroDeathData[heroData.uuid] or false)
        end
    end
    local weaponStatisticalData = battleLogic.weaponStatisticalData[self.statisticalFieldName]
    if maxValue < weaponStatisticalData then
        maxValue = weaponStatisticalData
    end

    for i, entry in ipairs(self.heroEntries) do
        local heroData = heroDatas[i]
        if heroData then
            local statisticalValue = statisticalData[heroData.uuid]
            if statisticalValue then
                entry:SetActive(true)
                entry:RefreshView(heroData, statisticalValue, maxValue, heroDeaths[i])
            else
                entry:SetActive(false)
            end
        else
            entry:SetActive(false)
        end
    end
end

return UIParkourBattleStatisticHeroList
