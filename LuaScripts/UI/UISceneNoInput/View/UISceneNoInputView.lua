---
--- 遮挡场景点击UI界面
--- Created by shimin.
--- DateTime: 2021/12/13 11:41
---
local UISceneNoInputView = BaseClass("UISceneNoInputView",UIBaseView)
local base = UIBaseView

local btn_path = "NoInputImg"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.btn = nil
end


local function DataDefine(self)
    self.clickTime = 0
end

local function DataDestroy(self)
    self.clickTime = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.clickTime = 0
    self.transform:SetAsFirstSibling()
    DataCenter.UINoInputManager:CloseWindow(UIWindowNames.UINoInput)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

local function OnBtnClick(self)
    self.clickTime = self.clickTime + 1
    if self.clickTime >= GuideClickAutoStopTime then
        self.clickTime = 0
        DataCenter.GuideManager:ClickMuchStop()
    end
end


local function RefreshGuideSignal(self)
    self.clickTime = 0
end

UISceneNoInputView.OnCreate= OnCreate
UISceneNoInputView.OnDestroy = OnDestroy
UISceneNoInputView.OnEnable = OnEnable
UISceneNoInputView.OnDisable = OnDisable
UISceneNoInputView.OnAddListener = OnAddListener
UISceneNoInputView.OnRemoveListener = OnRemoveListener
UISceneNoInputView.ComponentDefine = ComponentDefine
UISceneNoInputView.ComponentDestroy = ComponentDestroy
UISceneNoInputView.DataDefine = DataDefine
UISceneNoInputView.DataDestroy = DataDestroy
UISceneNoInputView.ReInit = ReInit
UISceneNoInputView.OnBtnClick = OnBtnClick
UISceneNoInputView.RefreshGuideSignal = RefreshGuideSignal

return UISceneNoInputView