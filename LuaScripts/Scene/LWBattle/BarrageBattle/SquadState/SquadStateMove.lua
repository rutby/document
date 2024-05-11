---
--- Pve 小队移动状态
---


---@class Scene.LWBattle.BarrageBattle.SquadState.SquadStateMove
local SquadStateMove = BaseClass("SquadStateMove")

---@param squad Scene.LWBattle.BarrageBattle.Squad
function SquadStateMove:__init(squad)
    self.squad = squad
    self.destination = Vector3.New(0,0,0)
    self.direction = Vector3.New(0,0,0)
end

function SquadStateMove:__delete()
    self.squad = nil
    self.destination = nil
    self.direction = nil
end

function SquadStateMove:OnEnter(destination)
    self:MoveTo(destination)
end

function SquadStateMove:OnExit()
    
end

function SquadStateMove:OnUpdate()
    if self.squad:CheckNeedStop() then
        self.squad.fsm:ChangeState(SquadState.Stay)
        return
    end
    local curPos = self.squad:GetPosition()
    local delta = self.destination - curPos
    local speed = self.squad:GetMoveSpeed()
    local maxMovement = speed * Time.deltaTime
    
    if delta:SqrMagnitude()<maxMovement*maxMovement then
        self.squad:SetPosition(self.destination)
        self.squad.battleMgr:OnArriveWayPoint()
    else
        local newPos = self.direction * maxMovement + curPos
        self.squad:SetPosition(newPos)
    end
end

function SquadStateMove:HandleInput(input,param)
end

function SquadStateMove:OnTransToSelf(destination)
    self:MoveTo(destination)
end

function SquadStateMove:MoveTo(destination)
    self.destination.x = destination.x
    self.destination.z = destination.z
    local curPos = self.squad:GetPosition()
    local delta = self.destination - curPos
    self.direction = delta:Normalize()
    for i,v in pairs(self.squad.members) do
        local member=v---@type Scene.LWBattle.BarrageBattle.Unit.Member
        local offset=self.squad.formation:GetOffsetByIndex(member.index)
        --Logger.LogError("MemberCommand.Move:"..i)
        member:HandleInput(MemberCommand.Move,destination+offset)
    end
end

return SquadStateMove