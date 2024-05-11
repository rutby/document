


---
--- Pve 丧尸发呆状态
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateRealIdle
local ZombieStateRealIdle = BaseClass("ZombieStateRealIdle")

---@param unit Scene.LWBattle.BarrageBattle.Unit.Zombie
function ZombieStateRealIdle:__init(unit)
    self.unit = unit
end

function ZombieStateRealIdle:__delete()
    self.unit = nil
end

function ZombieStateRealIdle:OnEnter()
    self.unit:RemoveDestination()
    self.unit:PlaySimpleAnim(ZombieAnim.Idle,1)
end

function ZombieStateRealIdle:OnExit()
    
end

function ZombieStateRealIdle:OnUpdate()

end



return ZombieStateRealIdle