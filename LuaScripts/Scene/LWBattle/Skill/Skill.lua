---
--- PVE 技能
---
---主动技能：有施法动作，与其他主动技能互斥（同一时间只能施放一个主动技能）
---被动技能：无施法动作，与其他技能可以并行
---技能的射程有两重意义，1是限制了索敌范围，"看不见"射程外的敌人；2是限制了子弹的射程（追踪弹和抛物线弹）

---@class Scene.LWBattle.Skill.Skill
---@field meta HeroSkillTemplate
local Skill = BaseClass("Skill")

local Resource = CS.GameEntry.Resource



---@param skillInfo SkillInfo
---@param meta HeroSkillTemplate
function Skill:__init(battleMgr,skillMgr,owner,meta,skillInfo,isUltimate)
    self.battleMgr=battleMgr
    self.skillMgr=skillMgr---@type Scene.LWBattle.Skill.SkillManager
    self.owner=owner
    self.meta=meta
    self.isUltimate=isUltimate
    self.skillInfo = skillInfo
    self.level=skillInfo and skillInfo.level or 0
    self.castTime = 0
    
    local curPVEType = self.battleMgr:GetPVEType()
    if PVPType[curPVEType] then
        self.bulletId = self.meta.pvp_bullet
        self.cast_count = 0
        self.cast_interval = 0
    else
        self.bulletId = self.meta.bullet
        self.cast_count = self.meta.cast_count
        self.cast_interval = self.meta.cast_interval
    end
    if skillInfo and not skillInfo:IsUnlock() then
        self.lock=true
    else
        self.lock=false
    end
    if meta.actionType == SkillActionType.Bullet then--子弹型技能
        --技能伤害系数，bullet会使用该字段
        if skillInfo then
            self.damage = skillInfo:GetAllDamage()
            for i = 1, #self.damage do
                self.damage[i]=self.damage[i]*self.meta.damage_to_monster--对野怪伤害系数
            end
        else
            self.damage = self.meta.damageParams
        end
        self.bulletMeta = DataCenter.PveBulletTemplateManager:GetTemplate(self.bulletId)
        if self.bulletMeta.mvt_type==BulletMoveType.Follow then
            self.chantTime = self.bulletMeta.lifetime--吟唱型技能
            self.chantBullet={}
        end
    end
    self.buff = self.meta.buff
    if self.buff > 0 then--技能生成buff
        self.buffMeta = DataCenter.LWBuffTemplateManager:GetTemplate(self.buff)
    end


    local attackSpeedAddRate = 0
    if self.owner ~= nil and type(self.owner.GetProperty) == 'function' then
        if meta.is_normal_attack then
            --攻击间隔=配置的间隔/（1+攻速提升75650）
            attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllAttackSpeedAddRate)
        else
            --技能cd=配置的cd/（1+cd提升75750）
            attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllCdReduceRate)
        end
        if self.owner.hero ~= nil then
            attackSpeedAddRate = attackSpeedAddRate + DataCenter.LWBattleManager.logic.stageEffectMgr:Get(StageEffectType.AttackSpeed)
        end
        attackSpeedAddRate=math.max(-0.5,attackSpeedAddRate)
    end
    self.cd = meta.pre_cd/(1+attackSpeedAddRate)--初始cd/初始攻击间隔
    
    

    self.state = self.cd>0 and SkillCastState.Cooldown or SkillCastState.Ready
    self.realFireDelay=0
    self.attackInterval=self.cd
    self.timerFire=0
    self.timerFinish=0
    local skillEffect = meta:GetSkillEffect(self.owner.appearanceId)
    if skillEffect>0 then--有些技能，例如光环，没有特效
        self.effectMeta = DataCenter.PveSkillEffectTemplateManager:GetTemplate(skillEffect)
    end
    --技能目标，可能是坐标，可能是unit，bullet会使用该字段
    self.target=nil
    --初始化技能目标layer、是否包括自己，bullet会使用该字段
    --因为我和队友使用相同的layer，所以碰撞检测时要对两种情况特殊处理：包含队友但不包含我、包含我但不包含队友
    self.targetLayerMask,self.targetAllyExcludeSelf,self.targetSelfExcludeAlly,self.targetUnitType = 
    PveUtil.GetTargetLayer(self.owner.unitType,self.meta.target_type)

    self.attackRange=self.meta.attack_range
    self.attack_interval=self.meta.attack_interval

    --if PVPType[curPVEType] then
        self.anim_normal = self.meta.anim_normal
        self.anim_move = self.meta.anim_move
    --elseif curPVEType == PVEType.Barrage then
    --    self.anim_normal = self.meta.matching_animation
    --    self.anim_move = self.meta.matching_animation_move
    --elseif (curPVEType == PVEType.Parkour or curPVEType == PVEType.Count) and (not self.battleMgr:IsDefenseMode()) then
    --    self.anim_normal = self.meta.matching_animation
    --    self.anim_move = self.meta.matching_animation_move
    --else
    --    --pve通用模式
    --    self.anim_normal = self.meta.pve_animation
    --    self.anim_move = self.meta.pve_animation_move
    --end
    
    self.hasAnim = not string.IsNullOrEmpty(self.anim_normal) --主动技支持不配置动作，则不播动作直接创建子弹

    if meta.subSkills and not meta.isSubSkill then
        self.subSkills={}
        for _,v in pairs(meta.subSkills) do
            local newSkill=Skill.New(battleMgr,skillMgr,owner,v,skillInfo)---@type Scene.LWBattle.Skill.Skill
            table.insert(self.subSkills,newSkill)
        end
    end

    if PVE_TEST_MODE and self.owner.bulletMotionEditor and self.bulletMeta then
        --把配置写入editor
        local bulletMeta = self.bulletMeta
        self.owner.bulletMotionEditor.AttackRange=self.meta.attack_range
        --self.owner.bulletMotionEditor.Cooldown=self.meta.attack_interval
        self.owner.bulletMotionEditor.BulletEffect=bulletMeta.bullet_effect
        self.owner.bulletMotionEditor.HeightWidthRatio=bulletMeta.mvt_type_para
        self.owner.bulletMotionEditor.Height=bulletMeta.mvt_type_para_2
        self.owner.bulletMotionEditor.FlySpeed=bulletMeta.bullet_fly_speed

        if string.IsNullOrEmpty(bulletMeta.motion_curve) then
            self.owner.bulletMotionEditor.CurveString=DEFAULT_BULLET_MOTION_STRING
            self.owner.bulletMotionEditor.MotionCurve=CS.BulletMotionEditor.StringToCurve(DEFAULT_BULLET_MOTION_STRING)
        else
            self.owner.bulletMotionEditor.CurveString=bulletMeta.motion_curve
            self.owner.bulletMotionEditor.MotionCurve=CS.BulletMotionEditor.StringToCurve(bulletMeta.motion_curve)
        end
        
        
        --用editor数据写入参数
        self.attackRange=self.owner.bulletMotionEditor.AttackRange
        self.attack_interval=self.owner.bulletMotionEditor.Cooldown

        
        self.cd=1
        self.state = SkillCastState.Cooldown
    end

    self.attackRangeSquare = self.attackRange * self.attackRange
    self.remainCount = 0
    self.timerReFire = 0
end

function Skill:SwitchToWorldTroopEffect()
    -- 世界行军的特效需要用不一样的参数，为了不影响别的逻辑，专门在这里切换一下参数
    -- 有三个参数要读取新的列：
    --      子弹速度 lifetime_world
    --      子弹时间 bullet_fly_speed_world
    --      子弹大小 bullet_effect_size_world
    self.isWorldTroopEffect = true
end

function Skill:__delete()
    self:Destroy()
end

function Skill:Destroy()
    self.battleMgr=nil
    self.skillMgr=nil
    self.owner=nil
    self.meta=nil
    self.target=nil
    self.damage=nil
    self.chantBullet=nil
    self.chantTime=nil
    self.redirectTargets = nil
    self.skillInfo = nil
end

function Skill:IsNil()
    return self.meta==nil
end

function Skill:OnUpdate()
    local deltaTime=Time.deltaTime
    if self.cd>0 then
        self.cd=self.cd-deltaTime
        if self.cd<=0 then
            self:ResetCooldown()
            if self.owner and self.owner.UltimateIsReady and self.owner:UltimateIsReady() then
                if self.owner.index then
                    --过滤掉无人机的技能
                    --EventManager:GetInstance():Broadcast(EventId.GF_zombie_battle_ult_ready, self.owner.index)
                end
            end
        end
    end

    if self.owner.hero and not self.meta.is_normal_attack and (self.castTime == 0 or self.cd < self.attackInterval - 1) then
        local tbl = {}
        tbl.heroId = self.owner.hero.heroId
        tbl.cd = self.cd
        tbl.maxCd = self.attackInterval
        EventManager:GetInstance():Broadcast(EventId.PveHeroSkillCdUpdate, tbl)
    end

    if self.timerFire>0 then
        self.timerFire=self.timerFire-deltaTime
        if self.timerFire<=0 then
            --施法前摇动画结束时，播放开火特效，生成子弹
            self:Fire()
        end
    end
    if self.timerFinish>0 then
        self.timerFinish=self.timerFinish-deltaTime
        if self.timerFinish<=0 then
            if self.chantTime then--吟唱型技能吟唱结束时
                DataCenter.LWSoundManager:StopSound(self.soundUid)
            end
            --施法后摇动画结束时，通知技能管理器
            --self.skillMgr.castingActiveSkill=nil
            if self.remainCount < 1 then
                --释放真正完成，没有剩余波次
                self.state = self.cd>0 and SkillCastState.Cooldown or SkillCastState.Ready
                self.skillMgr.castingActiveSkill=nil
            else
                self.timerReFire = self.cast_interval --下一波倒计时
            end
            --切换动作
            if self.owner:IsMoving() then
                self.owner:CrossFadeSimpleAnim(AnimName.AttackMove,1,0.2)
            else
                self.owner:CrossFadeSimpleAnim(AnimName.Attack,self.animSpeed,0.2)
            end
        end
    end

    if self.timerReFire > 0 then
        self.timerReFire = self.timerReFire - deltaTime
        if self.timerReFire <= 0 then
            if self.remainCount > 0 then
                self.remainCount = self.remainCount - 1

                --释放其他波次效果
                if self.meta.apType == SkillAPType.Active then
                    if (self.owner.anim or self.owner.animator) and self.hasAnim then--有施法动画的主动技能，播放动画，前摇动画播完时创建子弹
                        self:RePlayCastAnim()
                    else--无施法动画的主动技能，直接创建子弹
                        self:RealFire()
                        if self.remainCount < 1 then
                            self.skillMgr.castingActiveSkill=nil
                        else
                            self.timerReFire = self.cast_interval --下一波倒计时
                        end
                    end
                else--被动技能，没有施法动画，直接创建子弹
                    self:ReFire()

                    if self.remainCount > 0 then
                        self.timerReFire = self.cast_interval --下一波倒计时
                    end
                end
            else
                self.state = self.cd>0 and SkillCastState.Cooldown or SkillCastState.Ready
                self.skillMgr.castingActiveSkill=nil
            end
        end
    end

    if PVE_TEST_MODE and self.owner.bulletMotionEditor then
        --用editor数据写入参数
        self.attackRange=self.owner.bulletMotionEditor.AttackRange
        self.attack_interval=self.owner.bulletMotionEditor.Cooldown
    end
end


--施法中止
function Skill:Interrupt()
    if self.timerFire>0 then--前摇阶段被打断，cd返还
        self:ResetCooldown()
    end
    self.timerFire=0
    self.timerFinish=0
    self.timerReFire = 0
    self.remainCount = 0
    if self.chantBullet then
        for bulletUid,cb in pairs(self.chantBullet) do
            cb()
        end
        self.chantBullet={}
    end
end


--3.16技能释放的必要条件只有一个：射程
function Skill:CheckCondition()
    if self.attackRange<=0 then--射程无限
        return true
    end
    if self.targetSelfExcludeAlly then
        return true
    end
    local center = self.owner:GetPosition()
    local layerMask = self.targetLayerMask
    local radius = self.attackRange
    local ret = PveUtil.CheckHasUnitInSphereRange(self.battleMgr,center,radius,layerMask)
    return ret
end

--检查触发条件是否满足
function Skill:CheckTriggerParam(triggerType,param)
    if triggerType==SkillTriggerType.Death then
        return true
    elseif triggerType==SkillTriggerType.Cast then
        return param == self.meta.triggerParam
    end
end

---搜索目标（仅搜索射程内的）
function Skill:SearchTarget(srcPos, extraExclusions)
    if self.meta.actionType == SkillActionType.Bullet then
        return self:SearchTargetForBullet(srcPos, extraExclusions)
    elseif self.meta.actionType == SkillActionType.Buff or self.meta.actionType == SkillActionType.Halo then
        return self:SearchTargetForBuff(srcPos, extraExclusions)
    end
end

---搜索子弹目标（仅搜索射程内的，使用碰撞检测）
function Skill:SearchTargetForBullet(srcPos, extraExclusions)
    if self.targetSelfExcludeAlly then
        return self.owner
    end
    local center = srcPos or self.owner:GetPosition()
    local layerMask = self.targetLayerMask
    local radius = self.attackRange
    local exclusions = {}
    table.merge(exclusions, extraExclusions)
    if self.meta.other_condition == PriorityType.All then
        Logger.LogError("子弹型技能配置了多目标，skillId="..self.meta.id)
        --使用最近的代替
        return PveUtil.FindNearestUnitInSphereRange(self.battleMgr,center,radius,layerMask,exclusions)
    elseif self.meta.other_condition == PriorityType.Random then
        return PveUtil.FindRandomUnitInSphereRange(self.battleMgr,center,radius,layerMask,exclusions)
    elseif self.meta.other_condition == PriorityType.Nearest then
        return PveUtil.FindNearestUnitInSphereRange(self.battleMgr,center,radius,layerMask,exclusions)
    elseif self.meta.other_condition == PriorityType.Farthest then
        return PveUtil.FindFarthestUnitInSphereRange(self.battleMgr,center,radius,layerMask,exclusions)
    elseif self.meta.other_condition == PriorityType.LowestHP then
        return PveUtil.FindLowestHPUnitInSphereRange(self.battleMgr,center,radius,layerMask,exclusions)
    elseif self.meta.other_condition == PriorityType.HighestMaxHP then
        return PveUtil.FindHighestMaxHPUnitInSphereRange(self.battleMgr,center,radius,layerMask,exclusions)
    elseif self.meta.other_condition == PriorityType.HighestDefense then
        return PveUtil.FindHighestPropertyUnitInSphereRange(self.battleMgr,center,radius,layerMask,exclusions, HeroEffectDefine.PhysicalDefense)
    end
end

---搜索buff目标（仅搜索射程内的，返回table）
function Skill:SearchTargetForBuff(srcPos, extraExclusions, ignoreRange)
    local ret={}
    if self.targetSelfExcludeAlly then
        ret[1]=self.owner
        return ret
    end

    local exclusions = {}
    table.merge(exclusions, extraExclusions)

    local tempTarget
    if ignoreRange or self.attackRange<=0 then--无限射程
        --unitType筛选
        tempTarget = self.battleMgr.unitMgr:GetAllUnitsByTypes(self.targetUnitType,exclusions)
    else--有限射程
        --射程+layerMask筛选
        local center = srcPos or self.owner:GetPosition()
        local layerMask = self.targetLayerMask
        local radius = self.attackRange
        tempTarget = PveUtil.GetAllUnitsInSphereRange(self.battleMgr,center,radius,layerMask,exclusions)
    end
    
    --站位筛选
    if self.meta.pos_condition==LocationCondition.Random then
        local toRemove=#tempTarget-self.meta.pos_num
        for i = 1, toRemove do
            table.remove(tempTarget,math.random(#tempTarget))
        end
    elseif self.meta.pos_condition==LocationCondition.FrontOnly then
        for i = #tempTarget,1,-1 do
            if tempTarget[i]:GetLocationType()~=LocationType.Front then
                table.remove(tempTarget,i)
            end
        end
    elseif self.meta.pos_condition==LocationCondition.BackOnly then
        for i = #tempTarget,1,-1 do
            if tempTarget[i]:GetLocationType()~=LocationType.Back then
                table.remove(tempTarget,i)
            end
        end
    end
    --兵种筛选
    if self.meta.troop_condition==HeroType.Tank then
        for i = #tempTarget,1,-1 do
            if tempTarget[i]:GetHeroCamp()~=HeroType.Tank then
                table.remove(tempTarget,i)
            end
        end
    elseif self.meta.troop_condition==HeroType.Missile then
        for i = #tempTarget,1,-1 do
            if tempTarget[i]:GetHeroCamp()~=HeroType.Missile then
                table.remove(tempTarget,i)
            end
        end
    elseif self.meta.troop_condition==HeroType.Aircraft then
        for i = #tempTarget,1,-1 do
            if tempTarget[i]:GetHeroCamp()~=HeroType.Aircraft then
                table.remove(tempTarget,i)
            end
        end
    end
    --优先级筛选
    if self.meta.other_condition==PriorityType.All then
        return tempTarget
    elseif self.meta.other_condition==PriorityType.Nearest then
        local nearest
        local minDist = IntMaxValue
        local center = srcPos or self.owner:GetPosition()
        for _,unit in pairs(tempTarget) do
            local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
            if dist < minDist then
                minDist = dist
                nearest = unit
            end
        end
        ret[#ret+1]=nearest
        return ret
    elseif self.meta.other_condition==PriorityType.Farthest then
        local farthest
        local maxDist = 0
        local center = srcPos or self.owner:GetPosition()
        for _,unit in pairs(tempTarget) do
            local dist = Vector3.ManhattanDistanceXZ(center, unit:GetPosition())
            if dist > maxDist then
                maxDist = dist
                farthest = unit
            end
        end
        ret[#ret+1]=farthest
        return ret
    elseif self.meta.other_condition==PriorityType.LowestHP then
        local lowest
        local lowestHP = IntMaxValue
        for _,unit in pairs(tempTarget) do
            local curHP = unit:GetCurBlood()
            if curHP < lowestHP then
                lowestHP = curHP
                lowest = unit
            end
        end
        ret[#ret+1]=lowest
        return ret
    elseif self.meta.other_condition == PriorityType.HighestMaxHP then
        local highest
        local highestHP = 0
        for _, unit in pairs(tempTarget) do
            local maxHP = unit:GetMaxBlood()
            if maxHP > highestHP then
                highestHP = maxHP
                highest = unit
            end
        end
        ret[#ret+1]=highest
        return ret
    elseif self.meta.other_condition == PriorityType.HighestDefense then
        local highest
        local highestDefense = 0
        for _, unit in pairs(tempTarget) do
            local maxDefense = unit:GetProperty(HeroEffectDefine.PhysicalDefense)
            if maxDefense > highestDefense then
                highestDefense = maxDefense
                highest = unit
            end
        end
        ret[#ret+1]=highest
        return ret
    elseif self.meta.other_condition==PriorityType.Random then
        local rand=math.random(#tempTarget)
        ret[#ret+1]=tempTarget[rand]
        return ret
    end
end

---搜索目标，忽视射程（全局搜索）
function Skill:SearchTargetIgnoreRange(srcPos, extraExclusions)
    if self.meta.actionType == SkillActionType.Bullet then
        return self:SearchTargetForBulletIgnoreRange(srcPos, extraExclusions)
    elseif self.meta.actionType == SkillActionType.Buff or self.meta.actionType == SkillActionType.Halo then
        return self:SearchTargetForBuffIgnoreRange(srcPos, extraExclusions)
    end
end

---搜索子弹目标（全局搜索，通过遍历unitManager）
function Skill:SearchTargetForBulletIgnoreRange(srcPos, extraExclusions)
    if self.targetSelfExcludeAlly then
        return self.owner
    end
    local exclusions = extraExclusions
    local center = srcPos or self.owner:GetPosition()
    local target
    if self.meta.other_condition == PriorityType.All then
        Logger.LogError("子弹型技能有多个目标？技能配置id="..self.meta.id)
        --使用最近的代替
        target = self.battleMgr.unitMgr:GetNearestUnitByTypes(self.targetUnitType,center,exclusions)
    elseif self.meta.other_condition == PriorityType.Random then
        target = self.battleMgr.unitMgr:GetRandomUnitByTypes(self.targetUnitType,exclusions)
    elseif self.meta.other_condition == PriorityType.Nearest then
        target = self.battleMgr.unitMgr:GetNearestUnitByTypes(self.targetUnitType,center,exclusions)
    elseif self.meta.other_condition == PriorityType.Farthest then
        target = self.battleMgr.unitMgr:GetFarthestUnitByTypes(self.targetUnitType,center,exclusions)
    elseif self.meta.other_condition == PriorityType.LowestHP then
        target = self.battleMgr.unitMgr:GetLowestHPUnitByTypes(self.targetUnitType,exclusions)
    elseif self.meta.other_condition == PriorityType.HighestMaxHP then
        target = self.battleMgr.unitMgr:GetHighestMaxHPUnitByTypes(self.targetUnitType,exclusions)
    elseif self.meta.other_condition == PriorityType.HighestDefense then
        target = self.battleMgr.unitMgr:GetHighestPropertyUnitByTypes(self.targetUnitType,exclusions,HeroEffectDefine.PhysicalDefense)
    end
    return target
end

---搜索buff目标（全局搜索，返回table）
function Skill:SearchTargetForBuffIgnoreRange(srcPos, extraExclusions)
    return self:SearchTargetForBuff(srcPos, extraExclusions, true)
end

---搜索目标，射程内优先，实在没有才突破射程
function Skill:SearchTargetPriorRange(srcPos, extraExclusions)
    local ret = self:SearchTarget(srcPos, extraExclusions)
    return ret or self:SearchTargetIgnoreRange(srcPos, extraExclusions)
end

function Skill:IsTargetInRange(target)
    if target then
        if self.meta.actionType == SkillActionType.Buff or self.meta.actionType == SkillActionType.Halo then
            for k,v in pairs(target) do
                local sqrDistance=Vector3.SqrMagnitude(self.owner:GetPosition()-v:GetPosition())
                if sqrDistance>self.attackRangeSquare then
                    return false
                end
            end
            return true
        else
            local sqrDistance=Vector3.SqrMagnitude(self.owner:GetPosition()-target:GetPosition())
            return sqrDistance<self.attackRangeSquare
        end
    else
        return false
    end
end

--公共方法
--释放技能
function Skill:Cast(target, isFake)--isFake会跳过RealFire()
    self.target=target or self:SearchTarget()
    self.isFake=isFake
    if self.meta.actionType == SkillActionType.Halo then
        self:RealFire()
    else
        --计算cd（攻击间隔）
        local attackSpeedAddRate = 0
        if self.owner ~= nil and type(self.owner.GetProperty) == 'function' then
            if self.meta.is_normal_attack then
                --攻击间隔=配置的间隔/（1+攻速提升75650）
                attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllAttackSpeedAddRate)
            else
                --技能cd=配置的cd/（1+cd提升75750）
                attackSpeedAddRate = self.owner:GetProperty(HeroEffectDefine.AllCdReduceRate)
            end
            if self.owner.hero ~= nil then
                attackSpeedAddRate = attackSpeedAddRate + DataCenter.LWBattleManager.logic.stageEffectMgr:Get(StageEffectType.AttackSpeed)
            end
            attackSpeedAddRate=math.max(-0.5,attackSpeedAddRate)
        end
        self.attackInterval = self.attack_interval/(1+attackSpeedAddRate)--cd（攻击间隔）
        self.realFireDelay = self.effectMeta.fire_delay--前摇时长
    
        self.cd = self.attackInterval
        self.remainCount = self.cast_count - 1 --剩余释放波次
    
        if self.meta.apType == SkillAPType.Active then
            if (self.owner.anim or self.owner.animator) and self.hasAnim then--有施法动画的主动技能，播放动画，前摇动画播完时创建子弹
                self:PlayCastAnim()
            else--无施法动画的主动技能，直接创建子弹
                self:Fire()
                if self.remainCount < 1 then
                    self.skillMgr.castingActiveSkill=nil
                else
                    self.timerReFire = self.cast_interval --下一波倒计时
                end
            end
        else--被动技能，没有施法动画，直接创建子弹
            self:Fire()

            if self.remainCount > 0 then
                self.timerReFire = self.cast_interval --下一波倒计时
            end
        end
    end

    if self.meta.buff_condition==BulletBuffType.OnCastToCaster then
        self:AddBuffImp(self.owner)
    end
    
    if self.owner.hero and not self.meta.is_normal_attack then
        local tbl = {}
        tbl.heroId = self.owner.hero.heroId
        tbl.icon = self.meta.icon
        EventManager:GetInstance():Broadcast(EventId.PveHeroUseSkill, tbl)
    end
    self.castTime = self.castTime + 1
end


--私有方法
--播放施法动画
function Skill:PlayCastAnim()
    local realAnimLength=0
    if not self.animLength then
        if self.meta.animation_time > 0 then
            self.animLength = self.meta.animation_time
        else
            self.animLength = self.owner:GetAnimLength(self.anim_normal)
        end
    end
    if self.animLength <= self.attackInterval then--动画长度小于攻击间隔，1倍速播放动画，前摇时间走配置
        self.animSpeed = 1
        self.realFireDelay = self.effectMeta.fire_delay
        realAnimLength = self.animLength
    else--动画长度大于攻击间隔，加速播放动画。相应的，前摇时间也要同比例缩短
        self.animSpeed = self.animLength / self.attackInterval
        self.realFireDelay = self.effectMeta.fire_delay / self.animSpeed
        realAnimLength = self.attackInterval
    end

    if self.owner:IsMoving() then
        --self.owner:CrossFadeSimpleAnim(AnimName.AttackMove,1,0.2)
        self.owner:RewindAndPlaySimpleAnim(self.anim_move, 1)
        --self.owner:PlaySimpleAnim(self.anim_move, 1)
    else
        --self.owner:CrossFadeSimpleAnim(AnimName.Attack,self.animSpeed,0.2)
        self.owner:RewindAndPlaySimpleAnim(self.anim_normal, self.animSpeed)
    end

    
    --施法流程：
    --如果是持续施法型技能：前摇动画-开火（0秒）-持续吟唱n秒-后摇（0秒）
    --如果是单次施法型技能：前摇动画-开火（0秒）-后摇动画
    self.state = SkillCastState.FrontSwing
    --前摇结束倒计时：施法前摇动画结束时，播放开火特效，生成子弹
    self.timerFire=self.realFireDelay
    --后摇结束倒计时：施法后摇动画结束时，施法结束，通知技能管理器
    self.timerFinish=math.max(realAnimLength,self.realFireDelay)
    if self.chantTime then
        self.timerFinish=math.max(self.timerFinish,self.chantTime)
    end
end

--私有方法
--重新播放施法动画（技能的其他波次）
function Skill:RePlayCastAnim()
    local realAnimLength=0
    if not self.animLength then
        if self.meta.animation_time > 0 then
            self.animLength = self.meta.animation_time
        else
            self.animLength = self.owner:GetAnimLength(self.anim_normal)
        end
    end
    if self.animLength <= self.attackInterval then--动画长度小于攻击间隔，1倍速播放动画，前摇时间走配置
        self.animSpeed = 1
        self.realFireDelay = self.effectMeta.fire_delay
        realAnimLength = self.animLength
    else--动画长度大于攻击间隔，加速播放动画。相应的，前摇时间也要同比例缩短
        self.animSpeed = self.animLength / self.attackInterval
        self.realFireDelay = self.effectMeta.fire_delay / self.animSpeed
        realAnimLength = self.attackInterval
    end

    if self.owner:IsMoving() then
        --self.owner:CrossFadeSimpleAnim(AnimName.AttackMove,1,0.2)
        self.owner:RewindAndPlaySimpleAnim(self.anim_move, 1)
    else
        --self.owner:CrossFadeSimpleAnim(AnimName.Attack,self.animSpeed,0.2)
        self.owner:RewindAndPlaySimpleAnim(self.anim_normal, self.animSpeed)
    end


    --施法流程：
    --如果是持续施法型技能：前摇动画-开火（0秒）-持续吟唱n秒-后摇（0秒）
    --如果是单次施法型技能：前摇动画-开火（0秒）-后摇动画
    --后续波次内播放施法动作，不改变状态
    --self.state = SkillCastState.FrontSwing
    --前摇结束倒计时：施法前摇动画结束时，播放开火特效，生成子弹
    self.timerFire=self.realFireDelay
    --后摇结束倒计时：施法后摇动画结束时，施法结束，通知技能管理器
    self.timerFinish=math.max(realAnimLength,self.realFireDelay)
    if self.chantTime then
        self.timerFinish=math.max(self.timerFinish,self.chantTime)
    end
end


--私有方法
--播放开火特效，生成子弹/buff
function Skill:Fire()
    self.state = self.chantTime and SkillCastState.Chant or SkillCastState.BackSwing
    
    --if self.meta.type~=SkillType.PassiveDeath then--主动技能公cd
    --    self.skillMgr:SetPublicCD(self.realFireDelay)
    --end
    
    self.cd = self.attackInterval - self.realFireDelay
    local firePoint=self.owner:GetFirePoint()
    --开火特效
    self.battleMgr:ShowEffectObj(self.effectMeta.fire_effect,nil,Quaternion.identity,self.effectMeta.fire_effect_time,firePoint)
    self.battleMgr:ShowEffectObj(self.effectMeta.cast_effect,self.owner:GetPosition(),Quaternion.identity,self.effectMeta.cast_effect_time)
    --震屏
    if self.effectMeta.fireShakeParam then
        --self.battleMgr:ShakeCameraWithParam(self.effectMeta.fireShakeParam)
    end
    --音效
    local audio = self.effectMeta.fire_audio:GetRandom()
    if audio then
        self.soundUid = DataCenter.LWSoundManager:PlaySoundByAssetName(audio,self.chantTime)
    end
    --生成子弹/buff
    self:RealFire()
end


--私有方法
--重新播放开火特效，生成子弹/buff（技能的其他波次）
function Skill:ReFire()
    --不影响状态
    --self.state = self.chantTime and SkillCastState.Chant or SkillCastState.BackSwing

    --if self.meta.type~=SkillType.PassiveDeath then--主动技能公cd
    --    self.skillMgr:SetPublicCD(self.realFireDelay)
    --end

    --不重置cd
    --self.cd = self.attackInterval - self.realFireDelay
    local firePoint=self.owner:GetFirePoint()
    --开火特效
    self.battleMgr:ShowEffectObj(self.effectMeta.fire_effect,nil,Quaternion.identity,self.effectMeta.fire_effect_time,firePoint)
    self.battleMgr:ShowEffectObj(self.effectMeta.cast_effect,self.owner:GetPosition(),Quaternion.identity,self.effectMeta.cast_effect_time)
    --震屏
    if self.effectMeta.fireShakeParam then
        --self.battleMgr:ShakeCameraWithParam(self.effectMeta.fireShakeParam)
    end
    --音效
    local audio = self.effectMeta.fire_audio:GetRandom()
    if audio then
        self.soundUid = DataCenter.LWSoundManager:PlaySoundByAssetName(audio,self.chantTime)
    end
    --生成子弹/buff
    self:RealFire()
end


--生成子弹/buff
function Skill:RealFire()
    if self.isFake then
        return
    end
    if self.meta.actionType==SkillActionType.Bullet then--技能生成子弹
        self.battleMgr.bulletManager:CreateBulletCreator(self.bulletId,self,{target=self.target})
    elseif self.meta.actionType==SkillActionType.Buff then--技能生成buff
        if self.target then
            for _,target in pairs(self.target) do
                self:AddBuffImp(target)
            end
            --local meta = DataCenter.LWBuffTemplateManager:GetTemplate(self.buff)
            --if meta.type==BuffType.Property then--属性变化
            --    for _,target in pairs(self.target) do
            --        target:AddBuff(self.buff,self.level)
            --    end
            --elseif meta.type==BuffType.BeTaunt then--被嘲讽
            --    for _,target in pairs(self.target) do
            --        target:AddBuff(self.buff,self.owner)
            --    end
            --elseif meta.type==BuffType.Shield then --加护盾
            --    for _,target in pairs(self.target) do
            --        target:AddBuff(self.buff,self.owner)
            --    end
            --end
        end
        if self.subSkills then
            for k,v in pairs(self.subSkills) do
                v:SetTarget(v:SearchTarget())
                v:RealFire()
            end
        end
    elseif self.meta.actionType==SkillActionType.Halo then--技能生成Halo
        if self.target then
            for _,target in pairs(self.target) do
                local propertyDic = self.meta:GetPropertyDictByLevel(self.level)
                target:AddHaloBuff(string.format("%s/%s",self.owner:GetGuid(),self.meta.id),propertyDic,self.meta.id)
            end
        end
    elseif self.meta.actionType==SkillActionType.Summon then--技能生成单位
        if self.owner and self.owner.unitType and self.battleMgr.SummonMonster then
            self.battleMgr:SummonMonster(self.owner:GetPosition(), self.owner, self.meta.actionParam[1], self.meta.actionParam[2], self.meta.actionParam[3])
        end
    end

    self.skillMgr:PassiveCast(SkillTriggerType.Cast,self.meta.group)
end

--给目标施加buff
function Skill:AddBuffImp(target)
    if self.buffMeta == nil then
        return
    end

    if self.buffMeta.type==BuffType.Property then--属性变化
        target:AddBuff(self.buff, self.level)
    elseif self.buffMeta.type==BuffType.BeTaunt then--被嘲讽
        target:AddBuff(self.buff, self.owner)
    elseif self.buffMeta.type==BuffType.Shield then --加护盾
        target:AddBuff(self.buff, self.owner)
    else
        target:AddBuff(self.buff)
    end
end

function Skill:GetCurAndMaxCD()--返回剩余冷却时间和最大冷却时间
    return math.max(self.cd,0),self.attackInterval
end

--buff型技能，不用瞄准、目标是个table
function Skill:IsBuffSkill()
    return self.meta.actionType==SkillActionType.Buff
end 

--是否是主动技
function Skill:IsActiveSkill()
    return self.meta.apType == SkillAPType.Active
end

--buff型子弹给目标挂buff
function Skill:DealBulletBuff(defender)
    if self.meta.buff_condition==BulletBuffType.None then
        return
    elseif self.meta.buff_condition==BulletBuffType.OnHit then
        if defender:GetCurBlood()>0 then
            if self.meta.buff_param==HeroType.All or self.meta.buff_param==defender:GetHeroCamp() then
                self:AddBuffImp(defender)
            end
        end
    elseif self.meta.buff_condition==BulletBuffType.OnHitByChance then
        if defender:GetCurBlood()>0 then
            if math.random()<self.meta.buff_param*0.01 then
                self:AddBuffImp(defender)
            end
        end
    elseif self.meta.buff_condition==BulletBuffType.OnKill then
        if defender:GetCurBlood()<=0 then
            self:AddBuffImp(self.owner)
        end
    end
end


function Skill:IsNormalAttack()
    return self.meta.is_normal_attack
end

function Skill:RegisterChantBullet(bulletUid,destroyCB)
    if self.chantBullet then
        self.chantBullet[bulletUid]=destroyCB
    end
end

function Skill:UnregisterChantBullet(bulletUid)
    if self.chantBullet then
        self.chantBullet[bulletUid]=nil
    end
end

function Skill:Redirect(srcPos, extraExclusions, legalizeTarget)
    if not self.battleMgr then
        return nil
    end
    if self.battleMgr:GetPVEType()==PVEType.Skirmish or
            self.battleMgr:GetPVEType()==PVEType.FakePVP then
        if self.redirectTargets and #self.redirectTargets>0 then
            self.target = table.remove(self.redirectTargets)
        end
    else
        self.target = self:SearchTargetPriorRange(srcPos, extraExclusions)
        if legalizeTarget then
            self.target = self:LegalizeTarget(self.target)
        end
    end
    return self.target
end

function Skill:SetTarget(target)
    self.target = target
end

--目标合法化（将目标限制在射程内，如果传入坐标，返回一定是坐标；如果传入单位，射程内返回单位，射程外返回坐标；如果传入nil，返回正前方射程内随机坐标）
function Skill:LegalizeTarget(target)
    if not target then
        return self.owner:GetPosition() + Vector3.New(0,0,self.attackRange * math.random())
    end

    if self.meta.actionType==SkillActionType.Bullet then--子弹型技能
        if self.bulletMeta and (not self.bulletMeta.hasRangeLimit) then--无射程限制的子弹
            return target
        end
    end
    
    local targetPos = target.unitType and target:GetPosition() or target
    local displace=targetPos-self.owner:GetPosition()
    local sqrDistance=Vector3.SqrMagnitude(displace)
    if sqrDistance>self.attackRangeSquare then
        local direction=Vector3.Normalize(displace)
        targetPos=self.owner:GetPosition() + direction * self.attackRange * math.random()
        return targetPos
    else
        return target
    end
end

--返回射程内距离准星最近的目标
function Skill:SearchTargetAroundAim(pos)
    if self.meta.actionType~=SkillActionType.Bullet or (not self.bulletMeta) then
        return pos
    end
    if self.bulletMeta.mvt_type == BulletMoveType.Parabola and (not self.bulletMeta.is_following) then
        return self:LegalizeTarget(pos)--非指向性抛物线
    end
    if not self.bulletMeta.is_following then
        return pos
    end
    --指向型子弹
    if self.targetSelfExcludeAlly then
        return self.owner
    end
    
    local displace=pos-self.owner:GetPosition()
    local direction=Vector3.Normalize(displace)
    local midPoint=direction * 0.5 * self.meta.attack_range
    local unit=PveUtil.FindNearestUnitInSphereRange(self.battleMgr
    ,midPoint,0.5*self.meta.attack_range,self.targetLayerMask,nil,pos)
    if unit then
        return unit
    else
        return self:LegalizeTarget(pos)
    end
end

--返回距离准星最近的目标(忽略射程限制)
function Skill:SearchTargetAroundAimIgnoreRange(pos)
    if self.meta.actionType~=SkillActionType.Bullet or (not self.bulletMeta) then
        return pos
    end
    if not self.bulletMeta.is_following then
        return pos
    end
    --指向型子弹
    if self.targetSelfExcludeAlly then
        return self.owner
    end
    
    local midPoint = (pos + self.owner:GetPosition()) * 0.5
    local unit=PveUtil.FindNearestUnitInSphereRange(self.battleMgr
    ,midPoint,0.5*self.meta.attack_range,self.targetLayerMask,nil,pos)
    if unit then
        return unit
    else
        return pos
    end
end


function Skill:GetState()
    return self.state--SkillCastState
end

function Skill:ResetCooldown()
    self.cd = 0
    self.state = SkillCastState.Ready
end

--强制把子弹改为追踪型
--function Skill:ForceFollowing(bool)
--    self.forceFollowing = bool
--end

--强制设置子弹寿命
function Skill:ForceLifeTime(distance)
    self.forceLifeTime = distance * self.meta.horizontal_slowness
end

--设置重定向目标
function Skill:SetRedirectTarget(redirectTargets)
    self.redirectTargets = redirectTargets
end

function Skill:IsUltimate()
    return self.isUltimate
end


function Skill:CreateBullet(target)
    self.target = target
    self.battleMgr.bulletManager:CreateBulletCreator(self.bulletId,self,{target=target})
end

function Skill:GetBulletDamageFactor(bulletIndex)
    if self.damage and self.damage[bulletIndex] then
        return self.damage[bulletIndex]
    end
    return 0
end

-- 无人机大世界技能释放
function Skill:TWRealFire()
    -- self.state = self.chantTime and SkillCastState.Chant or SkillCastState.BackSwing
    -- self.cd = self.attackInterval - self.realFireDelay
    local firePoint=self.owner:GetFirePoint()
    --开火特效
    self.battleMgr:ShowEffectObj(self.effectMeta.fire_effect,nil,Quaternion.identity,self.effectMeta.fire_effect_time,firePoint)
    self.battleMgr:ShowEffectObj(self.effectMeta.cast_effect,self.owner:GetPosition(),Quaternion.identity,self.effectMeta.cast_effect_time)

    --生成子弹/buff
    self:RealFire()
end


return Skill
