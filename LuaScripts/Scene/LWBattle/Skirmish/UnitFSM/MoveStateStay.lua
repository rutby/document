
---
--- 移动状态 之 不动
---
---@class Scene.LWBattle.Skirmish.UnitFSM.MoveStateStay
local MoveStateStay = BaseClass("MoveStateStay")


function MoveStateStay:__init(unit)
    self.unit = unit
end

function MoveStateStay:__delete()
    self.unit = nil
end

function MoveStateStay:OnEnter()

end

function MoveStateStay:OnExit()
    
end

function MoveStateStay:OnUpdate()

end

function MoveStateStay:HandleInput(input,param)
    
end


return MoveStateStay