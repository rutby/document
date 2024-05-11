
local Const = require("Scene.LWBattle.Const")



---
--- Pve 丧尸晕眩状态：丧尸持有牵引、晕眩、压制等debuff时的状态（不含禁锢、减速、致盲、缴械、沉默）。
--- 此状态下丧尸不可以攻击、不可以移动。
--- 恐惧、魅惑等带位移的硬控以后再做
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateStun
local ZombieStateStun = BaseClass("ZombieStateStun")


function ZombieStateStun:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Zombie
end

function ZombieStateStun:__delete()
    self.unit = nil
    
end

function ZombieStateStun:OnEnter()
    self.unit:PlaySimpleAnim(AnimName.Stun,1)
end

function ZombieStateStun:OnTransToSelf()
end


function ZombieStateStun:OnExit()
end

function ZombieStateStun:OnUpdate()
    if not self.unit:IsStunning() then
        self.unit.fsm:ChangeState(ZombieState.Run)
    end
end

return ZombieStateStun