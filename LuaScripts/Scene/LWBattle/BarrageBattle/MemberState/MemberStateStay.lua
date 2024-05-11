


---
--- Pve 队员发呆状态
---
---@class Scene.LWBattle.BarrageBattle.MemberState.MemberStateStay
local MemberStateStay = BaseClass("MemberStateStay")

---@param member Scene.LWBattle.BarrageBattle.Unit.Member
function MemberStateStay:__init(member)
    self.member = member
end

function MemberStateStay:__delete()
    self.member = nil
end

function MemberStateStay:OnEnter()
    --self.member:PlaySimpleAnim("idle")
end

function MemberStateStay:OnExit()
    
end

function MemberStateStay:OnUpdate(deltaTime)
    
end

function MemberStateStay:HandleInput(input,param)


end

return MemberStateStay