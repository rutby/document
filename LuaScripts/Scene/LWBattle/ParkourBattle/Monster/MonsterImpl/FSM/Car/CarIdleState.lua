---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wsf.
--- DateTime: 2024/1/16 7:23 PM
--- 卡车怪初始状态
---

---@class Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.Car.CarIdleState
local CarIdleState = BaseClass("CarIdleState")
local Time = Time
local CHECK_TARGET_IN_RANGE_CD = 0.5--检查目标是否在射程内cd

local ZombieCommonAI = require "Scene.LWBattle.AI.ZombieCommonAI"

function CarIdleState:__init(unit)
    self.unit = unit

    self.ai=ZombieCommonAI.New(self.unit)---@type Scene.LWBattle.AI.ZombieCommonAI
end

function CarIdleState:__delete()
    self.unit = nil
    if self.timer then
        self.timer:Stop()
        self.timer=nil
    end

end

function CarIdleState:OnEnter()
    --self.zombie:RemoveDestination()
    local pos = self.unit:GetPosition()
    self.unit.agent:SetCurPosition(pos.x,pos.z)
    self.unit:PlaySimpleAnim(ZombieAnim.Run,1)
    local curPos = self.unit:GetPosition()
    local posZ = self.unit.logic.team:GetPositionZ()
    self.unit:SetDestination(curPos.x, posZ - 100)

    if (not self.unit.IsImprisoning) or (not self.unit:IsImprisoning()) then
        self.unit.agent.speed = self.unit.meta.move_speed * (1 + self.unit:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
    end

end
function CarIdleState:OnExit()
    self.unit:RemoveDestination()

end

function CarIdleState:OnUpdate()

    self:CheckCastSkill()
end

function CarIdleState:CheckCastSkill()
    if self.unit.skillManager:GetCastingSkill() then    --施法阶段
        return
    end

    local skill=self.unit.skillManager:GetActiveSkill()
    if skill then
        if skill:IsBuffSkill() then
            --buff型技能，不用瞄准、目标是个table
            self.unit.skillManager:ActiveCast(skill,skill:SearchTarget())
        else
            local target = self:GetTarget(skill)
            if target then
                self.unit.skillManager:ActiveCast(skill,target)
            end
        end
    end
end

return CarIdleState