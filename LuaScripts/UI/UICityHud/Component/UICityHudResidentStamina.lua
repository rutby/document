---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/27 20:56
---

local base = require "UI.UICityHud.Component.UICityHudBase"
local UICityHudResidentStamina = BaseClass("UICityHudResidentStamina", base)

local front_slider_path = "Root/Scale/FrontSlider"
local back_slider_path = "Root/Scale/BackSlider"

local Duration = 0.5

local function ComponentDefine(self)
    base.ComponentDefine(self)
    self.front_slider = self:AddComponent(UISlider, front_slider_path)
    self.front_slider:SetValue(1)
    self.back_slider = self:AddComponent(UISlider, back_slider_path)
    self.back_slider:SetValue(1)
end

local function DataDefine(self)
    base.DataDefine(self)
    self.lodMax = 2
    self.tween = nil
end

local function DataDestroy(self)
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
    base.DataDestroy(self)
end

local function SetParam(self, param)
    base.SetParam(self, param)
    local residentData = DataCenter.VitaManager:GetResidentData(param.uuid)
    local percent = residentData:GetCurStamina() / residentData:GetMaxStamina()
    self.front_slider:SetValue(percent)
    if self.tween then
        self.tween:Kill()
    end
    self.tween = self.back_slider.unity_uislider:DOValue(percent, Duration)
end

UICityHudResidentStamina.ComponentDefine = ComponentDefine
UICityHudResidentStamina.DataDefine = DataDefine
UICityHudResidentStamina.DataDestroy = DataDestroy
UICityHudResidentStamina.SetParam = SetParam

return UICityHudResidentStamina