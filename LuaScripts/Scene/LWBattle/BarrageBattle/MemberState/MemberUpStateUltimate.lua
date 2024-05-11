

---
--- Pve 开大招瞄准状态（免疫时停）
---
---@class Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateUltimate
local MemberUpStateUltimate = BaseClass("MemberUpStateUltimate")


---@param unit Scene.LWBattle.BarrageBattle.Unit.Member
function MemberUpStateUltimate:__init(unit)
    self.unit = unit---@type Scene.LWBattle.BarrageBattle.Unit.Member
    self.target = nil
    self.isBuffSkill = nil
end

function MemberUpStateUltimate:__delete()
    self.unit = nil
    self.target=nil
    self.nextSkill = nil
end

function MemberUpStateUltimate:OnEnter()
    self.isFiring=false
    self.nextSkill=self.unit.skillManager:PrepareCastUltimate()
    self.isBuffSkill=self.nextSkill:IsBuffSkill()
    if self.isBuffSkill then--buff类技能对射程内目标释放（甚至可以无目标释放）
        self.unit.skillManager:ActiveCast(self.nextSkill,self.nextSkill:SearchTarget())

        if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
            EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, self.nextSkill)
        end
    end

    if self.unit.unitType == nil or self.unit.unitType ~= UnitType.TacticalWeapon then

        --无人机不显示脚下施法光圈
        local ultimateRingEffect = "Assets/_Art/Effect/Prefab/UI/Common/Eff_world_hero_guangquan.prefab"
        local duration = self.unit:GetUltimateTimeStopDuration()
        self.unit.battleMgr:ShowEffectObj(ultimateRingEffect,nil,nil,duration,self.unit.transform)
        
    end
    --self.isFiring=false
    --self.nextSkill=self.unit.skillManager:PrepareCastUltimate()
    --if not self.nextSkill:IsBuffSkill() then--buff类技能没有瞄准阶段
    --    self.target=self.nextSkill:SearchTargetPriorRange()
    --end
    --
    --local timeStopDuration = self.unit:GetUltimateTimeStopDuration()
    --timeStopDuration = timeStopDuration>0 and timeStopDuration or TIME_STOP_DURATION
    --self.unit.battleMgr:StartTimeStop(timeStopDuration)--全局时停

    if self.unit and not IsNull(self.unit.gameObject) then
        self.unit.gameObject.transform:DOScale(Vector3.New(1.25,1.25,1.25),0.25):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
    end
end

function MemberUpStateUltimate:OnExit()
    self.target=nil
    self.nextSkill = nil
end

--检查武器是否指向目标，是-return true；否-转向目标 然后return false
function MemberUpStateUltimate:CheckDirection()
    if self.unit==self.target then
        return true
    end
    return PveUtil.CheckCannonLookAt(self.unit,self.target:GetPosition())
end

function MemberUpStateUltimate:OnUpdate()

    local curSkill = self.unit.skillManager:GetCastingSkill()
    if self.isBuffSkill then
        if curSkill then--buff施法阶段

        else--buff施法结束
            EventManager:GetInstance():Broadcast(EventId.UltimateCastFinish,self.nextSkill.meta.id)
            self.unit.upFsm:ChangeState(AttackState.AutoAttack)
        end
    else
        if not self.isFiring and not curSkill  then--子弹技能瞄准阶段
            if (not self.target) or self.target:GetCurBlood()<=0 then
                self.target = self.nextSkill:SearchTargetPriorRange()
            elseif self:CheckDirection() then
                local targetPos = self.nextSkill:LegalizeTarget(self.target)--目标可能在射程外，要压缩到射程内的某个位置
                self.unit.skillManager:ActiveCast(self.nextSkill,targetPos)
                self.isFiring=true

                if self.unit.unitType and self.unit.unitType == UnitType.TacticalWeapon then
                    EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, self.nextSkill)
                end
            end
        elseif self.isFiring and curSkill then--子弹技能施法阶段：持续转向目标
            if self.target and self.target:GetCurBlood()>0 then
                self:CheckDirection()
            else
                self.target = self.nextSkill:SearchTargetPriorRange()
            end
        else--子弹技能施法结束
            EventManager:GetInstance():Broadcast(EventId.UltimateCastFinish,self.nextSkill.meta.id)
            self.unit.upFsm:ChangeState(AttackState.AutoAttack)
        end
    end
    
    
    --if not self.nextSkill:IsBuffSkill() then--buff类技能没有瞄准阶段
    --    if (not self.target) or self.target:GetCurBlood()<=0 then
    --        self.target=self.nextSkill:SearchTargetPriorRange()
    --    else
    --        self:CheckDirection()
    --    end
    --end
    --if not self.isFiring and not self.unit.battleMgr:IsTimeStop() then--时停结束后施法
    --    if self.nextSkill:IsBuffSkill() then--buff类技能对射程内目标释放（甚至可以无目标释放）
    --        self.unit.skillManager:ActiveCast(self.nextSkill,self.nextSkill:SearchTarget())
    --    else
    --        local target = self.nextSkill:SearchTargetPriorRange()
    --        target = self.nextSkill:LegalizeTarget(target)--目标可能在射程外，要压缩到射程内的某个位置
    --        self.unit.skillManager:ActiveCast(self.nextSkill,target)
    --    end
    --    self.isFiring=true
    --end
    --if self.isFiring and not self.unit.skillManager:GetCastingSkill() then--施法结束后回归自动开火状态
    --    self.unit.upFsm:ChangeState(AttackState.AutoAttack)
    --    return
    --end
    
end


return MemberUpStateUltimate