


---
--- Pve 队员死亡状态
---
---@class Scene.LWBattle.BarrageBattle.MemberState.MemberStateDie
local MemberStateDie = BaseClass("MemberStateDie")


---@param member Scene.LWBattle.BarrageBattle.Unit.Member
function MemberStateDie:__init(member)
    self.member = member
    self.animLength = self.member:GetAnimLength(MemberAnim.Dead)
    self.animLength = self.animLength>0 and self.animLength or 2
end

function MemberStateDie:__delete()
    self.member = nil
    if self.timer then
        self.timer:Stop()
        self.timer=nil
    end
end

function MemberStateDie:OnEnter()
    self.member.logic:OnMemberDeath()--战败检测
    self.member:RewindAndPlaySimpleAnim(MemberAnim.Dead)--播放死亡动画
    self.member.transform:SetParent(nil)
    if self.member.squad then
        self.member.squad:RemoveMember(self.member)--脱离小队管理，不再参与小队行动
    end
    self.timer = TimerManager:DelayInvoke(function()
        if self.member.unitType ~= UnitType.TacticalWeapon then
            self.member.logic:ShowEffectObj("Assets/Main/Prefabs/PVE/Obj_A_build_th_mb.prefab",self.member:GetPosition(),nil,-1)
        end
        self.member.logic:RemoveUnit(self.member)--unitMgr清理unit的view层
    end, self.animLength)
end

function MemberStateDie:OnExit()
    
end

function MemberStateDie:OnUpdate(deltaTime)
    
end

function MemberStateDie:HandleInput(input,param)
    
end

return MemberStateDie