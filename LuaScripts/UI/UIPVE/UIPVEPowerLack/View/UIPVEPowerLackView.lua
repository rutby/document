---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/11/4 14:33
---

local UIPVEPowerLack = BaseClass("UIPVEPowerLack", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPVEPowerLackScrollView = require "UI.UIPVE.UIPVEPowerLack.Component.UIPVEPowerLackScrollView"

local close_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local panel_path = "UICommonMidPopUpTitle/panel"
local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local scroll_view_path = "UIPVEPowerLackScrollView"

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
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.panel_btn = self:AddComponent(UIButton, panel_path)
    self.panel_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.scroll_view = self:AddComponent(UIPVEPowerLackScrollView, scroll_view_path)
end

local function ComponentDestroy(self)
    self.close_btn = nil
    self.panel_btn = nil
    self.title_text = nil
    self.scroll_view = nil
end

local function DataDefine(self)
    self.active = false
    self.tips = {}
end

local function DataDestroy(self)
    self.active = nil
    self.tips = {}
end

local function OnEnable(self)
    base.OnEnable(self)
    self.active = true
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
    self.active = false
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local param = self:GetUserData()
    local lackType, tips = PveUtil.GetPowerLack(param)
    self.tips = tips
    local titleStr
    if lackType == PvePowerLackType.Power then
        titleStr = Localization:GetString("126002", Localization:GetString("100644"))
    elseif lackType == PvePowerLackType.Army then
        titleStr = Localization:GetString("126002", Localization:GetString("140310"))
    elseif lackType == PvePowerLackType.Hero then
        titleStr = Localization:GetString("126002", Localization:GetString("163153"))
    else
        titleStr = ""
    end
    self.title_text:SetText(titleStr)
    
    self.scroll_view:SetData(lackType, tips, 4, param.showBg, function()
        if self.active then
            self.ctrl:CloseSelf()
        end
    end)
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.FightLevelLackPanel, tostring(lackType))
end

--是否显示这个类型
local function HasTip(self, tip)
    return self.scroll_view:HasTip(tip)
end

UIPVEPowerLack.OnCreate = OnCreate
UIPVEPowerLack.OnDestroy = OnDestroy
UIPVEPowerLack.ComponentDefine = ComponentDefine
UIPVEPowerLack.ComponentDestroy = ComponentDestroy
UIPVEPowerLack.DataDefine = DataDefine
UIPVEPowerLack.DataDestroy = DataDestroy
UIPVEPowerLack.OnEnable = OnEnable
UIPVEPowerLack.OnDisable = OnDisable
UIPVEPowerLack.OnAddListener = OnAddListener
UIPVEPowerLack.OnRemoveListener = OnRemoveListener

UIPVEPowerLack.ReInit = ReInit
UIPVEPowerLack.HasTip = HasTip


return UIPVEPowerLack