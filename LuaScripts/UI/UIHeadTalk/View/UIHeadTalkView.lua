---
--- 头像对话界面
--- Created by shimin.
--- DateTime: 2022/9/2 15:08
---
local UIHeadTalkView = BaseClass("UIHeadTalkView",UIBaseView)
local base = UIBaseView

local this_path = ""
local des_text_path = "SpineBg/DesGo/Text_A28p"
local spine_bg_path = "SpineBg/SpineGo"

--创建
function UIHeadTalkView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIHeadTalkView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end
--控件定义
function UIHeadTalkView:ComponentDefine()
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.spine_bg = self:AddComponent(UIBaseContainer, spine_bg_path)
end
--控件销毁
function UIHeadTalkView:ComponentDestroy()
    self.anim = nil
    self.des_text = nil
    self.spine_bg = nil
end
--数据定义
function UIHeadTalkView:DataDefine()
    self.param = nil
    self.lastModelName = nil
    self.timer_action = function()
        self:TimerAction()
    end
    self.next_timer_callback = function()
        self:NextTimerCallBack()
    end
    self.spine = {}
    self.useIndex = 1
end
--数据销毁
function UIHeadTalkView:DataDestroy()
    self:DeleteDelayCloseTimer()
    self:DeleteNextTimer()
    self.param = nil
    self.lastModelName = nil
    self.timer_action = nil
    self.next_timer_callback = nil
    self.spine = {}
    self.useIndex = 1
end

function UIHeadTalkView:OnEnable()
    base.OnEnable(self)
end

function UIHeadTalkView:OnDisable()
    base.OnDisable(self)
end

function UIHeadTalkView:ReInit()
    self.param = self:GetUserData()
    self.useIndex = 1
    self:Refresh()
end

function UIHeadTalkView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshUIHeadTalk, self.RefreshUIHeadTalkSignal)
    self:AddUIListener(EventId.CloseUIGuideHeadTalk, self.CloseUIGuideHeadTalkSignal)
end

function UIHeadTalkView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshUIHeadTalk, self.RefreshUIHeadTalkSignal)
    self:RemoveUIListener(EventId.CloseUIGuideHeadTalk, self.CloseUIGuideHeadTalkSignal)
end

function UIHeadTalkView:Refresh()
    self:DeleteNextTimer()
    self:DeleteDelayCloseTimer()
    if self.param[self.useIndex] == nil then
        self:DoCloseAnim()
    else
        self.des_text:SetText(self.param[self.useIndex].dialog)
        local animName = "UIGuideTipShow"..self.param[self.useIndex].modelPosition
        self.anim:Play(animName,0,0)
        self:LoadSpine(self.param[self.useIndex].modelName)
        self:AddNextTimer(self.param[self.useIndex].time)
    end
end

function UIHeadTalkView:LoadSpine(modelName)
    if self.lastModelName ~= modelName then
        if self.spine[modelName] == nil then
            self:GameObjectInstantiateAsync(string.format(LoadPath.GuideTipSpine, modelName), function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.spine_bg.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
                self.spine[modelName] = go
                self:HideLastModel(modelName)
            end)
        else
            self.spine[modelName]:SetActive(true)
            self:HideLastModel(modelName)
        end
    end
end

function UIHeadTalkView:HideLastModel(modelName)
    if self.lastModelName ~= nil and self.spine[self.lastModelName] ~= nil then
        self.spine[self.lastModelName]:SetActive(false)
    end
    self.lastModelName = modelName
end

function UIHeadTalkView:AddDelayCloseTimer(time)
    self:DeleteDelayCloseTimer()
    self.delayCloseTimer = TimerManager:GetInstance():GetTimer(time, self.timer_action , self, true,false,false)
    self.delayCloseTimer:Start()
end

function UIHeadTalkView:TimerAction()
    self:DeleteDelayCloseTimer()
    self.ctrl:CloseSelf()
end

function UIHeadTalkView:DeleteDelayCloseTimer()
    if self.delayCloseTimer then
        self.delayCloseTimer:Stop()
        self.delayCloseTimer = nil
    end
end

function UIHeadTalkView:DoCloseAnim()
    self:DeleteNextTimer()
    if self.useIndex > 1 then
        local ret,time = self.anim:PlayAnimationReturnTime("UIGuideTipHide".. self.param[self.useIndex - 1].modelPosition)
        if ret and time > 0 then
            self:AddDelayCloseTimer(time)
        else
            self:TimerAction()
        end
    else
        self:TimerAction()
    end
end

function UIHeadTalkView:RefreshUIHeadTalkSignal(param)
    self.param = param
    self.useIndex = 1
    self:Refresh()
end

function UIHeadTalkView:AddNextTimer(time)
    self:DeleteNextTimer()
    self.nextTimer = TimerManager:GetInstance():GetTimer(time, self.next_timer_callback , self, true, false,false)
    self.nextTimer:Start()
end

function UIHeadTalkView:NextTimerCallBack()
    self:DeleteNextTimer()
    self.useIndex = self.useIndex + 1
    self:Refresh()
end

function UIHeadTalkView:DeleteNextTimer()
    if self.nextTimer then
        self.nextTimer:Stop()
        self.nextTimer = nil
    end
end

function UIHeadTalkView:CloseUIGuideHeadTalkSignal()
    self:DoCloseAnim()
end

return UIHeadTalkView