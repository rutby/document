---
---MemberUnit 小队成员基类，有HeroUnit和WorkerUnit两个子类
---
local base = require("Scene.LWBattle.ParkourBattle.ParkourUnit")
---@class Scene.LWBattle.ParkourBattle.Team.MemberUnit : Scene.LWBattle.ParkourBattle.ParkourUnit
local MemberUnit = BaseClass("MemberUnit",base)


local FSM=require("Framework.Common.FSM")
--跑酷阶段，左右移动状态，玩家可以操作左右移动
local MoveStateLeftRight=require("Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateLeftRight")
--boss阶段，万向移动状态，玩家可以操作摇杆移动
local MoveStateAllDirection=require("Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateAllDirection")
--退场阶段，自动移动状态，玩家不可以操作移动（路径点模式）
local MoveStateAuto=require("Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateAuto")
--boss站立攻击阶段，玩家不可操作移动
local StayState = require("Scene.LWBattle.ParkourBattle.Team.FSM.StayState")
local Const = require("Scene.LWBattle.Const")
local ColliderComponent = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")


function MemberUnit:Init(logic,team,parent,localPos)
    base.Init(self,logic)
    self.team = team
    self.parent = parent
    self.guid = logic:AllotUnitGuid()
    self.logic = logic
    self.anim=nil
    self.localPosition = localPos
    self.invincible = false
    self.initUnit = false --初始上阵单位标识
end


function MemberUnit:InitFSM()
    self.moveFsm = FSM.New()--运动状态机
    self.moveFsm:AddState(Const.ParkourMoveState.Auto,MoveStateAuto.New(self))
    self.moveFsm:AddState(Const.ParkourMoveState.LeftRight,MoveStateLeftRight.New(self))
    self.moveFsm:AddState(Const.ParkourMoveState.AllDirection,MoveStateAllDirection.New(self))
    self.moveFsm:AddState(Const.ParkourMoveState.BossStay, StayState.New(self))
    self:ChangeStage(self.logic.state)
end

function MemberUnit:OnUpdate()
    base.OnUpdate(self)
    if self.moveFsm then
        self.moveFsm:OnUpdate()
    end
end

function MemberUnit:SetLocalPosition(pos)--luaVec3
    self.localPosition = pos
    if self.transform then
        self.transform:DOKill()
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
    end
end

function MemberUnit:SetPosition(worldPos)
    if not IsNull(self.transform) then
        self.transform:DOKill()
        self.transform.position = worldPos
    end
end

function MemberUnit:MoveToLocalPos(dstLocalPos, time)
    if time < 0 then
        self:SetLocalPosition(dstLocalPos)
    else
        self.transform:DOLocalMove(dstLocalPos, time)
    end
end

function MemberUnit:GetPosition()
    if self.transform then
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()
        return self.curWorldPos
    else
        return self.team:GetPosition()+self.localPosition
    end
end

function MemberUnit:GetMoveVelocity()
    return Vector3.zero
end

function MemberUnit:DestroyView()
    base.DestroyView(self)
    if self.moveFsm then
        self.moveFsm:Delete()
        self.moveFsm = nil
    end
    if self.req then
        self.req:Destroy()
        self.req = nil
        self.gameObject = nil
        self.transform = nil
    end
end

function MemberUnit:DestroyData()
    self.logic = nil
    self.appearanceMeta = nil
    base.DestroyData(self)
end



function MemberUnit:Rotate(degree)
    self.transform:Rotate(Vector3.up,degree)
end

function MemberUnit:ShowBornEffect()
    self.team.logic:ShowEffectObj(
        Const.ParkourAddMemberEffectPath,Vector3.zero,nil,1,self.transform
    ) 
end

function MemberUnit:IsMoving()
    if self.moveFsm and self.moveFsm:GetStateIndex()==Const.ParkourMoveState.BossStay then
        return false
    elseif self.moveFsm and self.moveFsm:GetStateIndex()==Const.ParkourMoveState.AllDirection then
        return self.fingerDown
    elseif self.moveFsm and self.moveFsm:GetStateIndex()==Const.ParkourMoveState.LeftRight then
        if self.logic.battleType == Const.ParkourBattleType.Defense then
            return self.logic.fingerDown
        else
            return true
        end
    else
        return true
    end
end

function MemberUnit:InitColliderComponent(layerMask,OnCollision)
    if self.transform and not self.colliderComponent then
        self.colliderComponent = ColliderComponent.New()
        local result = self.colliderComponent:InitCollider(self.transform, 10, layerMask)
        if not result then
            Logger.LogError("该单位根节点上缺少碰撞盒:"..self.gameObject.name)
        end
        self.colliderComponent:SetOnCollide(OnCollision)
    end
end

function MemberUnit:GetMoveSpeed()
    return 999
end



function MemberUnit:ChangeStage(stage)
    if stage == Const.ParkourBattleState.Boss then
        if self.moveFsm then
            self.moveFsm:ChangeState(Const.ParkourMoveState.AllDirection)
        end
    elseif stage == Const.ParkourBattleState.BossStay then
        if self.moveFsm then
            self.moveFsm:ChangeState(Const.ParkourMoveState.BossStay)
        end
    elseif stage == Const.ParkourBattleState.BossHorizontal then
        if self.moveFsm then
            self.moveFsm:ChangeState(Const.ParkourMoveState.LeftRight)
        end
    elseif stage == Const.ParkourBattleState.PreExit then

    elseif stage == Const.ParkourBattleState.Exit then
        if self.moveFsm then
            self.moveFsm:ChangeState(Const.ParkourMoveState.Auto)
        end
        if self.transform then
            self.logic:ShowEffectObj("Assets/_Art/Effect_B/Prefab/Common/Eff_duiwujiasu.prefab",
                    nil,Quaternion.identity,-1,self.transform)
        end
    elseif stage == Const.ParkourBattleState.Farm then
        if self.moveFsm then
            self.moveFsm:ChangeState(Const.ParkourMoveState.LeftRight)
        end
    end
    
end


function MemberUnit:OnFingerHold(targetPos)--luaVec3
    if self.moveFsm then
        self.moveFsm:ChangeState(Const.ParkourMoveState.AllDirection,targetPos)
    end
end

function MemberUnit:OnFingerDown(pos)
    self.soundUid = DataCenter.LWSoundManager:PlaySoundByAssetName(self.appearanceMeta.walk_sound,true)
    self.fingerDown=true
end

function MemberUnit:OnFingerUp()
    DataCenter.LWSoundManager:StopSound(self.soundUid)
    self.fingerDown=false
end

function MemberUnit:SetInitUnit()
    self.initUnit = true
end

return MemberUnit
