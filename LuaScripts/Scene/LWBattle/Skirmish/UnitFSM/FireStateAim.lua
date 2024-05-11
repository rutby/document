

---
--- 开火状态之 瞄准
---
---@class Scene.LWBattle.Skirmish.UnitFSM.FireStateAim
local FireStateAim = BaseClass("FireStateAim")


---@param unit Scene.LWBattle.Skirmish.Unit.SkirmishUnit
function FireStateAim:__init(unit)
    self.unit = unit---@type Scene.LWBattle.Skirmish.Unit.SkirmishUnit
end

function FireStateAim:__delete()
    self.unit = nil
    self.target=nil
    self.nextSkill = nil
end

function FireStateAim:OnEnter(skill,target)
    self.nextSkill = skill
    self.target = target
    --self.targetIsUnit = self.target.unitType --target是unit还是vector
    --Logger.Log("进入瞄准阶段："..self.unit.name.." skillId"..skill.meta.id..(self.nextSkill:IsBuffSkill() and " isBuff" or ""))
    if self.nextSkill:IsBuffSkill() then--buff类技能没有瞄准阶段，直接释放（甚至可以无目标释放）
        self:Cast(true)
        return
    end

    if self.unit and self.unit.unitType == UnitType.TacticalWeapon then
        --无人机改版后也不需要转向了，直接释放
        self:Cast(true)
        return
    end

    if self.unit:IsMoving() then
        self.unit:CrossFadeSimpleAnim(AnimName.Run,1,0.2)
        --self.unit:PlaySimpleAnim(AnimName.Run)
    else
        self.unit:CrossFadeSimpleAnim(AnimName.Idle,1,0.2)
        --self.unit:PlaySimpleAnim(AnimName.Idle)
    end
end

function FireStateAim:OnExit()
    self.target=nil
    self.nextSkill = nil
end

function FireStateAim:OnUpdate()
    --等cd阶段：按照上一个技能和目标，转向目标
    --瞄准阶段：找到了下一个技能和目标，转向目标
    --施法阶段：持续转向目标

    if self:CheckDirection() then--检查武器是否指向目标
        self:Cast()
    end
end


--检查武器是否指向目标，是-return true；否-转向目标 然后return false
function FireStateAim:CheckDirection()
    if self.unit==self.target then
        return true
    end
    return PveUtil.CheckCannonLookAt(self.unit,self.target:GetPosition())
    --if self.targetIsUnit then
    --    if self.unit==self.target then
    --        return true
    --    end
    --    return PveUtil.CheckCannonLookAt(self.unit,self.target:GetPosition())
    --else
    --    return PveUtil.CheckCannonLookAt(self.unit,self.target)
    --end

end



--施放技能
function FireStateAim:Cast(isFake)
    self.unit.skillManager:ActiveCast(self.nextSkill,self.target,isFake)

    if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon and self.unit.index and self.unit.index == 11 then
        --自己的无人机
        EventManager:GetInstance():Broadcast(EventId.OnPVPTacticalWeaponCastSkill, self.nextSkill)
    end
    
    self.unit.fsm:ChangeState(SkirmishFireState.Casting,self.nextSkill,self.target)
end



return FireStateAim