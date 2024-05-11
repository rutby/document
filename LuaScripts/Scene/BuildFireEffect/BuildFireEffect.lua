---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/30 19:31
---
local BuildFireEffect = BaseClass("BuildFireEffect")
local HeightPositionDelta =  Vector3.New(0,1,0)

--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:DeleteTimer()
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.isDoAnim = false
    self.timer_action = function() self:Update() end
    self:AddTimer()
end

local function ComponentDestroy(self)
    self.gameObject = nil
    self.transform = nil
end


local function DataDefine(self)
    self.param = nil
    self.curPosition = nil
end

local function DataDestroy(self)
    self.param = nil
    self.curPosition = nil
end

local function ReInit(self,param)
    self.param = param
    self.endTime = self.param.endTime
    self:ShowPanel()
    self.isDoAnim = true
end

local function ShowPanel(self)
    self.gameObject.transform.position = BuildingUtils.GetBuildModelCenterVec(self.param.posIndex, self.param.tiles) + Vector3.New(0,self.param.modelHeight,0) + HeightPositionDelta
end

local function OnUpdateTime(self,endTime)
    self.endTime = endTime
    self.isDoAnim = true
end

local function Update(self)
    if self.isDoAnim then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        if curTime >self.endTime then
            self.isDoAnim = false
            BuildFireEffectManager:GetInstance():RemoveOneEffect(self.param.bUuid)
        end
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

BuildFireEffect.OnCreate = OnCreate
BuildFireEffect.OnDestroy = OnDestroy
BuildFireEffect.ComponentDefine = ComponentDefine
BuildFireEffect.ComponentDestroy = ComponentDestroy
BuildFireEffect.DataDefine = DataDefine
BuildFireEffect.DataDestroy = DataDestroy
BuildFireEffect.ReInit = ReInit
BuildFireEffect.ShowPanel = ShowPanel
BuildFireEffect.OnUpdateTime =OnUpdateTime
BuildFireEffect.Update =Update
BuildFireEffect.DeleteTimer =DeleteTimer
BuildFireEffect.AddTimer = AddTimer
return BuildFireEffect