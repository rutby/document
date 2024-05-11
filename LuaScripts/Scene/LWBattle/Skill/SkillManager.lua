---
--- PVE 技能组，一个单位的所有技能
---

---@class Scene.LWBattle.Skill.SkillManager
local SkillManager = BaseClass("SkillManager")
local Skill = require("Scene.LWBattle.Skill.Skill")


function SkillManager:__init(logic,owner)
    self.battleMgr = logic
    self.owner = owner
    --公CD，只有主动技能有公cd
    --self.publicCD=0
    --正在施放的主动技能
    self.castingActiveSkill=nil
    --所有技能
    self.skills = {}---@type table<number,Scene.LWBattle.Skill.Skill>
    self.metaId2skills = {}
    --所有主动技能:包括子弹型和buff型两种
    self.activeSkills = {}---@type table<number,Scene.LWBattle.Skill.Skill>
    --所有光环技能
    self.haloSkills = {}---@type table<number,Scene.LWBattle.Skill.Skill>
    --所有被动技能，按照触发条件分类存放
    self.passiveSkillsByCondition = {}
    --大招
    self.ultimateSkill = nil
    --回收站
    self.toDeleteSkills = {}---@type table<number,Scene.LWBattle.Skill.Skill>
    self.skillCount = 0
end

function SkillManager:__delete()
    self:DestroyView()
    self:DestroyData()
end

function SkillManager:DestroyView()
    self:Interrupt()
    for _,skill in pairs(self.skills) do
        table.insert(self.toDeleteSkills,skill)
    end
    self.metaId2skills = {}
    self.skills = {}
    self.haloSkills = {}
    self.haloCD = nil
end

function SkillManager:DestroyData()
    for _,skill in pairs(self.toDeleteSkills) do
        skill:Destroy()
    end
    self.skills = {}
    self.metaId2skills = {}
    self.activeSkills = {}
    self.haloSkills = {}
    self.passiveSkillsByCondition = {}
    self.ultimateSkill = nil
    self.toDeleteSkills = {}
    self.battleMgr=nil
    self.owner=nil
    --self.publicCD=0
    self.castingActiveSkill=nil
    self.haloCD = nil
end

--region 对外接口

--添加技能
---@param skillMeta HeroSkillTemplate
---@param skillInfo SkillInfo
function SkillManager:AddSkill(skillMeta,skillInfo,isUltimate,isWorldTroopEffect)
    local meta = skillMeta
    if not meta then
        Logger.LogError("添加技能时，技能配置找不到,单位："..self.owner.gameObject.name..",英雄/怪物id:"..self.owner.meta.id)
        return
    end
    if meta.triggerType == SkillTriggerType.IdleOutside or meta.triggerType == SkillTriggerType.AlwaysOutside then--忽略战斗外技能
        return
    end
    ---@type Scene.LWBattle.Skill.Skill
    local newSkill=Skill.New(self.battleMgr,self,self.owner,meta,skillInfo,isUltimate)
    if isWorldTroopEffect == true then
        -- 世界行军的特效需要用不一样的参数，为了不影响别的逻辑，专门在这里切换一下参数
        newSkill:SwitchToWorldTroopEffect()
    end
    table.insert(self.skills,newSkill)
    self.skillCount = #self.skills
    self.metaId2skills[meta.id]=newSkill
    --技能按照施放逻辑分为4类：手动控制释放时机的"大招"、AI托管的"主动技能"、修改作用号的"光环技能"、一定条件下触发的"被动技能"
    if isUltimate then
        self.ultimateSkill = newSkill
    elseif meta.apType==SkillAPType.Active then
        self:AddActiveSkill(meta,newSkill)
    elseif meta.actionType == SkillActionType.Halo then
        self:AddHaloSkill(meta,newSkill)
    else
        self:AddPassiveSkill(meta,newSkill)
    end
    return newSkill
end


--准备施放大招
function SkillManager:PrepareCastUltimate()
    if self.ultimateSkill then
        if self.ultimateSkill.cd<=0 then
            self:Interrupt()--打断自己
            return self.ultimateSkill
        end
    end
    return nil
end

--检查大招是否可以释放
function SkillManager:CheckUltimate()
    if self.ultimateSkill then
        if self.ultimateSkill.cd<=0 then
            if self.ultimateSkill:CheckCondition() then
                return self.ultimateSkill
            end
        end
    end
    return nil
end

function SkillManager:GetUltimateTimeStopDuration()
    if self.ultimateSkill then
        return self.ultimateSkill.meta.time_stop_duration>0 and self.ultimateSkill.meta.time_stop_duration or TIME_STOP_DURATION
    end
    return 0
end


--施放主动技能
---@param skill Scene.LWBattle.Skill.Skill
function SkillManager:ActiveCast(skill,target,isFake)
    if skill.meta.apType==SkillAPType.Passive then
        Logger.LogError("此方法用来施放主动技能，被动技能请使用PassiveCast()")
        return
    end
    self.castingActiveSkill=skill
    skill:Cast(target,isFake)
end

--施放被动技能：传入一个触发条件，触发所有满足条件的被动技能
function SkillManager:PassiveCast(triggerType,param)
    if self.passiveSkillsByCondition[triggerType] then
        for _,skill in pairs(self.passiveSkillsByCondition[triggerType]) do
            if skill.cd<=0 and skill:CheckTriggerParam(triggerType,param) then
                skill:Cast()
            end
        end
    end
end

--中断施法
function SkillManager:Interrupt()
    if self.castingActiveSkill then
        self.castingActiveSkill:Interrupt()
        self.castingActiveSkill=nil
    end
end

--获取大招
function SkillManager:GetUltimateSkill()
    return self.ultimateSkill
end

--获取所有主动技能
function SkillManager:GetAllActiveSkills()
    return self.activeSkills
end

--获取剩余公共cd
--function SkillManager:GetPublicCD()
--    return self.publicCD
--end

--获取正在施放的主动技能
function SkillManager:GetCastingSkill()
    return self.castingActiveSkill
end

--获取一个可以施放的主动技能，忽略射程限制
--返回技能
function SkillManager:GetActiveSkillIgnoreRange()
    --if self.publicCD>0 then
    --    return nil
    --end
    if self.castingActiveSkill then
        return nil
    end
    for _,skill in ipairs(self.activeSkills) do
        if skill.cd<=0 then
            return skill
        end
    end
    return nil
end

function SkillManager:GetFirstActiveSkill()
    local skills = self.activeSkills
    if skills ~= nil and #skills > 0 then
        return skills[1]
    end
    return nil
end

--获取一个可以施放的主动技能
--返回技能
function SkillManager:GetActiveSkill()
    --if self.publicCD>0 then
    --    return nil
    --end
    if self.castingActiveSkill then
        return nil
    end
    for _,skill in ipairs(self.activeSkills) do
        if skill.cd<=0 then
            if skill:CheckCondition() then
                return skill
            end
        end
    end
    return nil
end



--移除所有技能
function SkillManager:RemoveAllSkills()
    self:Interrupt()
    self.skills = {}
    self.metaId2skills = {}
    self.activeSkills = {}
    self.passiveSkillsByCondition = {}
    self.ultimateSkill = nil
    self.haloSkills = {}
    self.toDeleteSkills = {}
end

--是否拥有技能
function SkillManager:HasSkill(skillId)
    return self.metaId2skills[skillId]
end

function SkillManager:GetSkillById(skillId)
    return self.metaId2skills[skillId]
end

--重置技能冷却（刷新球）
function SkillManager:ResetCooldown(skill)
    skill:ResetCooldown()
end

function SkillManager:SetUnlock(skill)
    skill.lock=false
end


--endregion




--region 内部方法（被SkillManager类或Skill类调用）

--施放所有光环技能
---@param skill Scene.LWBattle.Skill.Skill
function SkillManager:HaloCastAll()
    for _,skill in pairs(self.haloSkills) do
        skill:Cast()
    end
end


function SkillManager:OnUpdate()
    for i = 1, self.skillCount do
        self.skills[i]:OnUpdate()
    end
    --self.publicCD=self.publicCD-Time.deltaTime

    --光环是技能的一种，该技能会每x秒搜索一次目标，对所有目标添加一个持续y秒（y>x）的作用号buff
    --考虑到目前只有影响队友的光环，不存在进出光环的问题，x和y都取正无穷以节省刷新
    --来自于同一个光环的buff会刷新持续时间，同名的不同光环的buff互相叠加
    --每HALO_SKILL_CD秒检查一下光环
    --if self.haloCD then
    --    self.haloCD = self.haloCD - Time.deltaTime
    --    if self.haloCD<=0 then
    --        for _,skill in pairs(self.haloSkills) do
    --            skill:Cast(skill:SearchTarget())
    --        end
    --        self.haloCD = HALO_SKILL_CD
    --    end
    --end
end



--添加光环技能
---@param newSkill Scene.LWBattle.Skill.Skill
function SkillManager:AddHaloSkill(meta,newSkill)
    self.haloCD = 0
    table.insert(self.haloSkills,newSkill)
    newSkill:Cast()
end


--添加主动技能，并按优先级排序
function SkillManager:AddActiveSkill(meta,newSkill)
    for i,skill in ipairs(self.activeSkills) do
        if meta.priority > skill.meta.priority then
            table.insert(self.activeSkills,i,newSkill)
            return
        end
    end
    table.insert(self.activeSkills,newSkill)
end

--添加被动技能
function SkillManager:AddPassiveSkill(meta,newSkill)
    if not self.passiveSkillsByCondition[meta.triggerType] then
        self.passiveSkillsByCondition[meta.triggerType]={}
    end
    table.insert(self.passiveSkillsByCondition[meta.triggerType],newSkill)
end

--将普攻技能替换为新技能
---@param skillMeta HeroSkillTemplate
---@param skillInfo SkillInfo
---@return boolean 是否替换成功
function SkillManager:ReplaceNormalAttack(skillMeta,skillInfo)

    local skills = self.activeSkills
    if skills == nil then
        return false
    end

    if #skills == 0 then
        return false
    end
    
    local normalAttackSkill = nil
    local normalAttackSkillIndex = 0
    
    for i,skill in ipairs(self.activeSkills) do
        if skill.meta.is_normal_attack then
            --普攻技能
            normalAttackSkill = skill
            normalAttackSkillIndex = i
            break
        end
    end

    if normalAttackSkillIndex == 0 or normalAttackSkill == nil then
        --没找到普攻技能
        return false
    end
    
    table.remove(self.activeSkills, normalAttackSkillIndex)
    table.removebyvalue(self.skills, normalAttackSkill)
    self.skillCount = #self.skills
    self.metaId2skills[normalAttackSkill.meta.id] = nil
    if self.ultimateSkill == normalAttackSkill then
        self.ultimateSkill = nil
    end

    if normalAttackSkill == self.castingActiveSkill then
        --中断施法
        self:Interrupt()
    end
    
    self:AddSkill(skillMeta, skillInfo)
    
    return true
end

--实际公cd=理论公cd-前摇时长
--function SkillManager:SetPublicCD(fix)
--    self.publicCD=SKILL_PUBLIC_CD-fix
--end

--endregion



return SkillManager