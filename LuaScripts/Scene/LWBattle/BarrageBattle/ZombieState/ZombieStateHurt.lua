
local Const = require("Scene.LWBattle.Const")



---
--- Pve 丧尸击退和重创状态，一段时间后自动恢复
--- 此状态下丧尸不可以攻击、不可以移动。
---
---@class Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateHurt
local ZombieStateHurt = BaseClass("ZombieStateHurt")


function ZombieStateHurt:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Zombie
    self.timer = 0
end

function ZombieStateHurt:__delete()
    self.unit = nil
    self.timer = 0
end

function ZombieStateHurt:OnEnter(time)
    self.timer = time
    --self.unit:PlaySimpleAnim(AnimName.Stun,1)
end

function ZombieStateHurt:OnTransToSelf(time)
    self.timer = math.max(self.timer,time)
end


function ZombieStateHurt:OnExit()
    self.timer = 0
end

function ZombieStateHurt:OnUpdate()
    self.timer=self.timer-Time.deltaTime
    if self.timer<=0 then
        self.unit.fsm:ChangeState(ZombieState.Idle)
    end
end





return ZombieStateHurt