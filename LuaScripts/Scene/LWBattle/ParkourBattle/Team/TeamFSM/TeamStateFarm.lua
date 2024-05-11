
---
--- 小队状态 之 跑酷
---
---@class Scene.LWBattle.ParkourBattle.Team.FSM.TeamStateFarm
local TeamStateFarm = BaseClass("TeamStateFarm")


function TeamStateFarm:__init(team)
    self.team = team
end

function TeamStateFarm:__delete()
    self.team = nil
end

function TeamStateFarm:OnEnter(destination)

end

function TeamStateFarm:OnExit()
    
end

function TeamStateFarm:OnUpdate()
    local deltaTime = Time.deltaTime
    local position = self.team:GetPosition()
    local add = self.team:GetMoveSpeedZ() * deltaTime
    local z = position.z + add
    self.team:SetPosition(position.x,z)
end

function TeamStateFarm:HandleInput(input,param)
    
end

function TeamStateFarm:OnTransToSelf(x)
    local position = self.team:GetPosition()
    local nowX = position.x
    local offset = x - nowX
    local dir = 1
    if offset < 0 then
        dir = -1
    end
    local move = self.team.speedX * Time.deltaTime * dir
    if math.abs(move) > math.abs(offset) then
        move = offset
    end
    self.team:SetPosition(nowX + move,position.z)
end

return TeamStateFarm