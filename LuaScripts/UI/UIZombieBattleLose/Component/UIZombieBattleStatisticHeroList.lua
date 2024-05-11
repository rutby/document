local UIZombieBattleStatisticHeroList = BaseClass("UIZombieBattleStatisticHeroList", UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization
local UIStatisticEntry = require("UI.UIParkour.WinUI.Component.UIParkourBattleStatisticHeroEntry")
local UIStatisticWeaponEntry = require("UI.UIZombieBattleLose.Component.UIZombieBattleStatisticWeaponEntry")

-- 创建
function UIZombieBattleStatisticHeroList:OnCreate(statisticalFieldName)
    base.OnCreate(self)
    self:ComponentDefine()
    self.statisticalFieldName = statisticalFieldName
end

-- 销毁
function UIZombieBattleStatisticHeroList:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIZombieBattleStatisticHeroList:OnEnable()
    base.OnEnable(self)
    self.active = true
end

-- 隐藏
function UIZombieBattleStatisticHeroList:OnDisable()
    base.OnDisable(self)
    self.active = false
end

function UIZombieBattleStatisticHeroList:ComponentDefine()
    self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))

    self.heroEntries = {}
    for i = 1, 5 do
        self.heroEntries[i] = self:AddComponent(UIStatisticEntry, "Viewport/Content/HeroEntry_" .. i)
    end
    self.weaponEntry = self:AddComponent(UIStatisticWeaponEntry, "Viewport/Content/WeaponEntry")
end

function UIZombieBattleStatisticHeroList:ComponentDestroy()
    if not IsNull(self.fadeTween) then
        self.fadeTween:Kill()
        self.fadeTween = nil
    end
end

function UIZombieBattleStatisticHeroList:FadeIn()
    if not IsNull(self.fadeTween) then
        self.fadeTween:Kill()
        self.fadeTween = nil
    end

    self.canvasGroup.alpha = 0
    self.fadeTween = CS.DG.Tweening.DOTween.To(function()
        return self.canvasGroup.alpha
    end, function(value)
        self.canvasGroup.alpha = value
    end, 1, 0.5):SetEase(CS.DG.Tweening.Ease.Linear)
end

function UIZombieBattleStatisticHeroList:RefreshView()
    local squad = DataCenter.ZombieBattleManager.squad
    local statisticalData = DataCenter.ZombieBattleManager.heroStatisticalData[self.statisticalFieldName]
    local heroDeathData = DataCenter.ZombieBattleManager.heroStatisticalData.death
    local maxValue = 0
    local heroDatas = {}
    local heroDeaths = {}
    for i = 1, 5 do
        local heroData = squad.heroes[i]
        if heroData then
            table.insert(heroDatas, heroData)
            local value = statisticalData[heroData.uuid] or 0
            if maxValue < value then
                maxValue = value
            end
            table.insert(heroDeaths, heroDeathData[heroData.uuid] or false)
        end
    end
    local weaponStatisticalData = DataCenter.ZombieBattleManager.weaponStatisticalData[self.statisticalFieldName]
    if maxValue < weaponStatisticalData then
        maxValue = weaponStatisticalData
    end
    local weaponData = squad.tacWeaponInfo
    local weaponAppearanceId = squad.tacWeaponAppearanceId

    for i, entry in ipairs(self.heroEntries) do
        local heroData = heroDatas[i]
        if heroData then
            entry:SetActive(true)
            entry:RefreshView(heroData, statisticalData[heroData.uuid] or 0, maxValue, heroDeaths[i])
        else
            entry:SetActive(false)
        end
    end
    
    if self.statisticalFieldName == "makeDmg" and weaponStatisticalData > 0 and weaponData ~= nil then
        self.weaponEntry:SetActive(true)
        self.weaponEntry:RefreshView(weaponData,weaponAppearanceId, weaponStatisticalData, maxValue)
    else
        self.weaponEntry:SetActive(false)
    end
end

return UIZombieBattleStatisticHeroList