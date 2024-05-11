---
--- Pve 小队不移动状态
---


---@class Scene.LWBattle.BarrageBattle.SquadState.SquadStateStay
local SquadStateStay = BaseClass("SquadStateStay")

---@param squad Scene.LWBattle.BarrageBattle.Squad
function SquadStateStay:__init(squad)
    self.squad = squad
end

function SquadStateStay:__delete()
    self.squad = nil
end

function SquadStateStay:OnEnter()
    for _,v in pairs(self.squad.members) do
        v:HandleInput(MemberCommand.Stay)
    end
end

function SquadStateStay:OnExit()
    
end

function SquadStateStay:OnUpdate()
    if self.squad.destination then
        if not self.squad:CheckNeedStop() then
            self.squad:OnSetDestination(self.squad.destination)
        end
    end
end

function SquadStateStay:HandleInput(input,param)
    
end

return SquadStateStay