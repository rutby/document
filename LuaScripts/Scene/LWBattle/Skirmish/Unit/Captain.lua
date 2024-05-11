---
---Captain 队长
---
local base = require("Scene.LWBattle.Skirmish.Unit.SkirmishUnit")
---@class Scene.LWBattle.Skirmish.Unit.Captain : Scene.LWBattle.Skirmish.Unit.SkirmishUnit
local Captain = BaseClass("Captain",base)
local Localization = CS.GameEntry.Localization
--攻击状态之瞄准(英雄专用）
local FireStateAim=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateAim")
--攻击状态之施法(英雄专用）
local FireStateCasting=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateCasting")
local Const = require("Scene.LWBattle.Const")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local Resource = CS.GameEntry.Resource
local DelayHpBarCell = require "DataCenter.ZombieBattle.HpBar.DelayHpBarCell"
local TinyHead = require "DataCenter.ZombieBattle.HpBar.TinyHead"
local HP_BAR_OFFSET = { [1]=-1.5,[2]=-1.2 }


function Captain:Init(logic,platoon,heroData,localPos,index)--heroData是mail里的Hero数据
    base.Init(self,logic,platoon,heroData,localPos,index)
    self.hero = HeroInfo.New()
    self.hero:UpdateFromMailData(heroData.heroId,heroData.heroLevel,heroData.skillInfos)
    self.meta = self.hero.meta
    self.isHuman = self.meta.is_human
    self.unitType = index<=5 and UnitType.Member or UnitType.Zombie
    local path = self.hero.appearanceMeta.model_path
    self.heroEffectMeta=DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
    self.maxBlood = heroData.maxHp
    self.initBlood = heroData.initHp
    self.curBlood = self.initBlood
    self.totalHurt = 0
    --Logger.Log(self.index.."号初始血量red="..heroData.initHp.."，最大血量maxHp="..heroData.maxHp)
    self.skillManager = SkillManager.New(self.logic,self)---@type Scene.LWBattle.Skill.SkillManager
    
    self.req = Resource:InstantiateAsync(path)
    self.req:completed('+', function(request)
        self.gameObject = request.gameObject
        self.transform = request.gameObject.transform
        --self.gameObject.name = self.hero.heroId.. "Captain_"..self.gameObject.name
        self.transform:SetParent(self.platoon.transform)
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.transform:Set_localPosition(self.localPosition.x,self.localPosition.y,self.localPosition.z)
        self:ComponentDefine()
        self:InitFSM()
        self.hpBar = DelayHpBarCell.New(Const.HPBarStyle.Self,self.transform,HP_BAR_OFFSET[self.platoon.army.index])
        self.hpBar:LoadAndSetHp(self.curBlood/self.maxBlood)
        self.tinyHead = TinyHead.New(self.transform,HP_BAR_OFFSET[self.platoon.army.index])
        self.tinyHead:LoadAndSetHead(HeroUtils.GetHeroIconPath(self.meta.appearance))
        local appearanceMeta=self.hero.appearanceMeta
        --设置大小
        self.transform:Set_localScale(appearanceMeta.model_size,appearanceMeta.model_size,appearanceMeta.model_size)
        local fire_path = appearanceMeta.fire_path
        self.firePoint = self.transform:Find(fire_path)
        if not self.firePoint or string.IsNullOrEmpty(fire_path) then
            Logger.LogError("开火点路径配置错误，路径不应包含预制体名，外观id："..self.hero.modelId.."，开火点路径："..fire_path)
        else
            self.firePointOffset = Vector3.HorizonDistance(self.firePoint.position,self.transform.position)--开火点到中心点距离
        end
        if self.isHuman then
            self.cannon = self.transform
        else
            local canon_path = appearanceMeta.canon_path
            self.cannon=self.transform:Find(canon_path)
            if not self.cannon or string.IsNullOrEmpty(canon_path) then
                Logger.LogError("炮台路径配置错误，注意路径不应包含预制体名，外观id："..self.hero.modelId.."，prefab路径："..path.."，炮台路径："..canon_path)
            else
                self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            end
            local canonFix = appearanceMeta.canon_rotation--炮台旋转修正
            if canonFix and #canonFix==3 then--存在修正
                self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1],canonFix[2],canonFix[3])
            end
        end
        self.angular_speed_deg=self.meta.angular_speed * 60
        self:InitSkill()
    end)
end



function Captain:ComponentDefine()
    base.ComponentDefine(self)
    --PveUtil.SetLayerRecursively(self.gameObject,"Default")
    if self.index<=5 then--上方玩家扮演丧尸
        self.collider.gameObject.layer=LayerMask.NameToLayer("Member")
    else
        self.collider.gameObject.layer=LayerMask.NameToLayer("Zombie")
    end
end


function Captain:InitFSM()
    base.InitFSM(self)
    --攻击状态机
    self.fsm:AddState(SkirmishFireState.Aim,FireStateAim.New(self))
    self.fsm:AddState(SkirmishFireState.Casting,FireStateCasting.New(self))
end

function Captain:InitSkill()
    local skillInfos=self.hero:GetAllUnlockSkillsExcludeUltimate()
    for _,skillInfo in pairs(skillInfos) do
        if skillInfo.skillTemplateData == nil then
            Logger.LogError("添加技能时，技能配置找不到,技能Id："..skillInfo.id)
        end
        self.skillManager:AddSkill(skillInfo.skillTemplateData,skillInfo)
    end
    local skillInfo=self.hero:GetUltimateSkill()
    if skillInfo then
        self.skillManager:AddSkill(skillInfo.skillTemplateData,skillInfo,true)
    end
end


function Captain:OnUpdate()
    base.OnUpdate(self)
    if self.skillManager and self.logic.stage==SkirmishStage.Fight then
        self.skillManager:OnUpdate()
    end
    if self.hpBar then
        self.hpBar:Update()
    end
    if self.tinyHead then
        self.tinyHead:Update()
    end
end

function Captain:DestroyView()
    base.DestroyView(self)
    if self.hpBar then
        self.hpBar:Destroy()
        self.hpBar = nil
    end
    if self.tinyHead then
        self.tinyHead:Destroy()
        self.tinyHead = nil
    end
    if self.cannon then
        self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    if self.skillManager then
        self.skillManager:DestroyView()
    end
end

function Captain:DestroyData()
    self.hero = nil
    self.meta = nil
    self.isHuman = nil
    self.cannon = nil
    self.angular_speed_deg = nil
    if self.skillManager then
        self.skillManager:DestroyData()
        self.skillManager = nil
    end
    base.DestroyData(self)
end

--function Captain:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
--
--    base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
--end
--
--function Captain:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
--
--    base.AfterBeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
--end

function Captain:GetRawProperty(type)
    return self.heroData.effect[type] or 0
end

function Captain:DoAction(action,param)
    if action.phase==ActionPhase.Cast then
        local skill = self.skillManager:GetSkillById(action.skillId)
        if not skill then
            Logger.LogError(self.index.."号位".."英雄"..self.hero.heroId.."没有技能"..action.skillId)
            return
        end
        if skill:IsBuffSkill() then--Buff类技能，不用瞄准直接开火
            local targets = {}
            for _,v in pairs(action.targets) do
                table.insert(targets,self.logic:GetCaptain(v.index))
            end
            self.fsm:ChangeState(SkirmishFireState.Aim,skill,targets)
        elseif action.targets[1] then--子弹类技能，瞄准第一个目标，然后开火
            local target = self.logic:GetCaptain(action.targets[1].index)
            if target:GetCurBlood()<=0 then
                Logger.LogError("鞭尸了，故意对死人开火,index="..action.targets[1].index.."blood="..target:GetCurBlood())
                self.logic:ErrorAction(action)
            end
            --skill:ForceFollowing(#action.targets<=1)--对单时强制设为指向型技能
            skill:ForceLifeTime(self:GetCaptainDistance(action.targets[1].index))
            if action.targets[2] then--多目标
                local redirectTarget={}
                for i = #action.targets,2,-1 do
                    local unit = self.logic:GetCaptain(action.targets[i].index)
                    table.insert(redirectTarget,unit)
                end
                skill:SetRedirectTarget(redirectTarget)
            end
            self.fsm:ChangeState(SkirmishFireState.Aim,skill,target)
        end
        if self.index<=5 and DataCenter.HeroTemplateManager:IsUltimate(action.skillId) then
            EventManager:GetInstance():Broadcast(EventId.SkirmishCastUltimate,action)
        end
    elseif action.phase==ActionPhase.FIRE_BULLET then
        local skill = self.skillManager:GetSkillById(action.skillId)
        if not skill then
            Logger.LogError(self.index.."号位".."英雄"..self.hero.heroId.."没有技能"..action.skillId)
            return
        end
        local targetData = action.targets[1]
        if targetData then
            local target = self.logic:GetCaptain(targetData.index)
            if target:GetCurBlood()<=0 then
                Logger.LogError("鞭尸了，故意对死人开火,index="..targetData.index.."blood="..target:GetCurBlood())
                self.logic:ErrorAction(action)
            end
            skill:ForceLifeTime(self:GetCaptainDistance(targetData.index))
            skill:CreateBullet(target)
        end

    elseif action.phase==ActionPhase.Buff then
        local shieldChange = false
        for _,v in pairs(param.buffChanges) do
            local meta = DataCenter.LWBuffTemplateManager:GetTemplate(v.buffId)
            if meta.type==BuffType.Property then--属性变化
                self:AddBuff(v.buffId,v.skillLevel)
            elseif meta.type==BuffType.BeTaunt then--被嘲讽
                self:AddBuff(v.buffId,self.logic:GetCaptain(action.casterIndex))
            elseif meta.type==BuffType.Stun then--眩晕
                self.logic:ShowDamageText(Localization:GetString("stunned_effect"), self:GetPosition(), DamageTextType.GetBuff)
                self:AddBuff(v.buffId)
            elseif meta.type==BuffType.Shield then
                self:AddBuff(v.buffId,self.logic:GetCaptain(action.casterIndex))
                shieldChange = true
            else
                self:AddBuff(v.buffId)
            end
        end
        
        --有护盾buff，刷新下护盾显示
        if shieldChange then
            local shieldRemain = param.shieldTotal or 0 --剩余护盾总值
            local percent = self.curBlood/self.maxBlood
            local shieldPercent = shieldRemain / self.maxBlood
            if self.hpBar then
                self.hpBar:SetHp(percent, shieldPercent)
            end
        end
        
    elseif action.phase==ActionPhase.Damage then
        self:DoDamageAction(action,param)
    end
end

function Captain:DoDamageAction(action,target)
    local hurt = target.damageDouble==0 and target.damage or target.damageDouble
    local shieldAbsorbed = target.shieldChange or 0
    local shieldRemain = target.shieldTotal or 0 --剩余护盾总值
    local realHurt = math.max(hurt - shieldAbsorbed, 0) --真正扣血伤害
    self.totalHurt = self.totalHurt + hurt
    if self.curBlood <= 0 then
        return--死者为大，他都死了，就不要鞭尸了
    end
    if self.curBlood <= realHurt then
        self.bloodBeforeDie = self.curBlood--记一下临死前的血量，方便复活
    end
    self.curBlood = math.max(self.curBlood - realHurt, 0)
    local percent = self.curBlood/self.maxBlood
    local shieldPercent = shieldRemain / self.maxBlood
    if self.hpBar then
        self.hpBar:SetHp(percent, shieldPercent)
    end
    if self.curBlood <= 0 then
        self:GoDie()
    end
    self.platoon:OnCaptainTakeDamage(self.curBlood)
    if self.index<=5 then
        EventManager:GetInstance():Broadcast(EventId.SkirmishChangeHp,{self.index,percent})
    end

    --伤害跳字
    local damageTextType
    if target.miss>0 then
        damageTextType=DamageTextType.Miss
    elseif self:GetSubTypeBuffCount(BuffSubType.ReduceDamage)>0 then
        damageTextType=DamageTextType.ReduceDamageBuff
    elseif action.casterIndex>10 then--无人机
        damageTextType=DamageTextType.Drone
    elseif DataCenter.HeroTemplateManager:IsUltimate(action.skillId) then
        damageTextType=DamageTextType.HeroUltimate
    else
        damageTextType=DamageTextType.HeroNormalAttack
    end
    
    --伤害数字还飘原始伤害
    self.logic:ShowDamageText(hurt,self:GetPosition(),damageTextType,nil,target.crit>0)

    if shieldAbsorbed > 0 and shieldRemain <= 0 then
        --本次剩余护盾值为0，但护盾吸收值 > 0，认为是伤害破盾了，移除所有护盾buff
        self:RemoveAllShieldBuff()
    end
end

function Captain:UnDoAction(action,param)
    if action.phase==ActionPhase.Cast then

    elseif action.phase==ActionPhase.Damage then
        self:UnDoDamageAction(action,param)
    end
end

function Captain:UnDoDamageAction(action,target)
    --local target
    --for _,v in pairs(action.targets) do
    --    if v.index==self.index then
    --        target = v
    --        break
    --    end
    --end
    local hurt = target.damageDouble==0 and target.damage or target.damageDouble
    local shieldAbsorbed = target.shieldChange or 0
    local shieldRemain = target.shieldTotal or 0 --剩余护盾总值
    local realHurt = math.max(hurt - shieldAbsorbed, 0) --真正扣血伤害
    if realHurt > 0 then
        if self.curBlood <= 0 then
            self:Revive()
        else
            self.curBlood = self.curBlood + realHurt
        end
        local percent = self.curBlood/self.maxBlood
        local shieldPercent = shieldRemain / self.maxBlood
        if self.hpBar then
            self.hpBar:SetHp(percent, shieldPercent)
        end
        self.platoon:OnCaptainHeal(self.curBlood)
        if self.index<=5 then
            EventManager:GetInstance():Broadcast(EventId.SkirmishChangeHp,{self.index,percent})
        end
    elseif shieldAbsorbed > 0 then
        local percent = self.curBlood/self.maxBlood
        local shieldPercent = shieldRemain / self.maxBlood
        if self.hpBar then
            self.hpBar:SetHp(percent, shieldPercent)
        end
    end
end

function Captain:GoDie()
    base.GoDie(self)
    self.platoon.army:OnCaptainDie(self.index)
end

function Captain:Revive()
    base.Revive(self)
    self.platoon.army:OnCaptainRevive(self.index)
    if self.hpBar then
        self.hpBar:SetActive(true)
    end
end

function Captain:DestroyTinyHead()
    if self.tinyHead then
        self.tinyHead:Destroy()
        self.tinyHead = nil
    end
end

function Captain:ChangeStage(stage)
    base.ChangeStage(self,stage)
    if stage == SkirmishStage.Load then

    elseif stage == SkirmishStage.Opening then

    elseif stage == SkirmishStage.Fight then
        self:DestroyTinyHead()
    elseif stage == SkirmishStage.End then

    end
end

--返回开火点到目标中心的距离
function Captain:GetCaptainDistance(targetIndex)
    return self.sceneData:GetCaptainDistance(self.index,targetIndex)-self.firePointOffset
end

function Captain:GetPosition()
    if self.transform then
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()
        return self.curWorldPos
    else
        return self.platoon:GetPosition()
    end
end

return Captain
