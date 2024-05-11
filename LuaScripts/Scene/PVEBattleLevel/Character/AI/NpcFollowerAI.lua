---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ycheng.
--- DateTime: 2022/12/6 15:35
---
local NpcBaseAI = require("Scene.PVEBattleLevel.Character.AI.NpcBaseAI")
local NpcFollowerAI = BaseClass("NpcFollowerAI",NpcBaseAI)
local Util = require("Scene.PVEBattleLevel.Utils.SU_Util")
local CharacterStateType = require("Scene.PVEBattleLevel.Character.State.CharacterStateType")

local StateType = {
    FollowState = "FollowState",
    MoveState = "MoveState",
    AttackState = "AttackState"
}

local targetPosition = {}

function NpcFollowerAI:__initState()
    self.m_states:AddState(StateType.FollowState,self.Follow_Enter,self.Follow_Update,self.Follow_Exit)
    self.m_states:AddState(StateType.MoveState,nil,self.Move_Update,nil)
    self.m_states:AddState(StateType.AttackState,self.Attack_Enter,nil,nil)
end

function NpcFollowerAI:Start()
    NpcBaseAI.Start(self)
    
    self.chaseRadius = self.m_owner:GetChaseRadius()
    self.attackRadius = self.m_owner:GetAttackRange()
    self.m_states:SetState(StateType.FollowState)

    --正常应该在AI结束后调用，但是此AI没有结束时机，而外部需要统一处理，所以启动的时候调用
    self:TriggerCallBack()
end

function NpcFollowerAI:Follow_Enter()
    self.m_target = DataCenter.BattleLevel:GetPlayer()
    self.m_checkTime = 0
    self.m_isMoving = false
end

function NpcFollowerAI:Follow_Update(deltaTime)
    self.m_checkTime = self.m_checkTime + deltaTime
    if self.m_checkTime  < 0.5 then
        return
    end
    self.m_checkTime = 0
    if self.m_target ~= nil then
        local targetPos = self.m_target:GetPosition()
        local pos = Util.GenerateConcentricPosition(targetPos,2,1,targetPosition)
        local dis = Vector3.Distance(self.m_owner:GetPosition(),targetPos)
        if dis > 2 or dis < 1 then
            self.m_isMoving = true
            self.m_owner:MovePath(pos)
        elseif self.m_isMoving then
            self.m_isMoving = false
            self.m_owner:Idle()
        end

        if dis < 3 then
            --在距离玩家小于3米范围内，开启保护模式，攻击周围怪物
            self.m_enemy = self.m_owner.battleLevel.RoleMgr:SearchEnemyTarget(self.m_owner:GetPosition(),self.chaseRadius,self.m_owner:GetType())
            if self.m_enemy ~= nil then
                self.m_states:SetState(StateType.MoveState)
            end
        end
    end
end

function NpcFollowerAI:Follow_Exit()
    self.m_target = nil
end

function NpcFollowerAI:Move_Update(deltaTime)
    if self.m_enemy and self.m_enemy:GetCurBlood() > 0 then
        local dis = Vector3.Distance(self.m_owner:GetPosition(),self.m_enemy:GetPosition()) - self.m_enemy:GetModelRadius()
        if dis <= self.attackRadius then
            self.m_states:SetState(StateType.AttackState)
        else
            self.m_owner:MovePath(self.m_enemy:GetPosition())
        end
    else
        self.m_states:SetState(StateType.FollowState)
    end
end

function NpcFollowerAI:Attack_Enter()
    if self.m_enemy and self.m_enemy:GetCurBlood() > 0 then
        self.m_owner:Attack(self.m_enemy)
    else
        self.m_states:SetState(StateType.FollowState)
    end
    self.m_owner:StopAttack() --取消循环攻击，变成单次攻击，支持不同攻击动画
end

function NpcFollowerAI:OnStateComplete(type,data)
    if type == CharacterStateType.Attack then
        self.m_states:SetState(StateType.MoveState)
    end
end

function NpcFollowerAI:Destroy()
    NpcBaseAI.Destroy(self)
    self.m_target = nil
    self.m_enemy = nil
end

return NpcFollowerAI