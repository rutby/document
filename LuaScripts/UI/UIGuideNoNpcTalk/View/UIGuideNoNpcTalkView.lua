---
--- Created by shimin.
--- DateTime: 2022/6/20 21:54
--  引导旁白对话
---

local UIGuideNoNpcTalkView = BaseClass("UIGuideNoNpcTalkView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local panel_path = "GuideTalkBtn"
local des_text_path = "TalkBg/TalkDes"
local arrow_path = "TalkBg/TalkDes/ArrowGo"


function UIGuideNoNpcTalkView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit(self:GetUserData())
end

-- 销毁
function UIGuideNoNpcTalkView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGuideNoNpcTalkView:ComponentDefine()
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self:OnBtnClick()
    end)
end

function UIGuideNoNpcTalkView:ComponentDestroy()
    self.des_text = nil
    self.panel = nil
    self.arrow = nil
end


function UIGuideNoNpcTalkView:DataDefine()
    self.param = {}
    self.can_close_timer_action = function()
        self:CanCloseTimerAction()
    end
    self.auto_to_do_next_timer_action = function()
        self:AutoDoNextTimerAction()
    end
    self.canClose = false
end

function UIGuideNoNpcTalkView:DataDestroy()
    self.param = {}
    self:DeleteAutoDoNextTimer()
    self:DeleteCanCloseTimer()
    self.can_close_timer_action = nil
    self.auto_to_do_next_timer_action = nil
    self.canClose = false
end

function UIGuideNoNpcTalkView:OnEnable()
    base.OnEnable(self)
end

function UIGuideNoNpcTalkView:OnDisable()
    base.OnDisable(self)
end

function UIGuideNoNpcTalkView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

function UIGuideNoNpcTalkView:OnRemoveListener()
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    base.OnRemoveListener(self)
end

function UIGuideNoNpcTalkView:ReInit(param)
    self.param = param
    self.des_text:SetText(self.param.des)
    if self.param.autoNextTime == nil then
        self:DeleteAutoDoNextTimer()
    else
        self:AddAutoDoNextTimer(self.param.autoNextTime)
    end
    if self.param.canClickTime == nil then
        self:CanCloseTimerAction()
    else
        self:AddCanCloseTimer(self.param.canClickTime)
    end
end

function UIGuideNoNpcTalkView:AddAutoDoNextTimer(time)
    self:DeleteAutoDoNextTimer()
    self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_to_do_next_timer_action , self, true, false,false)
    self.autoDoNextTimer:Start()
end


function UIGuideNoNpcTalkView:AutoDoNextTimerAction()
    self.canClose = true
    self:DeleteAutoDoNextTimer()
    self:OnBtnClick()
end

function UIGuideNoNpcTalkView:DeleteAutoDoNextTimer()
    if self.autoDoNextTimer then
        self.autoDoNextTimer:Stop()
        self.autoDoNextTimer = nil
    end
end

function UIGuideNoNpcTalkView:AddCanCloseTimer(time)
    self.canClose = false
    self.arrow:SetActive(false)
    self:DeleteCanCloseTimer()
    self.canCloseTimer = TimerManager:GetInstance():GetTimer(time, self.can_close_timer_action , self, true,false,false)
    self.canCloseTimer:Start()
end


function UIGuideNoNpcTalkView:CanCloseTimerAction()
    self:DeleteCanCloseTimer()
    self.canClose = true
    self.arrow:SetActive(true)
end

function UIGuideNoNpcTalkView:DeleteCanCloseTimer()
    if self.canCloseTimer then
        self.canCloseTimer:Stop()
        self.canCloseTimer = nil
    end
end

function UIGuideNoNpcTalkView:RefreshGuideSignal()
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.type == GuideType.NoNpcTalk then
        local param = {}
        if template.para1 ~= nil and template.para1 ~= "" then
            param.autoNextTime = tonumber(template.para1) / 1000
        end
        if template.para2 ~= nil and template.para2 ~= "" then
            param.des = Localization:GetString(template.para2)
        end
        if template.para3 ~= nil and template.para3 ~= "" then
            param.canClickTime = tonumber(template.para3) / 1000
        end
        self:ReInit(param)
    else
        self.ctrl:CloseSelf()
    end
end

function UIGuideNoNpcTalkView:OnBtnClick()
    if self.canClose then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        if DataCenter.GuideManager:GetGuideType() == GuideType.NoNpcTalk then
            DataCenter.GuideManager:DoNext()
        end
    end
end

return UIGuideNoNpcTalkView