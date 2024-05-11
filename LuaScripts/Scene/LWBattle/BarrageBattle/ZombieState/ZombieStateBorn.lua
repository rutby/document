


---
--- Pve 丧尸发呆状态
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateBorn
local ZombieStateBorn = BaseClass("ZombieStateBorn")
local Time = Time

local bornAnimLen = 2.8

---@param unit Scene.LWBattle.BarrageBattle.Unit.Zombie
function ZombieStateBorn:__init(unit)
    self.unit = unit
end

function ZombieStateBorn:__delete()
    self.unit = nil
end

function ZombieStateBorn:OnEnter()
    self.unit:RemoveDestination()
    self.bornTime = Time.time + bornAnimLen
    self.unit:PlaySimpleAnim(ZombieAnim.Born,1)
end

function ZombieStateBorn:OnExit()
    
end

function ZombieStateBorn:OnUpdate()
    if Time.time > self.bornTime then
        self.unit.fsm:ChangeState(ZombieState.Idle)
    end
end



return ZombieStateBorn