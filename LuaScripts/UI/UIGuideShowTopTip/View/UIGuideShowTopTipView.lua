--- Created by shimin.
--- DateTime: 2023/11/27 20:35
--- 引导顶部提示界面

local UIGuideShowTopTipView = BaseClass("UIGuideShowTopTipView",UIBaseView)
local base = UIBaseView

local des_text_path = "bg_go/des_text"

--创建
function UIGuideShowTopTipView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIGuideShowTopTipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UIGuideShowTopTipView:ComponentDefine()
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
end

function UIGuideShowTopTipView:ComponentDestroy()
end

function UIGuideShowTopTipView:DataDefine()
    self.auto_to_do_next_timer_action = function()
        self:AutoDoNextTimerAction()
    end
end

function UIGuideShowTopTipView:DataDestroy()
    self:DeleteAutoDoNextTimer()
end

function UIGuideShowTopTipView:OnEnable()
    base.OnEnable(self)
    self:ReInit()
end

function UIGuideShowTopTipView:OnDisable()
    base.OnDisable(self)
end

function UIGuideShowTopTipView:ReInit()
    self.param = self:GetUserData()
    self:Refresh()
end

function UIGuideShowTopTipView:OnAddListener()
    base.OnAddListener(self)
    --self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideShowTopTipView:OnRemoveListener()
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIGuideShowTopTipView:AddAutoDoNextTimer(time)
    self:DeleteAutoDoNextTimer()
    self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_to_do_next_timer_action , self, true,false,false)
    self.autoDoNextTimer:Start()
end

function UIGuideShowTopTipView:AutoDoNextTimerAction()
    self:DeleteAutoDoNextTimer()
    self.ctrl:CloseSelf()
end

function UIGuideShowTopTipView:DeleteAutoDoNextTimer()
    if self.autoDoNextTimer then
        self.autoDoNextTimer:Stop()
        self.autoDoNextTimer = nil
    end
end

function UIGuideShowTopTipView:Refresh()
    self:DeleteAutoDoNextTimer()
    self:AddAutoDoNextTimer(self.param.time)
    self.des_text:SetText(self.param.des)
end

function UIGuideShowTopTipView:RefreshGuideAnimSignal()
end

return UIGuideShowTopTipView