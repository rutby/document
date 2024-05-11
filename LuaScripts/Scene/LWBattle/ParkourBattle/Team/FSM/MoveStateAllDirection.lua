
---
--- 移动状态 之 万向移动
---
---@class Scene.LWBattle.ParkourBattle.Team.FSM.MoveStateAllDirection
local MoveStateAllDirection = BaseClass("MoveStateAllDirection")

---@param member Scene.LWBattle.ParkourBattle.Team.MemberUnit
function MoveStateAllDirection:__init(member)
    self.member = member---@type Scene.LWBattle.ParkourBattle.Team.MemberUnit
    self.startPos = Vector3.New(0,0,0)
    self.destination=nil
end

function MoveStateAllDirection:__delete()
    self.member = nil
    self.startPos = nil
    self.destination=nil
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
end

function MoveStateAllDirection:OnEnter(destination)
    self:SetDestination(destination)
end

function MoveStateAllDirection:OnExit()
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
end

function MoveStateAllDirection:OnUpdate()

end

function MoveStateAllDirection:OnTransToSelf(destination)
    self:SetDestination(destination)
end

function MoveStateAllDirection:HandleInput(input,param)
    
end

function MoveStateAllDirection:SetDestination(destination)
    if not destination or self.member.isHuman then
        return
    end

    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
    self.tween = self.member.transform:DOLookAt(destination,0.5)
    
end


return MoveStateAllDirection