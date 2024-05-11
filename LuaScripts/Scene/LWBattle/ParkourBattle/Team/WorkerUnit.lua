---
---WorkerUnit 工人，继承自MemberUnit
---
local base = require("Scene.LWBattle.ParkourBattle.Team.MemberUnit")
---@class Scene.LWBattle.ParkourBattle.Team.WorkerUnit
local WorkerUnit = BaseClass("WorkerUnit",base)


local Resource = CS.GameEntry.Resource
local FSM=require("Framework.Common.FSM")
--不开火状态
local FireStateHold = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateHold")
local Const = require("Scene.LWBattle.Const")


function WorkerUnit:Init(logic,team,parent,pos,meta)
    base.Init(self,logic,team,parent,pos)
    self.type = Const.ParkourUnitType.Worker
    self.meta = meta
    self.unitType = UnitType.Plot
    local appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(meta.appearance)
    self.appearanceMeta = appearanceMeta
    local path = appearanceMeta.model_path
    self.invincible = true--工人是无敌的
    
    self.req = Resource:InstantiateAsync(path)
    self.req:completed('+', function(request)
        self.gameObject = request.gameObject
        self.gameObject.name = "Worker"..self.guid
        self.transform = request.gameObject.transform
        self.transform:SetParent(self.parent)
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
        self:ComponentDefine()
        self:InitFSM()
        self.transform:Set_localScale(appearanceMeta.model_size,appearanceMeta.model_size,appearanceMeta.model_size)
        self.angular_speed_deg=240
        self:ShowBornEffect()
        if self.isExiting then
            self:StartExiting()
        end
    end)
end


function WorkerUnit:ComponentDefine()
    --base.ComponentDefine(self)
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
end

function WorkerUnit:InitFSM()
    --攻击状态机
    self.fsm = FSM.New()
    self.fsm:AddState(Const.ParkourFireState.HoldFire,FireStateHold.New(self))
    self.fsm:ChangeState(Const.ParkourFireState.HoldFire)
    --运动状态机
    base.InitFSM(self)
end

function WorkerUnit:OnUpdate()
    base.OnUpdate(self)
    --if self.fsm then
    --    self.fsm:OnUpdate()
    --end
end


function WorkerUnit:DestroyView()
    base.DestroyView(self)
    --if self.fsm then
    --    self.fsm:Delete()
    --    self.fsm = nil
    --end
end

function WorkerUnit:DestroyData()
    base.DestroyData(self)
end

function WorkerUnit:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
end
function WorkerUnit:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
end

function WorkerUnit:GetRawProperty(type)
    return 0
end


function WorkerUnit:SetInvincible(bool)--无敌状态不可改变
end

function WorkerUnit:OnFingerDown(pos)
    base.OnFingerDown(self)
    if self:GetState(AnimName.Run) then
        self:PlaySimpleAnim(AnimName.Run)
    elseif self:GetState(AnimName.Walk) then
        self:PlaySimpleAnim(AnimName.Walk)
    end
end

function WorkerUnit:OnFingerUp()
    base.OnFingerUp(self)
    if self:GetState(AnimName.Idle) then
        self:PlaySimpleAnim(AnimName.Idle)
    end
end

return WorkerUnit
