


---
--- Pve 队员命令攻击状态（攻击准星）
---
---@class Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateStationAttack
local MemberUpStateStationAttack = BaseClass("MemberUpStateStationAttack")

---@param unit Scene.LWBattle.BarrageBattle.Unit.Member
function MemberUpStateStationAttack:__init(unit)
    self.unit = unit
    self.attackPos=nil
end

function MemberUpStateStationAttack:__delete()
    self.unit = nil
    self.attackPos=nil
end

function MemberUpStateStationAttack:OnEnter(attackPos)
    self.attackPos=attackPos
end

function MemberUpStateStationAttack:OnTransToSelf(attackPos)
    self.attackPos=attackPos
end

function MemberUpStateStationAttack:OnExit()
    self.unit.skillManager:Interrupt()
    self.attackPos=nil
end

--检查武器是否指向目标，是-return true；否-转向目标return false
function MemberUpStateStationAttack:CheckDirection()
    return PveUtil.CheckCannonLookAt(self.unit,self.attackPos)
end

function MemberUpStateStationAttack:OnUpdate()
    self:CheckDirection()
    
    local skill=self.unit.skillManager:GetActiveSkillIgnoreRange()
    if skill then
        if skill:IsBuffSkill() then
            self.unit.skillManager:ActiveCast(skill,skill:SearchTarget())

            if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
                EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
            end
        else
            --追踪型子弹自动索敌，其他子弹瞄准射程内距离准星最近点
            local targetPos = skill:SearchTargetAroundAim(self.attackPos)
            self.unit.skillManager:ActiveCast(skill,targetPos)

            if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
                EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)
            end
        end
        self.isRunOrIdle = false
    end
    
    --施法动画没有播放
    if not self.unit.skillManager:GetCastingSkill() then
        --播放移动或者发呆动画
        if not self.isRunOrIdle then
            self.isRunOrIdle = true
            if self.unit:IsMoving() then
                self.unit:PlaySimpleAnim(AnimName.Run)
            else
                self.unit:PlaySimpleAnim(AnimName.Idle)
            end
        end
    end
end


function MemberUpStateStationAttack:HandleInput(input,param)

end

return MemberUpStateStationAttack