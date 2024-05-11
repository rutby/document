--- Created by shimin.
--- DateTime: 2022/5/23 16:17
--- 黑屏过渡动画

local UIBlackChangeMaskView = BaseClass("UIBlackChangeMaskView", UIBaseView)
local base = UIBaseView

local anim_path = "V_ui_longzi_mask_anim"

local AnimName = "V_ui_longzi_mask_anim"

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
    self.anim = self:AddComponent(UIAnimator, anim_path)
end

local function ComponentDestroy(self)
    self.anim = nil
end


local function DataDefine(self)
    self.animator_timer = nil
    self.animator_timer_action = function(temp)
        self:AnimatorTime()
    end
end

local function DataDestroy(self)
    self:DeleteTimer()
    self.animator_timer = nil
    self.animator_timer_action = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local ret,time = self.anim:GetAnimationReturnTime(AnimName)
    if ret then
        self:AddTimer(time)
    else
        self:AnimatorTime()
    end
end

local function DeleteTimer(self)
    if self.animator_timer ~= nil then
        self.animator_timer:Stop()
        self.animator_timer = nil
    end
end

local function AddTimer(self,time)
    if self.animator_timer == nil then
        self.animator_timer = TimerManager:GetInstance():GetTimer(time, self.animator_timer_action , self, true,false,false)
    end
    self.animator_timer:Start()
end

local function AnimatorTime(self)
    self:DeleteTimer()
    self.ctrl:CloseSelf()
    local guideType = DataCenter.GuideManager:GetGuideType()
    if guideType == GuideType.ShowUIBlackChangeMask then
        DataCenter.GuideManager:DoNext()
    end
end

UIBlackChangeMaskView.OnCreate = OnCreate
UIBlackChangeMaskView.OnDestroy = OnDestroy
UIBlackChangeMaskView.OnEnable = OnEnable
UIBlackChangeMaskView.OnDisable = OnDisable
UIBlackChangeMaskView.ComponentDefine = ComponentDefine
UIBlackChangeMaskView.ComponentDestroy = ComponentDestroy
UIBlackChangeMaskView.DataDefine = DataDefine
UIBlackChangeMaskView.DataDestroy = DataDestroy
UIBlackChangeMaskView.OnAddListener = OnAddListener
UIBlackChangeMaskView.OnRemoveListener = OnRemoveListener
UIBlackChangeMaskView.ReInit = ReInit
UIBlackChangeMaskView.DeleteTimer = DeleteTimer
UIBlackChangeMaskView.AddTimer = AddTimer
UIBlackChangeMaskView.AnimatorTime = AnimatorTime

return UIBlackChangeMaskView