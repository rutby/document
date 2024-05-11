---
--- Skirmish玩法单位基类。Captain、Minion的基类
---
local base = require("Scene.LWBattle.UnitBase")
---@class Scene.LWBattle.Skirmish.Unit.SkirmishUnit : Scene.LWBattle.UnitBase
local SkirmishUnit = BaseClass("SkirmishUnit",base)
local FSM=require("Framework.Common.FSM")
--运动状态之路径点移动
local MoveStatePath=require("Scene.LWBattle.Skirmish.UnitFSM.MoveStatePath")
--运动状态之不动
local MoveStateStay=require("Scene.LWBattle.Skirmish.UnitFSM.MoveStateStay")
--攻击状态之瞄准(英雄专用）
local FireStateAim=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateAim")
--攻击状态之施法(英雄专用）
local FireStateCasting=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateCasting")
--攻击状态之发呆
local FireStateIdle=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateIdle")
--攻击状态之自动开火(小兵专用）
local FireStateAuto=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateAuto")
--攻击状态之死亡
local FireStateDie=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateDie")


function SkirmishUnit:Init(logic,platoon,heroData,localPos,index)
    base.Init(self,logic)
    self.logic = logic
    self.sceneData = self.logic.sceneData
    self.battleData = self.logic.battleData
    self.platoon = platoon
    self.heroData = heroData
    self.guid = self.logic:AllotUnitGuid()
    self.curPos = Vector3.zero
    self.dirMultiplier = self.platoon.dirMultiplier
    self:SetLocalPosition(localPos)
    self.index = index
end



function SkirmishUnit:InitFSM()
    --攻击状态机
    self.fsm = FSM.New()
    self.fsm:AddState(SkirmishFireState.Idle,FireStateIdle.New(self))
    self.fsm:AddState(SkirmishFireState.Die,FireStateDie.New(self))
    self.fsm:ChangeState(SkirmishFireState.Idle)
    --运动状态机
    self.moveFsm = FSM.New()
    self.moveFsm:AddState(SkirmishMoveState.Path,MoveStatePath.New(self))
    self.moveFsm:AddState(SkirmishMoveState.Stay,MoveStateStay.New(self))
    self.moveFsm:ChangeState(SkirmishMoveState.Stay)
end

function SkirmishUnit:OnUpdate()
    base.OnUpdate(self)
    if self.moveFsm then
        self.moveFsm:OnUpdate()
    end
    if self.fsm then
        self.fsm:OnUpdate()
    end
end

function SkirmishUnit:DestroyView()
    base.DestroyView(self)
    if self.moveFsm then
        self.moveFsm:Delete()
        self.moveFsm = nil
    end
    if self.fsm then
        self.fsm:Delete()
        self.fsm = nil
    end
    if self.req then
        self.req:Destroy()
        self.req = nil
        self.gameObject = nil
        self.transform = nil
    end
    self.firePoint=nil
    self.anim=nil
end

function SkirmishUnit:DestroyData()
    self.sceneData = nil
    self.battleData = nil
    self.logic = nil
    self.platoon = nil
    self.heroData = nil
    self.localPosition = nil
    base.DestroyData(self)
end

function SkirmishUnit:ComponentDefine()
    base.ComponentDefine(self)
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
end

function SkirmishUnit:SetLocalPosition(localPos)
    self.localPosition = localPos
    if self.transform then
        self.transform:Set_localPosition(localPos.x,localPos.y,localPos.z)
    end
end

function SkirmishUnit:GetPosition()
    if self.transform then
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()
        return self.curWorldPos
    else
        return self.platoon:GetPosition() + self.localPosition * self.dirMultiplier
    end
end

function SkirmishUnit:Rotate(degree)
    self.transform:Rotate(Vector3.up,degree)
end

function SkirmishUnit:IsMoving()
    return self.moveFsm and self.moveFsm:GetStateIndex()==SkirmishMoveState.Path
end

function SkirmishUnit:GetMoveVelocity()
    if self:IsMoving() then
        return self.platoon:GetMoveVelocity()
    else
        return Vector3.zero
    end
end

function SkirmishUnit:GetFirePoint()
    return self.firePoint
end
--function SkirmishUnit:GetMoveSpeed()
--    return 99
--end


function SkirmishUnit:ChangeStage(stage)
    if stage == SkirmishStage.Load then

    elseif stage == SkirmishStage.Opening then
        if self.moveFsm then
            self.moveFsm:ChangeState(SkirmishMoveState.Path)
        end
    elseif stage == SkirmishStage.Fight then
        
    elseif stage == SkirmishStage.End then
        if self.fsm and self.fsm:GetStateIndex()~=SkirmishFireState.Die then
            self.fsm:ChangeState(SkirmishFireState.Idle)
        end
    end
end

function SkirmishUnit:GoDie()
    self.curBlood=0
    self.fsm:ChangeState(SkirmishFireState.Die)
    self.moveFsm:ChangeState(SkirmishMoveState.Stay)

    if self.heroEffectMeta then
        local effectMeta=self.heroEffectMeta
        --死亡特效
        self.logic:ShowEffectObj(effectMeta.death_effect_nomal,self:GetPosition(),nil,nil)

        --死亡血渍
        local bloodEffect = effectMeta:GetRandomBlood()
        if bloodEffect then
            self.logic:ShowEffectObj(bloodEffect,self:GetPosition(),nil,-1,nil,EffectObjType.Sprite)
        end
        --死亡震屏
        if effectMeta.deathShakeParam then
            self.logic:ShakeCameraWithParam(effectMeta.deathShakeParam)
        end
    end
end

function SkirmishUnit:Revive()
    self:ShowOrHide(true)
    self.curBlood = self.bloodBeforeDie or self.maxBlood
    self.fsm:ChangeState(SkirmishFireState.Idle)
    self.moveFsm:ChangeState(SkirmishMoveState.Stay)
end

function SkirmishUnit:StopMoving()
    if self.moveFsm then
        self.moveFsm:ChangeState(SkirmishMoveState.Stay)
    end
end

function SkirmishUnit:OnBuffAdded(buff)
    
end

function SkirmishUnit:OnBuffRemoved(buff)
    
end


return SkirmishUnit