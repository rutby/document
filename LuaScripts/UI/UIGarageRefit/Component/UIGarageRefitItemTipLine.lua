---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/3/9 17:44
---

local UIGarageRefitItemTipLine = BaseClass("UIGarageRefitItemTipLine", UIBaseContainer)
local base = UIBaseContainer

local effect_path = "Effect"
local effect_val_path = "EffectVal"

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

local function ComponentDefine(self)
    self.effect_text = self:AddComponent(UITextMeshProUGUIEx, effect_path)
    self.effect_val_text = self:AddComponent(UITextMeshProUGUIEx, effect_val_path)
end

local function ComponentDestroy(self)
    self.effect_text = nil
    self.effect_val_text = nil
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetData(self, effectStr, effectValStr)
    self.effect_text:SetText(effectStr)
    self.effect_val_text:SetText(effectValStr)
end

UIGarageRefitItemTipLine.OnCreate= OnCreate
UIGarageRefitItemTipLine.OnDestroy = OnDestroy
UIGarageRefitItemTipLine.ComponentDefine = ComponentDefine
UIGarageRefitItemTipLine.ComponentDestroy = ComponentDestroy
UIGarageRefitItemTipLine.DataDefine = DataDefine
UIGarageRefitItemTipLine.DataDestroy = DataDestroy
UIGarageRefitItemTipLine.OnEnable = OnEnable
UIGarageRefitItemTipLine.OnDisable = OnDisable

UIGarageRefitItemTipLine.SetData = SetData

return UIGarageRefitItemTipLine