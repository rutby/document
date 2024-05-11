---
--- Pve 丧尸空闲状态
---

local ZombieIdleState = BaseClass("ZombieIdleState")

function ZombieIdleState:__init(zombie)
    self.zombie = zombie
end

function ZombieIdleState:__delete()

end

function ZombieIdleState:OnEnter()
    self.zombie:PlayAnim(self.zombie.Anim.Stand)
end

function ZombieIdleState:OnExit()
    
end

function ZombieIdleState:OnUpdate(deltaTime)
    self.zombie:DoSearchTarget()
    local target = self.zombie:GetAttackTarget()
    if target ~= nil and target:GetCurBlood() > 0 then
        self.zombie:AttackTarget()
    end
end

return ZombieIdleState