---
--- 通用设置界面
--- Created by shimin.
--- DateTime: 2020/9/25 15:15
---
local UISettingSetSound = require "UI.UISetting.UISettingSet.Component.UISettingSetSound"
local UISettingSetPrompt = require "UI.UISetting.UISettingSet.Component.UISettingSetPrompt"
local UISettingSetPerformance = require "UI.UISetting.UISettingSet.Component.UISettingSetPerformance"
local UISettingSetClear = require "UI.UISetting.UISettingSet.Component.UISettingSetClear"
local UISettingSetResolution = require "UI.UISetting.UISettingSet.Component.UISettingSetResolution"
local UISettingSetScreenResolution = require "UI.UISetting.UISettingSet.Component.UISettingSetScreenResolution"
local UISettingSetView = BaseClass("UISettingSetView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local setting_go_path = "CellGo/SettingGo"
local setting_go_slider_path = "CellGo/SettingGoSlider"
local setting_btn_path = "CellGo/SettingBtnGo"
local sound_go_path = "ImgBg/Scroll View/Viewport/Content/SoundGo"
local prompt_go_path = "ImgBg/Scroll View/Viewport/Content/PromptGo"
local clear_go_path = "ImgBg/Scroll View/Viewport/Content/ClearGo"
local performance_go_path = "ImgBg/Scroll View/Viewport/Content/PerformanceGo"
local screen_go_path = "ImgBg/Scroll View/Viewport/Content/ScreenResolutionGo"
--local resolution_go_path = "ImgBg/Scroll View/Viewport/Content/ResolutionGo"
local setting_input_path = "CellGo/SettingInputGo"


--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:SetAllCellsDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.setting_go = self:AddComponent(UIBaseContainer, setting_go_path).gameObject
    self.setting_go_slider = self:AddComponent(UIBaseContainer, setting_go_slider_path).gameObject
    self.setting_btn = self:AddComponent(UIBaseContainer, setting_btn_path).gameObject
    self.setting_input = self:AddComponent(UIBaseContainer, setting_input_path).gameObject
    self.sound_go = self:AddComponent(UISettingSetSound, sound_go_path)
    self.prompt_go = self:AddComponent(UISettingSetPrompt, prompt_go_path)
    self.clear_go = self:AddComponent(UISettingSetClear, clear_go_path)
    self.performance_go = self:AddComponent(UISettingSetPerformance, performance_go_path)
    --self.resolution_go = self:AddComponent(UISettingSetResolution, resolution_go_path)
    self.screen_go = self:AddComponent(UISettingSetScreenResolution, screen_go_path)
    self.setting_go:GameObjectCreatePool()
    self.setting_btn:GameObjectCreatePool()
    self.setting_input:GameObjectCreatePool()
    self.setting_go_slider:GameObjectCreatePool()
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
end

local function ComponentDestroy(self)
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.setting_go = nil
    self.setting_btn = nil
    self.setting_input = nil
    self.sound_go = nil
    self.prompt_go = nil
    self.clear_go = nil
    self.performance_go = nil
    --self.resolution_go = nil
    self.setting_go_slider =nil
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

local function ReInit(self)
    self.txt_title:SetLocalText(280012)
    self.sound_go:ReInit({cell = self.setting_go})
    self.prompt_go:ReInit({cell = self.setting_go})
    self.performance_go:ReInit({cell = self.setting_go, cell1 = self.setting_go_slider, cell2 = self.setting_btn})
    self.clear_go:ReInit({cell = self.setting_btn})
    if CS.SDKManager.IS_UNITY_PC~=nil and  CS.SDKManager.IS_UNITY_PC()==true then
        self.screen_go:ReInit()
    else
        self.screen_go:SetActive(false)
    end
    
    --self.resolution_go:ReInit({cell = self.setting_input})
    self.sound_go:SetActive(true)
    self.performance_go:SetActive(true)

    if CS.SceneManager.IsInPVE() then
    self.prompt_go:SetActive(false)
    self.clear_go:SetActive(false)
    else
    self.prompt_go:SetActive(true)
    self.clear_go:SetActive(true)
    end

    --self.resolution_go:SetActive(true)
    end

-- 表现销毁
local function SetAllCellsDestroy(self)
    self.setting_go:GameObjectRecycleAll()
    self.setting_btn:GameObjectRecycleAll()
    self.setting_input:GameObjectRecycleAll()
    self.setting_go_slider:GameObjectRecycleAll()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.SetScreenResolution, self.OnScreenResolutionRefresh)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.SetScreenResolution, self.OnScreenResolutionRefresh)
end

local function OnScreenResolutionRefresh(self,data)
    self.screen_go:ShowCells()
end

UISettingSetView.OnCreate= OnCreate
UISettingSetView.OnDestroy = OnDestroy
UISettingSetView.OnEnable = OnEnable
UISettingSetView.OnDisable = OnDisable
UISettingSetView.OnAddListener = OnAddListener
UISettingSetView.OnRemoveListener = OnRemoveListener
UISettingSetView.ComponentDefine = ComponentDefine
UISettingSetView.ComponentDestroy = ComponentDestroy
UISettingSetView.DataDefine = DataDefine
UISettingSetView.DataDestroy = DataDestroy
UISettingSetView.ReInit = ReInit
UISettingSetView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingSetView.OnScreenResolutionRefresh = OnScreenResolutionRefresh
return UISettingSetView