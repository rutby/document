---
--- 弹幕玩法和跑酷玩法unit的基类，ParkourUnit和BarrageUnit的基类
---
---@class Scene.LWBattle.UnitBase
---@field buffManager Scene.LWBattle.Buff.BuffManager
local UnitBase = BaseClass("UnitBase")
local BuffManager = require("Scene.LWBattle.Buff.BuffManager")
local Resource = CS.GameEntry.Resource
local TINY_VECTOR = Vector3.New(0,0,0.001)
local DEATH_BLOOD_TIME = 2.5--死亡血渍时长


function UnitBase:Init(logic)
    self.buffManager = BuffManager.New(logic,self)---@type Scene.LWBattle.Buff.BuffManager
    self.renders={}
    self.maxBlood = 0
    self.curBlood = 0
    --self.flashPrior = 0
    if not self.curWorldPos then
        self.curWorldPos = Vector3.zero
    end
    self.invincible = false--无敌状态
    self.logic=logic
    self.morgueDuration=0--停尸时间：unit死亡动画播完后，清理表现层、进入停尸间，3秒后，清理数据层、进入缓存池。（搞这个停尸间是为了处理死前一击问题）
    self.stealth = false--隐身
    self.radius = 0
    self.sizeX = 0
    self.sizeZ = 0
end



--清理表现（死亡动画播完时调用）
function UnitBase:DestroyView()
    for _,v in pairs(self.renders) do--进缓存池时还原
        v.renderer.sharedMaterial = v.defaultMat
    end
    self.renders={}
    self:EnableCollider(true)--进缓存池时还原
    self.collider = nil
    if not IsNull(self.transform) then
        --transform即将销毁，先缓存一下坐标，记录死亡位置
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()    
    end
    self.tauntTarget = nil
    self.flashCountdown = nil
    self.curBlood = 0
end

--清理数据（退出关卡时调用）
function UnitBase:DestroyData()
    self.logic=nil
    self.meta=nil
    self.heroEffectMeta=nil
    if self.buffManager then
        self.buffManager:Destroy()
    end
    self.curAnimName=nil
    self.name=nil
    self.guid=nil
    self.unitType=nil
    self.invincible=nil
    self.maxBlood = 0
    self.stealth = false
end



function UnitBase:OnUpdate()
    if self.buffManager then
        self.buffManager:OnUpdate()
    end
    if self.flashCountdown then
        self.flashCountdown = self.flashCountdown - Time.deltaTime
        if self.flashCountdown<0 then
            self.flashCountdown=nil
            for k,v in pairs(self.renders) do
                v.renderer.sharedMaterial = v.defaultMat
            end
            --self.flashPrior = 0
        end
    end
end

function UnitBase:ComponentDefine()
    self.name=UnitType2String[self.unitType]..self.guid
    self.renders={}
    local skinnedMeshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
    local meshRenderer = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.MeshRenderer))
    for i = 0, skinnedMeshRenderer.Length-1 do
        self.renders[i+1]={["renderer"]=skinnedMeshRenderer[i],["defaultMat"]=skinnedMeshRenderer[i].sharedMaterial}
    end
    local count = #self.renders
    for i = 0, meshRenderer.Length-1 do
        if not string.find(meshRenderer[i].gameObject.name,"Shadow",1,true) --影子不闪白
            and not string.find(meshRenderer[i].gameObject.name,"shadow",1,true) --影子不闪白
            and not string.find(meshRenderer[i].gameObject.name,"platform",1,true) --台子不闪白
            and meshRenderer[i].gameObject.name~="HpText"--文字不闪白
        then
            self.renders[i+1+count]={["renderer"]=meshRenderer[i],["defaultMat"]=meshRenderer[i].sharedMaterial}
        end
    end

    local trigger = self.gameObject:GetComponentInChildren(typeof(CS.CitySpaceManTrigger))
    if trigger then
        trigger.ObjectId = self.guid
    else
        Logger.LogError("该单位根节点没挂CitySpaceManTrigger脚本:"..self.gameObject.name)
    end
    self.trigger = trigger
    self.collider = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Collider))
end



---@param hitPoint number @--受击点
---@param hitDir number @--受击方向
---@param whiteTime number @--闪白时间
---@param stiffTime number @--硬直时间
---@param hitBackDistance Common.Tools.UnityEngine.Vector3 @--击退位移
function UnitBase:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
    
end

---伤害结算后处理，在BeAttack后执行
---@param hitPoint number @--受击点
---@param hitDir number @--受击方向
---@param whiteTime number @--闪白时间
---@param stiffTime number @--硬直时间
---@param hitBackDistance Common.Tools.UnityEngine.Vector3 @--击退位移
---@param deathEff string @--死亡特效
function UnitBase:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)

    if self.curBlood <= 0 then
        self.buffManager:RemoveAllBuff()
        if self.skillManager then
            self.skillManager:Interrupt()--中断攻击
        end
        self:EnableCollider(false)--死亡时关闭collider，节省性能
    end
    
    
    --子弹挂buff
    if skill and self.curBlood>0 then
        skill:DealBulletBuff(self)
    end
    
    --闪白
    if whiteTime>0 and self.curBlood>0 then
        if self.unitType==UnitType.Member then
            if not RedMat then
                RedMat=Resource:LoadAsset("Assets/Main/Material/UnitRed.mat", typeof(CS.UnityEngine.Material)).asset
            end
            self:Flash(RedMat,whiteTime)
        else
            if not WhiteMat then
                WhiteMat=Resource:LoadAsset("Assets/Main/Material/UnitWhite.mat", typeof(CS.UnityEngine.Material)).asset
            end
            self:Flash(WhiteMat,whiteTime)
        end
    end

    --子弹击中特效
    if not string.IsNullOrEmpty(hitEff) and self.transform then
        local localPos = self.transform:InverseTransformPoint(hitPoint)
        self.logic:ShowEffectObj(hitEff,localPos,nil,nil,self.transform)
    end
    
    if self.heroEffectMeta then
        local effectMeta=self.heroEffectMeta
        --受击特效
        if not string.IsNullOrEmpty(effectMeta.hit_effect) then
            local quaternion = nil
            if hitDir then
                if Vector3.SqrMagnitude(hitDir)<1e-8 then
                    hitDir = TINY_VECTOR
                end
                if effectMeta.hit_effect_direction==1 then
                    quaternion = Quaternion.LookRotation(hitDir)
                elseif effectMeta.hit_effect_direction==2 then
                    quaternion = Quaternion.LookRotation(-hitDir)
                end
            end
            self.logic:ShowEffectObj(effectMeta.hit_effect,nil,quaternion,nil,self.transform)
        end

        --死亡
        if self.curBlood <= 0 then
            --死亡特效
            if not string.IsNullOrEmpty(deathEff) then
                self.logic:ShowEffectObj(deathEff,hitPoint,nil,nil)
            elseif not string.IsNullOrEmpty(effectMeta.death_effect_nomal) then
                self.logic:ShowEffectObj(effectMeta.death_effect_nomal,hitPoint,nil,nil)
            end
            --死亡音效
            if effectMeta.death_sound then
                local sound = effectMeta.death_sound:GetRandom()
                if sound then
                    DataCenter.LWSoundManager:PlaySoundWithLimit(sound,SoundLimitType.UnitDeath)
                end
            end
            --死亡血渍
            local bloodEffect = effectMeta:GetRandomBlood()
            if bloodEffect then
                self.logic:ShowEffectObj(bloodEffect,self:GetPosition(),nil,DEATH_BLOOD_TIME,nil,EffectObjType.Sprite)
            end

            --死亡震屏
            if effectMeta.deathShakeParam then
                self.logic:ShakeCameraWithParam(effectMeta.deathShakeParam)
            end
        end

    end
end

--闪红或闪白
--prior:改色优先级，优先级高遇到低的会覆盖，低的遇到高的不生效，平级也是覆盖
function UnitBase:Flash(color,time,prior)
    --prior = prior or 1
    --if prior < self.flashPrior  then
    --    return
    --end
    --self.flashPrior = prior
    for k,v in pairs(self.renders) do
        v.renderer.sharedMaterial = color
    end
    self.flashCountdown = time
end

function CheckAnimName(anim, name)
    if anim == nil or name == nil then
        --print("PlayAnim.该动画不存在:" .. name)
        return nil
    end
    local state = anim:GetState(name)
    if state ~= nil then
        return name
    end
    -- 现在动画有点乱，有的士兵用的是 death 有的是 dead，野怪也一样 death 和 dead 混用
    if name == "death" then
        state = anim:GetState("dead")
        if state ~= nil then
            --print("PlayAnim.death 动画不存在, try use dead")
            return "dead"
        end
    end
    if name == "dead" then
        state = anim:GetState("death")
        if state ~= nil then
            --print("PlayAnim.dead 动画不存在, try use death")
            return "death"
        end
    end
    --print("PlayAnim.该动画不存在:" .. name)
    return nil
end

--播放动画
--speed 播放速度 传空代表不控制速度
function UnitBase:PlaySimpleAnim(name,speed)
    if self.anim then
        local theAnimName = CheckAnimName(self.anim, name)
        if theAnimName == nil then
            return
        end
        self.curAnimName=theAnimName
        self.anim:Play(theAnimName)
        if speed then
            self.anim:SetStateSpeed(theAnimName,speed)
        end
    end
end

function UnitBase:GetState(name)
    if self.anim then
        return self.anim:GetState(name)
    end
end

--从头播放动画
--speed 播放速度 传空代表不控制速度
function UnitBase:RewindAndPlaySimpleAnim(name,speed)
    if self.anim then
        local theAnimName = CheckAnimName(self.anim, name)
        if theAnimName == nil then
            return
        end
        self.curAnimName=theAnimName
        self.anim:Rewind(theAnimName)
        self.anim:Play(theAnimName)
        if speed then
            self.anim:SetStateSpeed(theAnimName,speed)
        end
    end
end

function UnitBase:CrossFadeSimpleAnim(name,speed,fadeTime)
    if self.anim then
        self.curAnimName=name
        self.anim:CrossFade(name,fadeTime)
        if speed then
            self.anim:SetStateSpeed(name,speed)
        end
    end
end


function UnitBase:RewindSimpleAnim(name)
    if self.anim then
        local theAnimName = CheckAnimName(self.anim, name)
        if theAnimName == nil then
            return
        end
        self.anim:Rewind(theAnimName)
    end
end

function UnitBase:GetCurAnimName()
    return self.curAnimName
end

function UnitBase:GetAnimLength(name)
    if self.anim then
        self.anim:SetStateSpeed(name,1)
        return self.anim:GetClipLength(name)
    else
        return 0
    end
end


function UnitBase:IsMoving()
    return false
end

function UnitBase:IsStunning()
    if self.buffManager then
        return self.buffManager:HasAnyBuffWithType(BuffType.Stun)
    end
    return false
end

function UnitBase:IsImprisoning()
    if self.buffManager then
        return self.buffManager:HasAnyBuffWithType(BuffType.Imprison)
    end
    return false
end

function UnitBase:IsSpecialMoving()
    if self.buffManager then
        return self.buffManager:HasAnyBuffWithType(BuffType.SpecialMove)
    end
    return false
end


function UnitBase:GetProperty(propertyType)
    return self:GetRawProperty(propertyType) + self.buffManager:GetPropertyBuff(propertyType)
end
--拿取某个Type的buff数
function UnitBase:GetTypeBuffCount(subType)
    return self.buffManager:GetTypeBuffCount(subType)
end
--拿取某个SubType的buff数
function UnitBase:GetSubTypeBuffCount(subType)
    return self.buffManager:GetSubTypeBuffCount(subType)
end

function UnitBase:AddBuff(buffMetaId,param)
    self.buffManager:AddBuff(buffMetaId,param)
end

function UnitBase:AddHaloBuff(skillUid,propertyDic,skillId)
    self.buffManager:AddHaloBuff(skillUid,propertyDic,skillId)
end

function UnitBase:ShowOrHide(isShow)
    if self.gameObject then
        self.gameObject:SetActive(isShow)
    end
end

--从c#拿取坐标并缓存
function UnitBase:GetPosition()
    if self.transform then
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()
    end
    return self.curWorldPos
end

function UnitBase:GetTransform()
    return self.transform
end

function UnitBase:GetGameObject()
    return self.gameObject
end

function UnitBase:GetMoveVelocity()
    return Vector3.zero
end

function UnitBase:GetCurBlood()
    return self.curBlood
end

function UnitBase:GetMaxBlood()
    return self.maxBlood
end

function UnitBase:GetLocationType()
    return LocationType.None
end

function UnitBase:GetGuid()
    return self.guid
end

function UnitBase:GetTauntTarget()
    return self.tauntTarget
end

function UnitBase:SetTauntTarget(target)
    self.tauntTarget=target
end

function UnitBase:GetCollider()
    return self.collider
end

function UnitBase:EnableCollider(isEnable)
    if self.collider then
        self.collider.enabled=isEnable
    end
end

function UnitBase:SetInvincible(bool)
    self.invincible = bool
end

--获取英雄阵营
function UnitBase:GetHeroCamp()
    return HeroType.None
end

function UnitBase:GetUnitType()
    return self.unitType
end

--强制结束闪白
function UnitBase:ForceFinishFlash()
    self.flashCountdown=nil
    for k,v in pairs(self.renders) do
        v.renderer.sharedMaterial = v.defaultMat
    end
end

function UnitBase:OnBuffAdded(buff)
    if buff.meta.type == BuffType.Shield then
        if self.hpBar and self.curBlood > 0 then
            self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
        end
        
    end
end

function UnitBase:OnBuffRemoved(buff)
    if buff.meta.type == BuffType.Shield then
        if self.hpBar and self.curBlood > 0 then
            self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
        end
    end
    
end

--获取当前护盾值
function UnitBase:GetShieldValue()
    return self.buffManager:GetShieldValue()
end

---@return number 护盾吸收后的剩余伤害值
function UnitBase:ReduceShieldValue(hurt)
    return self.buffManager:ReduceShieldValue(hurt)
end

function UnitBase:IsStealth()
    return self.stealth
end

function UnitBase:SetStealth(bool)
    self.stealth = bool
end


---被动技能触发
---@param skill Scene.LWBattle.Skill.Skill
function UnitBase:OnPassiveSkillCast(skill)
    
end

--移除所有护盾buff
function UnitBase:RemoveAllShieldBuff()
    self.buffManager:RemoveAllShield()
end

return UnitBase