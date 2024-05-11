---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/4/13 16:35
---
local UISettingSetScreenResolution = BaseClass("UISettingSetScreenResolution", UIBaseContainer)
local UISettingSliderCell = require "UI.UISetting.UISettingSet.Component.UISettingSliderCell"
local UISettingBtnCell = require "UI.UISetting.UISettingSet.Component.UISettingBtnCell"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local title_name_path = "TitleBg/TitleName"

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

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.title_name = self:AddComponent(UITextMeshProUGUIEx, title_name_path)
    self.full_screen = self:AddComponent(UISettingSliderCell,"fullScreen")
    self.set_screen = self:AddComponent(UISettingBtnCell,"setScreen")
end

--控件的销毁
local function ComponentDestroy(self)
    self.title_name = nil
end

--变量的定义
local function DataDefine(self)
    self.param = {}
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
end

-- 全部刷新
local function ReInit(self)
    self.title_name:SetText("Screen Resolution")
    self:ShowCells()
end


local function ShowCells(self)
    self.full_screen:ReInit({setType = SettingSetType.FullScreen})
    self.set_screen:ReInit({setType = SettingSetType.ScreenResolution})
end



UISettingSetScreenResolution.OnCreate = OnCreate
UISettingSetScreenResolution.OnDestroy = OnDestroy
UISettingSetScreenResolution.OnEnable = OnEnable
UISettingSetScreenResolution.OnDisable = OnDisable
UISettingSetScreenResolution.ComponentDefine = ComponentDefine
UISettingSetScreenResolution.ComponentDestroy = ComponentDestroy
UISettingSetScreenResolution.DataDefine = DataDefine
UISettingSetScreenResolution.DataDestroy = DataDestroy
UISettingSetScreenResolution.ReInit = ReInit
UISettingSetScreenResolution.ShowCells = ShowCells

return UISettingSetScreenResolution