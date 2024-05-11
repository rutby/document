
---
---开火状态 之 不开火
---
---@class Scene.LWBattle.ParkourBattle.Team.FSM.FireStateHold
local FireStateHold = BaseClass("FireStateHold")

---@param member Scene.LWBattle.BarrageBattle.Unit.Member
function FireStateHold:__init(member)
    self.member = member---@type Scene.LWBattle.BarrageBattle.Unit.Member
end

function FireStateHold:__delete()
    self.member = nil
end

function FireStateHold:OnEnter()
    if self.member:GetState("run") then
        self.member:PlaySimpleAnim("run")
    elseif self.member:GetState("walk") then
        self.member:PlaySimpleAnim("walk")
    end
end

function FireStateHold:OnExit()
    
end

function FireStateHold:OnUpdate()

end

function FireStateHold:HandleInput(input,param)
    
end


return FireStateHold