

---
--- Pve 队员自动攻击状态（搜寻最近的敌人，对其攻击）（两个玩法共用）
---
---@class Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack
local MemberUpStateAutoAttack = BaseClass("MemberUpStateAutoAttack")


---@param unit Scene.LWBattle.BarrageBattle.Unit.Member
function MemberUpStateAutoAttack:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Member
    self.target = nil
end

function MemberUpStateAutoAttack:__delete()
    self.unit = nil
    self.target=nil
    self.prevSkill = nil
    self.nextSkill = nil
end

function MemberUpStateAutoAttack:OnEnter()
    self.target=nil
    self.prevSkill = nil
    self.nextSkill = nil
end

function MemberUpStateAutoAttack:OnExit()
    self.target=nil
    self.prevSkill = nil
    self.nextSkill = nil
    self.unit.skillManager:Interrupt()
end

--检查武器是否指向目标，是-return true；否-转向目标 然后return false
function MemberUpStateAutoAttack:CheckDirection()
    if self.unit==self.target then
        return true
    end
    return PveUtil.CheckCannonLookAt(self.unit,self.target:GetPosition())
end

function MemberUpStateAutoAttack:OnUpdate()
    --等cd阶段：转向目标（仅限无人机）
    --瞄准阶段：找到了下一个技能和目标，转向目标
    --施法阶段：持续转向目标
    
    if self.unit.skillManager:GetCastingSkill() then--施法阶段：
        local curSkill = self.unit.skillManager:GetCastingSkill()
        if curSkill:GetState()==SkillCastState.FrontSwing 
                or curSkill:GetState()==SkillCastState.Chant then--施法前摇或吟唱阶段：持续转向目标
            if not curSkill:IsBuffSkill() then--buff类技能不用转向
                if self.target and self.target:GetCurBlood()>0 then
                    self:CheckDirection()
                else
                    self.target=self:GetTarget(curSkill)
                end
            end
        end
    else--非施法阶段
        if self.unit:IsMoving() then
            self.unit:CrossFadeSimpleAnim(AnimName.AttackMove,1,0.2)
            --self.unit:PlaySimpleAnim(AnimName.Run)
        else
            self.unit:CrossFadeSimpleAnim(AnimName.Attack,1,0.2)
            --self.unit:PlaySimpleAnim(AnimName.Idle)
        end
        if not self.nextSkill then
            self.nextSkill=self.unit.skillManager:GetActiveSkill()
            if self.nextSkill then
                if self.nextSkill:IsBuffSkill() then--buff类技能没有瞄准阶段，直接释放（甚至可以无目标释放）
                    local skill = self.nextSkill
                    self.unit.skillManager:ActiveCast(self.nextSkill,self:GetTarget(self.nextSkill))
                    self.nextSkill = nil
                    
                    if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
                        EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
                    end
                else
                    self.target=self:GetTarget(self.nextSkill)
                end
            end
        end
        if self.nextSkill then--瞄准阶段：找到了下一个技能和目标，转向目标
            if (not self.target) or self.target:GetCurBlood()<=0 then
                self.target=self:GetTarget(self.nextSkill)
            end
            if self.target and self.target:GetCurBlood()>0 then
                if self:CheckDirection() then--检查武器是否指向目标
                    local skill = self.nextSkill
                    self.unit.skillManager:ActiveCast(self.nextSkill,self.target)
                    self.prevSkill = self.nextSkill
                    self.nextSkill = nil

                    if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
                        EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
                    end
                end
            end
            --等cd阶段只有无人机持续转向目标，转向会导致开火特效跟着转
        elseif self.unit.unitType==UnitType.TacticalWeapon then--等cd阶段
            local ultimateSkill = self.unit.skillManager:GetUltimateSkill()
            if ultimateSkill then
                if (not self.target) or self.target:GetCurBlood()<=0 then
                    self.target=self:GetTarget(ultimateSkill)
                end
                if self.target and self.target:GetCurBlood()>0 then
                    self:CheckDirection()
                end
            end
        end
    end
    
end


--获取目标：如果被嘲讽且普攻，则目标是嘲讽目标；否则正常索敌
function MemberUpStateAutoAttack:GetTarget(skill)
    if skill:IsNormalAttack() then
        local tauntTarget = self.unit:GetTauntTarget()
        if tauntTarget then
            return tauntTarget
        end
    end
    local ret = skill:SearchTarget()
    return ret
end



return MemberUpStateAutoAttack