local UIZombieBattleStatisticWeaponEntry = BaseClass("UIZombieBattleStatisticWeaponEntry", UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization
local UILWTacticalWeaponItem = require "UI.UILWTacticalWeapon.Component.UILWTacticalWeaponItem"

-- 创建
function UIZombieBattleStatisticWeaponEntry:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

-- 销毁
function UIZombieBattleStatisticWeaponEntry:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIZombieBattleStatisticWeaponEntry:OnEnable()
    base.OnEnable(self)
    self.active = true
end

-- 隐藏
function UIZombieBattleStatisticWeaponEntry:OnDisable()
    base.OnDisable(self)
    self.active = false
end

function UIZombieBattleStatisticWeaponEntry:ComponentDefine()
    self.txtName = self:AddComponent(UIText, "WeaponName")
    self.txtDmg = self:AddComponent(UIText, "DmgTxt")
    self.barBg = self:AddComponent(UIBaseContainer, "ProgressBar")
    self.barInner = self:AddComponent(UIBaseContainer, "ProgressBar/Inner")
    self.weaponItem = self:AddComponent(UILWTacticalWeaponItem, "UILWTacticalWeaponItem")
end

function UIZombieBattleStatisticWeaponEntry:ComponentDestroy()
    if not IsNull(self.tween) then
        self.tween:Kill()
        self.tween = nil
    end
end

function UIZombieBattleStatisticWeaponEntry:RefreshView(weaponData,appearanceId, value, maxValue)
    if not IsNull(self.tween) then
        self.tween:Kill()
        self.tween = nil
    end

    self.weaponItem:SetData(weaponData,appearanceId)
    self.txtName:SetText(weaponData:GetName())
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

return UIZombieBattleStatisticWeaponEntry