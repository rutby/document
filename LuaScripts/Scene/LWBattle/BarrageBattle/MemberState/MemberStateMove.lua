
---
--- Pve 队员移动状态
---
---@class Scene.LWBattle.BarrageBattle.MemberState.MemberStateMove
local MemberStateMove = BaseClass("MemberStateMove")

---@param member Scene.LWBattle.BarrageBattle.Unit.Member
function MemberStateMove:__init(member)
    self.member = member---@type Scene.LWBattle.BarrageBattle.Unit.Member
    self.startPos = Vector3.New(0,0,0)
    self.destination=nil
end

function MemberStateMove:__delete()
    self.member = nil
    self.startPos = nil
    self.destination=nil
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
end

function MemberStateMove:OnEnter(destination)
    self:SetDestination(destination)
    if self.member.hero and self.member.hero.appearanceMeta then
        self.soundUid = DataCenter.LWSoundManager:PlaySoundByAssetName(self.member.hero.appearanceMeta.walk_sound,true)
    end
end

function MemberStateMove:OnExit()
    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
    DataCenter.LWSoundManager:StopSound(self.soundUid)
end

function MemberStateMove:OnUpdate()

end

function MemberStateMove:OnTransToSelf(destination)
    self:SetDestination(destination)
end

function MemberStateMove:HandleInput(input,param)
    
end

function MemberStateMove:SetDestination(destination)
    if not destination or (self.member.isHuman and self.member:CheckEnemyInAlertRange()) then
        return
    end

    if self.tween then
        self.tween:Kill()
        self.tween = nil
    end
    self.tween = self.member.transform:DOLookAt(destination,0.5)
    
end


return MemberStateMove