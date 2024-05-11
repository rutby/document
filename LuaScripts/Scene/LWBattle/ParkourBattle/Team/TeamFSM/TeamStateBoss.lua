
---
--- 小队状态 之 Boss
---
---@class Scene.LWBattle.ParkourBattle.Team.FSM.TeamStateBoss
local TeamStateBoss = BaseClass("TeamStateBoss")
local Const = require("Scene.LWBattle.Const")

function TeamStateBoss:__init(team)
    self.team = team
end

function TeamStateBoss:__delete()
    self.team = nil
end

function TeamStateBoss:OnEnter(destination)

end

function TeamStateBoss:OnExit()
    
end

function TeamStateBoss:OnUpdate()

end

function TeamStateBoss:HandleInput(input,param1,param2)
    --if input==Const.ParkourInput.FingerHold then
    --    
    --elseif input==Const.ParkourInput.FingerDown then
    --    
    --elseif input==Const.ParkourInput.FingerUp then
    --    
    --end
end


return TeamStateBoss