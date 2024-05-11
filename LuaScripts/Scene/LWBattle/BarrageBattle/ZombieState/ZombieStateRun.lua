
local ZombieCommonAI = require "Scene.LWBattle.AI.ZombieCommonAI"

---
--- Pve 丧尸移动状态
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateRun
local ZombieStateRun = BaseClass("ZombieStateRun")

local CHECK_TARGET_IN_RANGE_CD = 0.5--检查目标是否在射程内cd

function ZombieStateRun:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Zombie
    self.ai=ZombieCommonAI.New(self.unit)---@type Scene.LWBattle.AI.ZombieCommonAI
    self.checkTargetInRangeCd=0
end

function ZombieStateRun:__delete()
    self.unit = nil
end

function ZombieStateRun:OnEnter()
    local pos = self.unit:GetPosition()
    self.unit.agent:SetCurPosition(pos.x,pos.z)
    if (not self.unit.IsImprisoning) or (not self.unit:IsImprisoning()) then
        self.unit.agent.speed = self.unit.meta.move_speed --TODO 接配置
    end
    if self.unit:IsSpecialMoving() then
        self.unit:SetStealth(true)
        self.unit:PlaySimpleAnim(AnimName.SpecialMove,1)
    else
        self.unit:PlaySimpleAnim(AnimName.Run,1)
    end
    self.checkTargetInRangeCd=0
end

function ZombieStateRun:OnExit()
    if self.unit:IsSpecialMoving() then
        if self.unit.buffManager then
            self.unit.buffManager:RemoveAllBuffByType(BuffType.SpecialMove)
        end
        self.unit:SetStealth(false)
    end
    self.nextSkill = nil
    self.target = nil
    self.unit:RemoveDestination()
end

function ZombieStateRun:OnUpdate()

    --获取下一个可以施放的技能
    if not self.nextSkill then
        self.nextSkill=self.unit.skillManager:GetActiveSkillIgnoreRange()
        return
    end
    
    --检查是否有目标
    if not self.target then
        self.target = self.ai:GetTarget(self.nextSkill)
        return
    end
    
    --检查目标是否活着
    if self.nextSkill:IsBuffSkill() then--buff型技能，target是unit table
        if #self.target<=0 then
            self.target = self.ai:GetTarget(self.nextSkill)
            return
        end
        for _,tar in pairs(self.target) do
            if tar:GetCurBlood()<=0 then
                self.target = self.ai:GetTarget(self.nextSkill)
                return
            end
        end
    else--子弹型技能，target是unit
        if self.target:GetCurBlood()<=0 then
            self.target = self.ai:GetTarget(self.nextSkill)
            return
        end
    end
    

    if self.checkTargetInRangeCd<=0 then
        self.checkTargetInRangeCd=CHECK_TARGET_IN_RANGE_CD
        local inRange=self.nextSkill:IsTargetInRange(self.target)
        if inRange then
            self.unit.fsm:ChangeState(ZombieState.Attack,self.nextSkill,self.target)
        else
            if self.nextSkill:IsBuffSkill() then--buff型技能，target是unit table
                local targetPos=self.target[1]:GetPosition()
                self.unit:SetDestination(targetPos.x,targetPos.z)
            else--子弹型技能，target是unit
                local targetPos=self.target:GetPosition()
                self.unit:SetDestination(targetPos.x,targetPos.z)
            end
        end
    else
        self.checkTargetInRangeCd = self.checkTargetInRangeCd - Time.deltaTime
    end
    
    --if self.nextSkill then
    --    if not self.target then
    --        self.target = self.ai:GetTarget(self.nextSkill)
    --    end
    --    local inRange=self.nextSkill:IsTargetInRange(self.target)
    --    if inRange then
    --        self.unit.fsm:ChangeState(ZombieState.Attack,self.nextSkill,self.target)
    --    elseif self.target then
    --        local targetPos=self.target:GetPosition()
    --        self.unit:SetDestination(targetPos.x,targetPos.z)
    --    else
    --        self.unit.fsm:ChangeState(ZombieState.Idle)
    --    end
    --else
    --    self.nextSkill=self.unit.skillManager:GetActiveSkillIgnoreRange()
    --end

    
end





return ZombieStateRun
