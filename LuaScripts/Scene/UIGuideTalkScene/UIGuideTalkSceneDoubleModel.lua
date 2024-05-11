--- Created by shimin.
--- DateTime: 2021/9/14 18:40
--- 引导对话MPC场景模型

local UIGuideTalkSceneDoubleModel = BaseClass("UIGuideTalkSceneDoubleModel")

--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.simpleAnim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation))
end

local function ComponentDestroy(self)
    self.simpleAnim = nil
    self.gameObject = nil
    self.transform = nil
end


local function DataDefine(self)
    self.param = nil
    self.timer = nil
    self.timer_action = function(temp) 
        self:TimerAction()
    end
end

local function DataDestroy(self)
    self:DeleteTimer()
    self.timer = nil
    self.param = nil
    self.timer_action = nil
end

local function ReInit(self,param)
    self.param = param
    self:ShowPanel()
end

local function ShowPanel(self)
    if self.simpleAnim ~= nil then
        if self.timer == nil then
            local time = self.simpleAnim:GetClipLength(self.param.modelAction)
            if time > 0 then
                self:AddTimer(time)
                self.simpleAnim:Play(self.param.modelAction)
            end
        end
    end
end

local function Stop(self)
    self:DeleteTimer()
    if self.simpleAnim ~= nil then
        self.simpleAnim:Stop()
    end
end

local function AddTimer(self,time)
    self:DeleteTimer()
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action , self, true,false,false)
    self.timer:Start()
end

local function TimerAction(self)
    self:DeleteTimer()
    self:Stop()
end

local function DeleteTimer(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

UIGuideTalkSceneDoubleModel.OnCreate = OnCreate
UIGuideTalkSceneDoubleModel.OnDestroy = OnDestroy
UIGuideTalkSceneDoubleModel.ComponentDefine = ComponentDefine
UIGuideTalkSceneDoubleModel.ComponentDestroy = ComponentDestroy
UIGuideTalkSceneDoubleModel.DataDefine = DataDefine
UIGuideTalkSceneDoubleModel.DataDestroy = DataDestroy
UIGuideTalkSceneDoubleModel.ReInit = ReInit
UIGuideTalkSceneDoubleModel.ShowPanel = ShowPanel
UIGuideTalkSceneDoubleModel.Stop = Stop
UIGuideTalkSceneDoubleModel.AddTimer = AddTimer
UIGuideTalkSceneDoubleModel.TimerAction = TimerAction
UIGuideTalkSceneDoubleModel.DeleteTimer = DeleteTimer

return UIGuideTalkSceneDoubleModel