---
---HeroUnit 英雄，继承自MemberUnit
---
local base = require("Scene.LWBattle.ParkourBattle.Team.MemberUnit")
---@class Scene.LWBattle.ParkourBattle.Team.HeroUnit : Scene.LWBattle.ParkourBattle.Team.MemberUnit
---@field hero HeroInfo
---@field skillManager Scene.LWBattle.Skill.SkillManager
local HeroUnit = BaseClass("HeroUnit",base)


local Resource = CS.GameEntry.Resource
local FSM=require("Framework.Common.FSM")
--准备状态
local StayState = require("Scene.LWBattle.ParkourBattle.Team.FSM.StayState")
--跑酷阶段，向正前方开火
local FireStateStraight=require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateStraight")
--跑酷塔防模式，向正前方开火
local FireStateDefenseStraight = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateDefenseStraight")
--boss阶段，自动瞄准
local FireStateAuto=require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
--退场阶段，不开火
local FireStateHold = require("Scene.LWBattle.ParkourBattle.Team.FSM.FireStateHold")
--英雄死亡动画状态
local HeroDieState = require("Scene.LWBattle.ParkourBattle.Team.FSM.HeroDieState")
local Const = require("Scene.LWBattle.Const")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local HPBarCell = require "DataCenter.ZombieBattle.HpBar.HpBarCell"
local SkillBarCell = require "DataCenter.ZombieBattle.HpBar.SkillBarCell"

local BarHeight = 3.5

function HeroUnit:Init(logic,team,parent,localPos,hero,forceIsHuman)
    base.Init(self,logic,team,parent,localPos)
    self.type = Const.ParkourUnitType.Hero
    self.meta = hero.meta
    
    Logger.Log("HeroUnit id : ".. self.meta.id)
    
    --local metaIsHuman = self.meta.is_human
    local metaIsHuman = true
    self.isHuman = forceIsHuman or metaIsHuman
    self.unitType = UnitType.Member
    local path = "Assets/Main/Prefabs/LWBattle/Hero/army_t1_01.prefab"
    if hero then
        path = hero.appearanceMeta.model_path
        self.appearanceMeta = hero.appearanceMeta
    end
    --self.heroEffectMeta=DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
    self:InitHeroData(hero)
    self.maxBlood = PveUtil.GetPveHeroHp(hero.heroId, hero.level, hero.curMilitaryRankId)
    self.curBlood = self.maxBlood

    self.req = Resource:InstantiateAsync(path)
    self.req:completed('+', function(request)
        self.gameObject = request.gameObject
        self.transform = request.gameObject.transform
        self.transform:SetParent(self.parent)
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
        self:ComponentDefine()
        self:InitFSM()
        self.hpBar = HPBarCell.New(Const.HPBarStyle.Self,self.transform,BarHeight)
        self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
        local appearanceMeta=hero.appearanceMeta
        --设置大小
        self.transform:Set_localScale(appearanceMeta.model_size,appearanceMeta.model_size,appearanceMeta.model_size)
        if DataCenter.LWBattleManager:UseNewDetect() then
            self.trigger:RefreshSize()
        end
        local fire_path = appearanceMeta.fire_path
        self.firePoint = self.transform:Find(fire_path)
        if not self.firePoint or string.IsNullOrEmpty(fire_path) then
            Logger.LogError("开火点路径配置错误，路径不应包含预制体名，外观id："..self.hero.modelId.."，开火点路径："..fire_path)
        end
        if metaIsHuman then
            self.cannon = self.transform
        else
            local canon_path = appearanceMeta.canon_path
            self.cannon=self.transform:Find(canon_path)
            if not self.cannon or string.IsNullOrEmpty(canon_path) then
                Logger.LogError("炮台路径配置错误，注意路径不应包含预制体名，外观id："..self.hero.modelId.."，炮台路径："..canon_path)
            else
                self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            end
            local canonFix = appearanceMeta.canon_rotation--炮台旋转修正
            if canonFix and #canonFix==3 then--存在修正
                self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1],canonFix[2],canonFix[3])
            end
        end
        self.angular_speed_deg = (self.meta.angular_speed or 20) * 60
        self:ShowBornEffect()
        self:InitSkill()
        self:TryReplaceSkill()
        if self.isExiting then
            self:StartExiting()
        end
    end)
    
    self.slot = 0
end

function HeroUnit:SetSlot(slot)
    self.slot = slot
end

function HeroUnit:ComponentDefine()
    base.ComponentDefine(self)
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self.shadowGo = self.transform:Find("Shadow").gameObject
    if DataCenter.LWBattleManager.qualityLevel <= EnumQualityLevel.Low then
        PveUtil.SetLayerRecursively(self.gameObject, "Default")
        self.shadowGo:SetActive(true)
    else
        PveUtil.SetLayerRecursively(self.gameObject, "OutlineAndShadow")
        self.shadowGo:SetActive(false)
    end
    self.collider.gameObject.layer=LayerMask.NameToLayer("Member")
end

function HeroUnit:InitHeroData( hero )
    self.skillManager = SkillManager.New(self.logic,self)---@type Scene.LWBattle.Skill.SkillManager
    self.skillManager.battleMgr = DataCenter.LWBattleManager.logic
    self.hero = hero
end

function HeroUnit:InitSkill()
    local acc = 1
    --加载本地技能配置
    --if CS.CommonUtils.IsDebug() and LOCAL_HERO_SKILL_OVERRIDE then
    --    for k, id in pairs(self.meta.skills) do
    --        local skillData = SkillInfo.New()
    --        local message = {}
    --        message['skillId'] = id
    --        message['heroUuid'] = 0
    --        message['slot'] = k
    --        message['state'] = 1
    --        message['uuid'] = 0
    --        skillData:UpdateSkillInfo(message)
    --        if skillData.skillTemplateData == nil then
    --            Logger.LogError("添加技能时，技能配置找不到,技能Id："..id)
    --        end
    --        self.skillManager:AddSkill(skillData.skillTemplateData,skillData)
    --        acc = acc + 1
    --        break
    --    end
    --else
    --    local skills=self.hero:GetAllUnlockSkills()
    --    for _,skillInfo in pairs(skills) do
    --        if skillInfo.skillTemplateData == nil then
    --            Logger.LogError("添加技能时，技能配置找不到,技能Id："..skillInfo.id)
    --        end
    --        self.skillManager:AddSkill(skillInfo.skillTemplateData,skillInfo)
    --        acc = acc + 1
    --    end
    --end
    -- DS 普攻
    local normalId = tonumber(self.meta.skill_normal)
    if normalId then
        local skillData = SkillInfo.New()
        local message = {}
        message['skillId'] = normalId
        message['heroUuid'] = 0
        message['slot'] = acc
        message['state'] = 1
        message['uuid'] = self.hero.uuid
        skillData:UpdateSkillInfo(message)
        if skillData.skillTemplateData == nil then
            Logger.LogError("添加技能时，技能配置找不到,技能Id："..normalId)
        end
        self.skillManager:AddSkill(skillData.skillTemplateData, skillData)
        acc = acc + 1
    end
    -- DS 技能
    local skillId = tonumber(self.meta.skill_pve)
    if skillId then
        local skillData = SkillInfo.New()
        local message = {}
        message['skillId'] = skillId
        message['heroUuid'] = 0
        message['slot'] = acc
        message['state'] = 1
        message['uuid'] = self.hero.uuid
        skillData:UpdateSkillInfo(message)
        if skillData.skillTemplateData == nil then
            Logger.LogError("添加技能时，技能配置找不到,技能Id："..skillId)
        end
        self.skillManager:AddSkill(skillData.skillTemplateData, skillData)
        acc = acc + 1
    end
    --无敌
    if CS.CommonUtils.IsDebug() and INVINCIBLE then
        self:SetInvincible(true)
        ---一个99999倍攻击力的buff
        self.buffManager:AddHaloBuff(string.format("%s/%s",self:GetGuid(),-1),{[HeroEffectDefine.BuffAttackAddRate]=99999})
    end
end

function HeroUnit:TryReplaceSkill()
    if self.logic.GetReplaceNormalSkill then
        local replaceSkill = self.logic:GetReplaceNormalSkill(self.meta.id)
        if replaceSkill > 0 then
            local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(replaceSkill)
            if skillMeta ~= nil then
               self.skillManager:ReplaceNormalAttack(skillMeta)
            end
        end
    end
end

function HeroUnit:InitFSM()
    --攻击状态机
    self.fsm = FSM.New()
    self.fsm:AddState(Const.ParkourFireState.Stay, StayState.New(self))
    
    if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
        self.fsm:AddState(Const.ParkourFireState.Straight, FireStateDefenseStraight.New(self))
    else
        self.fsm:AddState(Const.ParkourFireState.Straight,FireStateStraight.New(self))
    end
    
    self.fsm:AddState(Const.ParkourFireState.RotateAndShoot,FireStateAuto.New(self))
    self.fsm:AddState(Const.ParkourFireState.HoldFire,FireStateHold.New(self))
    self.fsm:AddState(Const.ParkourFireState.Dead, HeroDieState.New(self))
    self.fsm:ChangeState(Const.ParkourFireState.Stay)
    --运动状态机
    base.InitFSM(self)
end

function HeroUnit:OnUpdate()
    base.OnUpdate(self)
    if self.fsm then
        self.fsm:OnUpdate()
    end
    if self.skillManager then
        self.skillManager:OnUpdate()
    end
    if self.hpBar then
        self.hpBar:Update()
    end
end



function HeroUnit:GetFirePoint()
    return self.firePoint
end

function HeroUnit:GetMoveVelocity()
    if self.fsm and self.fsm:GetStateIndex()==Const.ParkourFireState.Straight then
        return Vector3.New(0,0,self.team.speedZ)
    else
        return Vector3.zero
    end
end

function HeroUnit:HideHpBar()
    if self.hpBar then
        self.hpBar:Destroy()
        self.hpBar = nil
    end

    if self.skillBar then
        self.skillBar:Delete()
        self.skillBar = nil
    end
end

function HeroUnit:DestroyView()
    base.DestroyView(self)
    if self.hpBar then
        self.hpBar:Destroy()
        self.hpBar = nil
    end

    if self.skillBar then
        self.skillBar:Delete()
        self.skillBar = nil
    end
    
    if self.fsm then
        self.fsm:Delete()
        self.fsm = nil
    end
    if self.cannon then
        self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    if self.skillManager then
        self.skillManager:DestroyView()
    end
    self.firePoint=nil

    if not IsNull(self.newAppearanceReq) then
        self.newAppearanceReq:Destroy()
        self.newAppearanceReq = nil
    end
end

function HeroUnit:DestroyData()
    base.DestroyData(self)
    if self.skillManager then
        self.skillManager:DestroyData()
        self.skillManager = nil
    end
end

function HeroUnit:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
    if self.invincible then
        return
    end
    base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
    if(hurt > 0 ) then

        --扣护盾
        hurt = self:ReduceShieldValue(hurt)
        
        self.curBlood = math.max(self.curBlood - hurt, 0)
        if self.curBlood > 0 and self.hpBar then
            self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
        end
        
        if self.curBlood <= 0 then
            self.fsm:ChangeState(Const.ParkourFireState.Dead)
            --DataCenter.LWBattleManager.logic:DealMemberDie(self)
        end
        
        local tbl = {}
        tbl.heroId = self.hero.heroId
        tbl.curBlood = self.curBlood
        tbl.maxBlood = self.maxBlood
        EventManager:GetInstance():Broadcast(EventId.PveHeroHpUpdate, tbl)
    end
end

function HeroUnit:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
    if self.invincible then
        return
    end
    base.AfterBeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
end



function HeroUnit:GetRawProperty(type)
    return self.hero:GetHeroProperty(type)
end


function HeroUnit:ChangeStage(stage)
    base.ChangeStage(self,stage)
    if stage == Const.ParkourBattleState.Boss then
        if self.fsm then
            self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
        end
    elseif stage == Const.ParkourBattleState.BossStay then
        if self.fsm then
            --boss站立攻击状态，也进入自动瞄准涉及状态
            self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
        end
    elseif stage == Const.ParkourBattleState.BossHorizontal then
        if self.fsm then
            self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
        end
    elseif stage == Const.ParkourBattleState.PreExit then
        self:SetInvincible(true)
    elseif stage == Const.ParkourBattleState.Exit then
        self:SetInvincible(true)
        if self.fsm then
            self.fsm:ChangeState(Const.ParkourFireState.HoldFire)
        end
    elseif stage == Const.ParkourBattleState.Farm then
        if self.fsm then
            self.fsm:ChangeState(Const.ParkourFireState.Straight)
        end

        if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
            --塔防模式增加头顶技能栏显示
            if self.hero.uuid > 0 or (self.hero.fromTemplate and self.hero.uuid < 0) or self.hero.uuid == HireHeroUuid then
                -- uuid ~= 0 的，认为是主动分配id的，试用英雄
                if not self.skillBar then
                    self.skillBar = SkillBarCell.New()
                    self.skillBar:Load(self, self.transform, BarHeight)

                    if self.hpBar then
                        self.hpBar:SetOffsetX(15)
                    end

                end
            end
        end
    end
end

function HeroUnit:GetMoveSpeed()
    return (self.meta.speed_control or 6) *  (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))
end

function HeroUnit:GetLocationType()
    return self.slot >2 and LocationType.Back or LocationType.Front
end

function HeroUnit:GetHeroCamp()
    return self.hero.heroType
end

--换肤
function HeroUnit:ReplaceAppearance(newHeroId)
    if not IsNull(self.newAppearanceReq) then
        self.newAppearanceReq:Destroy()
        self.newAppearanceReq = nil
    end
    
    local newHeroInfo = HeroInfo.New()
    newHeroInfo:UpdateFromTemplate(newHeroId)
    self.newHeroInfo = newHeroInfo
    
    local path = newHeroInfo.appearanceMeta.model_path
    self.newAppearanceReq = Resource:InstantiateAsync(path)
    self.newAppearanceReq:completed('+', function(request) 
        
        self.hero = self.newHeroInfo
        self.meta = self.hero.meta
        self.appearanceMeta = self.hero.appearanceMeta
        --self.heroEffectMeta=DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)

        Logger.Log("HeroUnit change id : ".. self.meta.id)
        
        self.gameObject = request.gameObject
        self.transform = request.gameObject.transform
        self.transform:SetParent(self.parent)
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)

        self:ComponentDefine()
        if self.hpBar then
            self.hpBar:ReplaceTarget(self.transform)
        else
            self.hpBar = HPBarCell.New(Const.HPBarStyle.Self,self.transform,BarHeight)
            self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
        end

        local appearanceMeta = self.appearanceMeta

        --设置大小
        self.transform:Set_localScale(appearanceMeta.model_size,appearanceMeta.model_size,appearanceMeta.model_size)
        local fire_path = appearanceMeta.fire_path
        self.firePoint = self.transform:Find(fire_path)
        if not self.firePoint or string.IsNullOrEmpty(fire_path) then
            Logger.LogError("开火点路径配置错误，路径不应包含预制体名，外观id："..self.hero.modelId.."，开火点路径："..fire_path)
        end
        if self.meta.is_human then
            self.cannon = self.transform
        else
            local canon_path = appearanceMeta.canon_path
            self.cannon=self.transform:Find(canon_path)
            if not self.cannon or string.IsNullOrEmpty(canon_path) then
                Logger.LogError("炮台路径配置错误，注意路径不应包含预制体名，外观id："..self.hero.modelId.."，炮台路径："..canon_path)
            else
                self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            end
            local canonFix = appearanceMeta.canon_rotation--炮台旋转修正
            if canonFix and #canonFix==3 then--存在修正
                self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1],canonFix[2],canonFix[3])
            end
        end
        self.angular_speed_deg = (self.meta.angular_speed or 20) * 60
        
        self.skillManager:RemoveAllSkills()
        self.team.logic:ShowEffectObj(
                Const.ParkourAddSkillEffectPath,Vector3.zero,nil,1,self.transform
        ) 
        self:InitSkill()

        if self.req then
            self.req:Destroy()
        end
        
        self.req = self.newAppearanceReq
        self.newAppearanceReq = nil
        
        local anim = self:GetCurAnimName()
        self:RewindAndPlaySimpleAnim(anim)
        
        --血量处理
        self.maxBlood = PveUtil.GetPveHeroHp(self.hero.heroId, self.hero.level, self.hero.curMilitaryRankId)
        self.curBlood = Mathf.Max(self.curBlood, self.maxBlood)
        if self.hpBar then
            self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
        end
    end)
end

return HeroUnit
