---
---Minion 小兵
---
local base = require("Scene.LWBattle.Skirmish.Unit.SkirmishUnit")
---@class Scene.LWBattle.Skirmish.Unit.Minion
local Minion = BaseClass("Minion",base)
--攻击状态之自动开火(小兵专用）
local FireStateAuto=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateAuto")
local Resource = CS.GameEntry.Resource

function Minion:DestroyData()
    self.skillMeta = nil
    self.maxCD = nil
    self.curCD = nil
    self.hero = nil
    self.meta = nil
    self.isHuman = nil
    self.cannon = nil
    self.angular_speed_deg = nil
    base.DestroyData(self)
end


function Minion:Init(logic,platoon,heroData,localPos,index)
    base.Init(self,logic,platoon,heroData,localPos,index)
    self.hero = heroData
    self.meta = self.hero.meta
    self.isHuman = true
    self.unitType = UnitType.Plot
    local path = self.hero.appearanceMeta.model_path
    self.heroEffectMeta=DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)
    self.maxBlood = PveUtil.GetPveHeroHp(self.hero.heroId, self.hero.level, self.hero.curMilitaryRankId)
    self.curBlood = self.maxBlood

    self.req = Resource:InstantiateAsync(path)
    self.req:completed('+', function(request)
        self.gameObject = request.gameObject
        self.transform = request.gameObject.transform
        self.transform:SetParent(self.platoon.transform)
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.transform:Set_localPosition(self.localPosition.x,self.localPosition.y,self.localPosition.z)
        self:ComponentDefine()
        self:InitFSM()
        
        local appearanceMeta=self.hero.appearanceMeta
        --设置大小
        self.transform:Set_localScale(appearanceMeta.model_size,appearanceMeta.model_size,appearanceMeta.model_size)
        local fire_path = appearanceMeta.fire_path
        self.firePoint = self.transform:Find(fire_path)
        if not self.firePoint or string.IsNullOrEmpty(fire_path) then
            Logger.LogError("开火点路径配置错误，路径不应包含预制体名，外观id："..self.hero.modelId.."，开火点路径："..fire_path)
        end
        self.cannon = self.transform
        self.angular_speed_deg=self.meta.angular_speed * 60
        self:InitSkill()
        self:EnableCollider(false)--关闭collider，节省性能
    end)
end




function Minion:InitFSM()
    base.InitFSM(self)
    --攻击状态机
    self.fsm:AddState(SkirmishFireState.Auto,FireStateAuto.New(self))
end

function Minion:InitSkill()
    local skillInfo=self.hero:GetHeroSkillBySlotIndex(1)
    if skillInfo then
        self.skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillInfo.skillId)
        --self.maxCD = skillInfo.skillTemplateData.attack_interval
        self.maxCD = self.sceneData.MINION_ATTACK_CD
        self.curCD = math.random()*self.sceneData.MINION_ATTACK_PRECD
    else
        Logger.LogError("英雄无1技能,英雄Id："..self.hero.heroId)
    end
end



function Minion:GetRawProperty(type)
    return self.hero:GetHeroProperty(type)
end

function Minion:ChangeStage(stage)
    base.ChangeStage(self,stage)
    if stage == SkirmishStage.Load then

    elseif stage == SkirmishStage.Opening then

    elseif stage == SkirmishStage.Fight then
        self.fsm:ChangeState(SkirmishFireState.Auto,self.curCD,self.maxCD,self.skillMeta)
    elseif stage == SkirmishStage.End then

    end
end


function Minion:SetMinionFightPause(isPause)
    if not isPause then
        self.fsm:ChangeState(SkirmishFireState.Auto,self.curCD,self.maxCD,self.skillMeta)
    else
        self.fsm:ChangeState(SkirmishFireState.Idle)
    end
end

function Minion:StopMoving()
    base.StopMoving(self)
    self:CrossFadeSimpleAnim(AnimName.Idle,1,0.2)
end

function Minion:GoDie()
    base.GoDie(self)
end


return Minion
