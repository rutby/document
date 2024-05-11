local UIZombieBattleStatisticHeroEntry = BaseClass("UIZombieBattleStatisticHeroEntry", UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"

-- 创建
function UIZombieBattleStatisticHeroEntry:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

-- 销毁
function UIZombieBattleStatisticHeroEntry:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIZombieBattleStatisticHeroEntry:OnEnable()
    base.OnEnable(self)
    self.active = true
end

-- 隐藏
function UIZombieBattleStatisticHeroEntry:OnDisable()
    base.OnDisable(self)
    self.active = false
end

function UIZombieBattleStatisticHeroEntry:ComponentDefine()
    self.txtName = self:AddComponent(UIText, "HeroName")
    self.txtDmg = self:AddComponent(UIText, "DmgTxt")
    self.barBg = self:AddComponent(UIBaseContainer, "ProgressBar")
    self.barInner = self:AddComponent(UIBaseContainer, "ProgressBar/Inner")
    self.heroCell = self:AddComponent(UIHeroCellSmall, "UIHeroCellSmall")
end

function UIZombieBattleStatisticHeroEntry:ComponentDestroy()
    if not IsNull(self.tween) then
        self.tween:Kill()
        self.tween = nil
    end
end

function UIZombieBattleStatisticHeroEntry:RefreshView(heroData, value, maxValue)
    if not IsNull(self.tween) then
        self.tween:Kill()
        self.tween = nil
    end

    self.heroCell:SetData(heroData.uuid)
    self.txtName:SetText(Localization:GetString(heroData.firstName))
    self.txtDmg:SetText(0)
    local barSize = self.barBg:GetSizeDelta()
    self.barInner:SetSizeDelta(Vector2(0, barSize.y))
    
    self.progress = 0
    local percent = value / maxValue
    self.tween = CS.DG.Tweening.DOTween.To(function()
        return self.progress
    end, function(p)
        self.progress = value
        local pValue = value * p
        self.txtDmg:SetText(string.GetFormattedStr(pValue))
        self.barInner:SetSizeDelta(Vector2(p * percent * barSize.x, barSize.y))
    end, 1, percent * 1):SetEase(CS.DG.Tweening.Ease.OutCubic)
end

return UIZombieBattleStatisticHeroEntry