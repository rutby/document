
---
--- 移动状态 之 左右移动
---
---@class Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateLeftRight
local MoveStateLeftRight = BaseClass("MoveStateLeftRight")


function MoveStateLeftRight:__init(member)
    self.member = member
end

function MoveStateLeftRight:__delete()
    self.member = nil
end

function MoveStateLeftRight:OnEnter(destination)

end

function MoveStateLeftRight:OnExit()
    
end

function MoveStateLeftRight:OnUpdate()

end

function MoveStateLeftRight:HandleInput(input,param)
    
end


return MoveStateLeftRight