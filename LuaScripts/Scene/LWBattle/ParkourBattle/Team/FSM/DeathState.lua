---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by wsf.
--- 准备阶段
---

local DeathState = BaseClass("DeathState")

function DeathState:__init(unit)
    ---@type Scene.LWBattle.BarrageBattle.Unit.Member
    self.unit = unit
end

function DeathState:__delete()
    self.unit = nil
end

function DeathState:OnEnter()
    self.unit:PlaySimpleAnim(AnimName.Dead)
end

function DeathState:OnExit()
    
end

function DeathState:OnUpdate()
    
end

return DeathState