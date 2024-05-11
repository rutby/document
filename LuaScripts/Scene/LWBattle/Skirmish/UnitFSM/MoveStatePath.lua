
---
--- 移动状态 之 路径点模式
---
---@class Scene.LWBattle.Skirmish.UnitFSM.MoveStatePath
local MoveStatePath = BaseClass("MoveStatePath")


function MoveStatePath:__init(unit)
    self.unit = unit
end

function MoveStatePath:__delete()
    self.unit = nil
end

function MoveStatePath:OnEnter()
    if self.unit:GetState("run") then
        self.unit:PlaySimpleAnim("run")
    elseif self.unit:GetState("walk") then
        self.unit:PlaySimpleAnim("walk")
    end
end

function MoveStatePath:OnExit()
    
end

function MoveStatePath:OnUpdate()

end

function MoveStatePath:HandleInput(input,param)
    
end


return MoveStatePath