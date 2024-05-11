

local ZombieCommonAI = require "Scene.LWBattle.AI.ZombieCommonAI"

---
--- Pve 丧尸发呆状态(默认状态)
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateIdle
local ZombieStateIdle = BaseClass("ZombieStateIdle")
local Time = Time
local CHECK_TARGET_IN_RANGE_CD = 0.5--检查目标是否在射程内cd
local REFRESH_WALK_TARGET_CD = 2--瞎走cd
local bornAnimLen = 2.8

---@param unit Scene.LWBattle.BarrageBattle.Unit.Zombie
function ZombieStateIdle:__init(unit)
    self.unit = unit
    self.bornTime = Time.time + bornAnimLen
    self.unit:PlaySimpleAnim(ZombieAnim.Born,1)
    self.checkTargetInRangeCd=0
    self.ai=ZombieCommonAI.New(self.unit)---@type Scene.LWBattle.AI.ZombieCommonAI

end

function ZombieStateIdle:__delete()
    self.unit = nil
end

function ZombieStateIdle:OnEnter()
    --Logger.Log(self.unit.gameObject.name.." ZombieStateIdle")
    self.unit:RemoveDestination()
    self.checkTargetInRangeCd=0
    self.idleCd = 0
    --self.unit:PlaySimpleAnim(Const.ZombieAnim.Idle)
end

function ZombieStateIdle:OnExit()
    
end

function ZombieStateIdle:OnUpdate()

    if  Time.time < self.bornTime then
        return
    end

    if self.checkTargetInRangeCd<=0 then
        self.checkTargetInRangeCd=CHECK_TARGET_IN_RANGE_CD
        if self:CheckTargetInSight() then
            return
        end
    else
        self.checkTargetInRangeCd = self.checkTargetInRangeCd - Time.deltaTime
    end

    if self.idleCd<=0 then
        self.idleCd=REFRESH_WALK_TARGET_CD
        self:WalkAround()
    else
        self.idleCd = self.idleCd - Time.deltaTime
    end
    
end

function ZombieStateIdle:CheckTargetInSight()
    if not self.unit.isAlert then
        self.unit.isAlert = self.unit:CheckEnemyInAlertRange()
    end
    if self.unit.isAlert then
        local nextSkill=self.unit.skillManager:GetActiveSkillIgnoreRange()
        if nextSkill then
            local target = self.ai:GetTarget(nextSkill)
            local inRange=nextSkill:IsTargetInRange(target)
            if inRange then
                self.unit.fsm:ChangeState(ZombieState.Attack,nextSkill,target)
            elseif target then
                self.unit.fsm:ChangeState(ZombieState.Run)
            else
                self.unit.fsm:ChangeState(ZombieState.Idle)
            end
        end
    end
    return self.unit.isAlert
end


function ZombieStateIdle:WalkAround()
    local pos = self.unit:GetPosition()
    local dir = Vector3.Normalize(Vector3.New( math.random(-10000,10000), 0,  math.random(-10000,10000)))
    if (not self.unit.IsImprisoning) or (not self.unit:IsImprisoning()) then
        self.unit.agent.speed = 1
    end
    self.unit:PlaySimpleAnim(ZombieAnim.Walk,1)
    self.unit:SetDestination(pos.x + dir.x * 2,pos.z + dir.z * 2)
end


return ZombieStateIdle
