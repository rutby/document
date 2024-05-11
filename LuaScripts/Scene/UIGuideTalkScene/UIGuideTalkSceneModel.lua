--- Created by shimin.
--- DateTime: 2021/9/14 18:40
--- 引导对话MPC场景模型

local UIGuideTalkSceneModel = BaseClass("UIGuideTalkSceneModel")
local IdleName = "Default"

--创建
function UIGuideTalkSceneModel:OnCreate(go)
    if go ~= nil then
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIGuideTalkSceneModel:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function UIGuideTalkSceneModel:ComponentDefine()
    self.simpleAnim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
end

function UIGuideTalkSceneModel:ComponentDestroy()
    self.simpleAnim = nil
    self.gameObject = nil
    self.transform = nil
end


function UIGuideTalkSceneModel:DataDefine()
    self.param = nil
    self.idle_timer_action = function()
        self:IdleTimerCallBack()
    end
    self.animName = ""
end

function UIGuideTalkSceneModel:DataDestroy()
    self:DeleteIdleTimer()
    self.param = nil
    self.idle_timer_action = nil
    self.animName = ""
end

function UIGuideTalkSceneModel:ReInit(param)
    self.param = param
    if self.param.modelAction ~= self.animName or self.idleTimer == nil then
        local time = self:GetClipTime(self.param.modelAction)
        if time > 0 then
            self:DeleteIdleTimer()
            self:AddIdleTimer(time)
            self:PlayAnimation(self.param.modelAction)
            self.animName = self.param.modelAction
        end
    end
end

function UIGuideTalkSceneModel:PlayAnimation(animName)
    if self.simpleAnim ~= nil then
        self.simpleAnim:Play(animName)
    end
end

function UIGuideTalkSceneModel:AddIdleTimer(time)
    self:DeleteIdleTimer()
    self.idleTimer = TimerManager:GetInstance():GetTimer(time, self.idle_timer_action , self, true,false,false)
    self.idleTimer:Start()
end

function UIGuideTalkSceneModel:IdleTimerCallBack()
    self:DeleteIdleTimer()
    local time = self:GetClipTime(IdleName)
    if time > 0 then
        self:PlayAnimation(IdleName)
    end
end

function UIGuideTalkSceneModel:DeleteIdleTimer()
    if self.idleTimer then
        self.idleTimer:Stop()
        self.idleTimer = nil
    end
end

function UIGuideTalkSceneModel:GetClipTime(animName)
    if self.simpleAnim ~= nil then
        return self.simpleAnim:GetClipLength(animName)
    end
    return 0
end

return UIGuideTalkSceneModel