

---
--- 开火状态之 施法
---
---@class Scene.LWBattle.Skirmish.UnitFSM.FireStateCasting
local FireStateCasting = BaseClass("FireStateCasting")


---@param unit Scene.LWBattle.Skirmish.Unit.SkirmishUnit
function FireStateCasting:__init(unit)
    self.unit = unit---@type Scene.LWBattle.Skirmish.Unit.SkirmishUnit
end

function FireStateCasting:__delete()
    self.unit = nil
    self.target=nil
    self.curSkill = nil
end

function FireStateCasting:OnEnter(skill,targetUnits)
    self.curSkill = skill
    self.target = targetUnits
    --Logger.Log("进入施法阶段："..self.unit.name.." skillId"..skill.meta.id..(self.curSkill:IsBuffSkill() and " isBuff" or ""))
end

function FireStateCasting:OnExit()
    self.target=nil
    self.curSkill = nil
end

--检查武器是否指向目标，是-return true；否-转向目标 然后return false
function FireStateCasting:CheckDirection()
    if self.unit==self.target then
        return true
    end
    return PveUtil.CheckCannonLookAt(self.unit,self.target:GetPosition())
end

function FireStateCasting:OnUpdate()
    --等cd阶段：按照上一个技能和目标，转向目标
    --瞄准阶段：找到了下一个技能和目标，转向目标
    --施法阶段：持续转向目标

    if self.curSkill:GetState()==SkillCastState.FrontSwing 
            or self.curSkill:GetState()==SkillCastState.Chant
            or self.curSkill:GetState()==SkillCastState.BackSwing then--施法前摇或吟唱或施法后摇阶段：
        --if not self.curSkill:IsBuffSkill() then--buff类技能不用转向
        --    if self.target and self.target:GetCurBlood()>0 then
        --        self:CheckDirection()
        --    end
        --end
    else--cd阶段
        self:Idle()
        return
    end
end

function FireStateCasting:Idle()
    self.unit.fsm:ChangeState(SkirmishFireState.Idle)
end



return FireStateCasting