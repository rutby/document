---
--- 引导头像Tip对话界面
--- Created by shimin.
--- DateTime: 2021/11/10 14:27
---
local UIGuideHeadTalkView = BaseClass("UIGuideHeadTalkView",UIBaseView)
local base = UIBaseView

local this_path = ""
local des_text_path = "SpineBg/DesGo/Text_A28p"
local spine_bg_path = "SpineBg/SpineGo"
local des_go_path = "SpineBg/DesGo"

--创建
function UIGuideHeadTalkView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIGuideHeadTalkView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end
--控件定义
function UIGuideHeadTalkView:ComponentDefine()
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.spine_bg = self:AddComponent(UIBaseContainer, spine_bg_path)
    self.des_go = self:AddComponent(UIBaseContainer, des_go_path)
end
--控件销毁
function UIGuideHeadTalkView:ComponentDestroy()
    self.anim = nil
    self.des_text = nil
    self.spine_bg = nil
    self.des_go = nil
end
--数据定义
function UIGuideHeadTalkView:DataDefine()
    self.param = nil
    self.lastModelName = nil
    self.timer_action = function()
        self:TimerAction()
    end
    self.spine = {}
end
--数据销毁
function UIGuideHeadTalkView:DataDestroy()
    self:DeleteTimer()
    self.param = nil
    self.lastModelName = nil
    self.timer_action = nil
    self.spine = {}
end

function UIGuideHeadTalkView:OnEnable()
    base.OnEnable(self)
    self:ReInit()
end

function UIGuideHeadTalkView:OnDisable()
    base.OnDisable(self)
end

function UIGuideHeadTalkView:ReInit()
    self.param = self:GetUserData()
    self:Refresh()
    if self.param.isGuide then
        local template = DataCenter.GuideManager:GetCurTemplate()
        if template ~= nil and template.tipspic ~= nil and template.tipspic ~= "" then
            
        else
            self:DoCloseAnim()
            Logger.LogError("shimin ---------- UIGuideHeadTalkView open and close error")
        end
    end
end

function UIGuideHeadTalkView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:AddUIListener(EventId.RefreshUIGuideHeadTalk, self.RefreshUIGuideHeadTalkSignal)
end

function UIGuideHeadTalkView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:RemoveUIListener(EventId.RefreshUIGuideHeadTalk, self.RefreshUIGuideHeadTalkSignal)
end

function UIGuideHeadTalkView:Refresh()
    self:DeleteTimer()
    self.des_go:SetActive(true)
    self.des_text:SetText(self.param.dialog)
    local animName = "UIGuideTipShow"..self.param.modelPosition
    self.anim:Play(animName,0,0)
    self:LoadSpine()
end

function UIGuideHeadTalkView:RefreshGuideSignal()
    if self.param.isGuide then
        local template = DataCenter.GuideManager:GetCurTemplate()
        if template ~= nil and template.tipspic ~= nil and template.tipspic ~= "" then
            self.des_go:SetActive(false)
        else
            self:DoCloseAnim()
        end
    end
end

function UIGuideHeadTalkView:LoadSpine()
    if self.lastModelName ~= self.param.modelName then
        if self.spine[self.param.modelName] == nil then
            self:GameObjectInstantiateAsync(string.format(LoadPath.GuideTipSpine, self.param.modelName), function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.spine_bg.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
                self.spine[self.param.modelName] = go
                self:HideLastModel()
            end)
        else
            self.spine[self.param.modelName]:SetActive(true)
            self:HideLastModel()
        end
    end
end

function UIGuideHeadTalkView:HideLastModel()
    if self.lastModelName ~= nil and self.spine[self.lastModelName] ~= nil then
        self.spine[self.lastModelName]:SetActive(false)
    end
    self.lastModelName = self.param.modelName
end

function UIGuideHeadTalkView:AddDelayTimer(time)
    self:DeleteTimer()
    self.delayCloseTimer = TimerManager:GetInstance():GetTimer(time, self.timer_action , self, true,false,false)
    self.delayCloseTimer:Start()
end

function UIGuideHeadTalkView:TimerAction()
    self:DeleteTimer()
    self.ctrl:CloseSelf()
end

function UIGuideHeadTalkView:DeleteTimer()
    if self.delayCloseTimer then
        self.delayCloseTimer:Stop()
        self.delayCloseTimer = nil
    end
end

function UIGuideHeadTalkView:RefreshUIGuideHeadTalkSignal(param)
    self.param = param
    self:Refresh()
end

function UIGuideHeadTalkView:DoCloseAnim()
    local ret,time = self.anim:PlayAnimationReturnTime("UIGuideTipHide".. self.param.modelPosition)
    if ret and time > 0 then
        self:AddDelayTimer(time)
    else
        self:TimerAction()
    end
end

return UIGuideHeadTalkView