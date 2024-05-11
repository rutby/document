---
--- Pve 丧尸攻击状态
---

local ZombieAttackState = BaseClass("ZombieAttackState")

function ZombieAttackState:__init(zombie)
    self.zombie = zombie
end

function ZombieAttackState:__delete()

end

function ZombieAttackState:OnEnter()
    local zombie = self.zombie
    zombie:PlayAnim(zombie.Anim.Attack)

    local target = zombie:GetAttackTarget()
    if target then
        local lookForward = target:GetPosition() - zombie:GetPosition()
        zombie:SetRotation(Quaternion.LookRotation(lookForward))
    end
end

function ZombieAttackState:OnExit()
    
end

function ZombieAttackState:OnUpdate(deltaTime)
    local zombie = self.zombie
    local target = zombie:GetAttackTarget()
    if target == nil or target:GetCurBlood() <= 0 then
        zombie:Move()
    end
end

return ZombieAttackState