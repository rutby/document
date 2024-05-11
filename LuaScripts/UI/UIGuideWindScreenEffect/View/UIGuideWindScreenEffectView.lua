--- Created by shimin.
--- DateTime: 2024/3/7 17:27
--- 引导风沙

local UIGuideWindScreenEffectView = BaseClass("UIGuideWindScreenEffectView", UIBaseView)
local base = UIBaseView

local anim_path = "Eff_UI_ScreenWind/Ani"

local AnimName =
{
    Open = "Eff_Ani_ScreenWind_In",
    Loop = "Eff_Ani_ScreenWind_Loop",
    Close = "Eff_Ani_ScreenWind_Out",
}

function UIGuideWindScreenEffectView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIGuideWindScreenEffectView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGuideWindScreenEffectView:ComponentDefine()
    self.anim = self:AddComponent(UIAnimator, anim_path)
end

function UIGuideWindScreenEffectView:ComponentDestroy()
end

function UIGuideWindScreenEffectView:DataDefine()
    self.show_timer_callback = function() 
        self:OnShowTimerCallBack()
    end
    self.close_timer_callback = function() 
        self:OnCloseTimerCallBack()
    end
end

function UIGuideWindScreenEffectView:DataDestroy()
    self:RemoveShowAnimTime()
    self:RemoveCloseAnimTime()
end

function UIGuideWindScreenEffectView:OnEnable()
    base.OnEnable(self)
    if self.soundId ==nil then
        self.soundId = SoundUtil.PlayLoopEffect(SoundAssets.Music_Effect_Wind)
    end
end

function UIGuideWindScreenEffectView:OnDisable()
    if self.soundId~=nil then
        SoundUtil.StopSound(self.soundId)
        self.soundId = nil
    end
    
    base.OnDisable(self)
end

function UIGuideWindScreenEffectView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.CloseGuideWindEffect, self.CloseGuideWindEffectSignal)
    self:AddUIListener(EventId.OpenUI, self.RefreshSound)--打开UI
    self:AddUIListener(EventId.CloseUI, self.RefreshSound)
end

function UIGuideWindScreenEffectView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.CloseGuideWindEffect, self.CloseGuideWindEffectSignal)
    self:RemoveUIListener(EventId.OpenUI, self.RefreshSound)--打开UI
    self:RemoveUIListener(EventId.CloseUI, self.RefreshSound)
end

function UIGuideWindScreenEffectView:ReInit()
    local ret, time = self.anim:PlayAnimationReturnTime(AnimName.Open)
    if ret and time > 0 then
        self:AddShowAnimTimer(time)
    else
        self:OnShowTimerCallBack()
    end
end

function UIGuideWindScreenEffectView:RefreshSound()
    if SceneUtils.GetIsInCity()  then
        if UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true, {UIWindowNames.UIGuideTalk})  then
            if self.soundId ==nil then
                self.soundId = SoundUtil.PlayLoopEffect(SoundAssets.Music_Effect_Wind)
            end
        else
            if self.soundId~=nil then
                SoundUtil.StopSound(self.soundId)
                self.soundId = nil
            end
        end
    end
    
    
end
function UIGuideWindScreenEffectView:CloseGuideWindEffectSignal()
    local ret, time = self.anim:PlayAnimationReturnTime(AnimName.Close)
    if ret and time > 0 then
        self:AddCloseAnimTimer(time)
    else
        self:OnCloseTimerCallBack()
    end
end

function UIGuideWindScreenEffectView:AddShowAnimTimer(time)
    self:RemoveShowAnimTime()
    self.show_timer = TimerManager:GetInstance():GetTimer(time, self.show_timer_callback, nil, true, false, false)
    self.show_timer:Start()
end

function UIGuideWindScreenEffectView:RemoveShowAnimTime()
    if self.show_timer ~= nil then
        self.show_timer:Stop()
        self.show_timer = nil
    end
end

function UIGuideWindScreenEffectView:OnShowTimerCallBack()
    self:RemoveShowAnimTime()
    self.anim:PlayAnimationReturnTime(AnimName.Loop)
end


function UIGuideWindScreenEffectView:AddCloseAnimTimer(time)
    self:RemoveCloseAnimTime()
    self.close_timer = TimerManager:GetInstance():GetTimer(time, self.close_timer_callback, nil, true, false, false)
    self.close_timer:Start()
end

function UIGuideWindScreenEffectView:RemoveCloseAnimTime()
    if self.close_timer ~= nil then
        self.close_timer:Stop()
        self.close_timer = nil
    end
end

function UIGuideWindScreenEffectView:OnCloseTimerCallBack()
    self:RemoveCloseAnimTime()
    self.ctrl:CloseSelf()
end


return UIGuideWindScreenEffectView