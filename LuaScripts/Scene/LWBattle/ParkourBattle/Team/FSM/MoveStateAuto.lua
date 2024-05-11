
---
--- 移动状态 之 自动移动（路径点模式）
---
---@class Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateAuto
local MoveStateAuto = BaseClass("MoveStateAuto")

---@param member Scene.LWBattle.BarrageBattle.Unit.Member
function MoveStateAuto:__init(member)
    self.member = member---@type Scene.LWBattle.BarrageBattle.Unit.Member
    self.startPos = Vector3.New(0,0,0)
    self.destination=nil
end

function MoveStateAuto:__delete()
    self.member = nil
    self.startPos = nil
    self.destination=nil
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
end

function MoveStateAuto:OnEnter(destination)
    self:SetDestination(destination)
end

function MoveStateAuto:OnExit()
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
end

function MoveStateAuto:OnUpdate()

end

function MoveStateAuto:OnTransToSelf(destination)
    self:SetDestination(destination)
end

function MoveStateAuto:HandleInput(input,param)
    
end

function MoveStateAuto:SetDestination(destination)
    if not destination then return end
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
    self.tween = self.member.transform:DOLookAt(destination,0.5)
end


return MoveStateAuto