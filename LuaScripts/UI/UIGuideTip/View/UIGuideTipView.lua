---
--- 引导提示说明界面
--- Created by shimin.
--- DateTime: 2021/10/20 18:07
---
local UIGuideTipView = BaseClass("UIGuideTipView",UIBaseView)
local base = UIBaseView

local panel_path = "Panel"
local position_go_path = "RotationGo"

--创建
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

local function ComponentDefine(self)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.position_go = self:AddComponent(UIBaseContainer, position_go_path)
    self.panel:SetOnClick(function()
        self:OnBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.panel = nil
    self.position_go = nil
end


local function DataDefine(self)
    self.can_close_timer_action = function()
        self:CanCloseTimerAction()
    end
    self.auto_to_do_next_timer_action = function()
        self:AutoDoNextTimerAction()
    end
    self.canClose = nil
end

local function DataDestroy(self)
    self:DeleteCanCloseTimer()
    self:DeleteAutoDoNextTimer()
    self.canClose = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    if DataCenter.GuideManager:GetGuideType() ~= GuideType.ShowGuideTip then
        Logger.LogError("shimin ---------- UIGuideTipView open and close error")
    end
    self:Refresh()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

local function DeleteTimer(self)
    if self.delayCloseTimer then
        self.delayCloseTimer:Stop()
        self.delayCloseTimer = nil
    end
end

local function RefreshGuideAnimSignal(self)
    self:Refresh()
end

local function AddCanCloseTimer(self,time)
    self:DeleteCanCloseTimer()
    self.canCloseTimer = TimerManager:GetInstance():GetTimer(time, self.can_close_timer_action , self, true,false,false)
    self.canCloseTimer:Start()
end

local function CanCloseTimerAction(self)
    self:DeleteCanCloseTimer()
    self.canClose = true
end

local function DeleteCanCloseTimer(self)
    if self.canCloseTimer then
        self.canCloseTimer:Stop()
        self.canCloseTimer = nil
    end
end

local function AddAutoDoNextTimer(self,time)
    self:DeleteAutoDoNextTimer()
    self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_to_do_next_timer_action , self, true,false,false)
    self.autoDoNextTimer:Start()
end

local function AutoDoNextTimerAction(self)
    self:DeleteAutoDoNextTimer()
    self.canClose = true
    self:OnBtnClick()
end

local function DeleteAutoDoNextTimer(self)
    if self.autoDoNextTimer then
        self.autoDoNextTimer:Stop()
        self.autoDoNextTimer = nil
    end
end

local function OnBtnClick(self)
    if self.canClose then
        self.canClose = false
        self:DeleteAutoDoNextTimer()
        local nextType = DataCenter.GuideManager:GetNextGuideTemplateParam("type")
        if nextType ~= GuideType.ShowGuideTip then
            self.ctrl:CloseSelf()
        end
        DataCenter.GuideManager:DoNext()
    end
end

local function Refresh(self)
    if DataCenter.GuideManager:GetGuideType() == GuideType.ShowGuideTip then
        local template = DataCenter.GuideManager:GetCurTemplate()
        local time = template:GetAutoDoNextTime()
        if time ~= nil and time > 0 then
            self:AddAutoDoNextTimer(time / 1000)
        end
        if template.para3 == nil or template.para3 == "" then
            self.canClose = false
        else
            self.canClose = false
            self:AddCanCloseTimer(tonumber(template.para3) / 1000)
        end
        if template.para2 ~= nil and template.para2 ~= "" then
            local spl = string.split(template.para2,";")
            if #spl > 1 then
                local btnType = tonumber(spl[1])
                if btnType == GuideType.ClickButton then
                    if DataCenter.GuideManager.obj ~= nil then
                        self.position_go.transform.position = DataCenter.GuideManager.obj.transform.position
                        self.position_go:SetActive(true)
                    end
                end
            end
        else
            self.position_go:SetActive(false)
        end
    else
        self.ctrl:CloseSelf()
    end
end

local function RefreshGuideSignal(self)
    self:Refresh()
end

UIGuideTipView.OnCreate= OnCreate
UIGuideTipView.OnDestroy = OnDestroy
UIGuideTipView.OnEnable = OnEnable
UIGuideTipView.OnDisable = OnDisable
UIGuideTipView.OnAddListener = OnAddListener
UIGuideTipView.OnRemoveListener = OnRemoveListener
UIGuideTipView.ComponentDefine = ComponentDefine
UIGuideTipView.ComponentDestroy = ComponentDestroy
UIGuideTipView.DataDefine = DataDefine
UIGuideTipView.DataDestroy = DataDestroy
UIGuideTipView.ReInit = ReInit
UIGuideTipView.DeleteTimer = DeleteTimer
UIGuideTipView.AddAutoDoNextTimer = AddAutoDoNextTimer
UIGuideTipView.DeleteAutoDoNextTimer = DeleteAutoDoNextTimer
UIGuideTipView.Refresh = Refresh
UIGuideTipView.RefreshGuideSignal = RefreshGuideSignal
UIGuideTipView.RefreshGuideAnimSignal = RefreshGuideAnimSignal
UIGuideTipView.AutoDoNextTimerAction = AutoDoNextTimerAction
UIGuideTipView.DeleteCanCloseTimer = DeleteCanCloseTimer
UIGuideTipView.AddCanCloseTimer = AddCanCloseTimer
UIGuideTipView.CanCloseTimerAction = CanCloseTimerAction
UIGuideTipView.OnBtnClick = OnBtnClick

return UIGuideTipView