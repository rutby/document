
---队员，相当于原来的player类


local Resource = CS.GameEntry.Resource
local FSM=require("Framework.Common.FSM")
local Const = require("Scene.LWBattle.Const")
local MemberStateStay = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateStay")
local MemberStateMove = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateMove")
local MemberStateDie = require("Scene.LWBattle.BarrageBattle.MemberState.MemberStateDie")
local MemberUpStateNoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateNoAttack")
local MemberUpStateAutoAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateAutoAttack")
local MemberUpStateUltimate = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateUltimate")
local MemberUpStateStationAttack = require("Scene.LWBattle.BarrageBattle.MemberState.MemberUpStateStationAttack")
local HPBarCell = require "DataCenter.ZombieBattle.HpBar.HpBarCell"
local MemberEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_blue.prefab"
local ColliderComponent = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.Component.ColliderComponent")

---@type Scene.LWBattle.BarrageBattle.Unit.BarrageUnit
local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")

---队员，相当于原来的player类
---@class Scene.LWBattle.BarrageBattle.Unit.Member : Scene.LWBattle.BarrageBattle.Unit.BarrageUnit
local Member = BaseClass("Member",base)


---@param battleManager DataCenter.ZombieBattle.ZombieBattleManager
function Member:Init(battleManager,squad,guid,req,index,heroData,campBuff)
    base.Init(self,battleManager,guid,heroData.meta)
    if PVE_TEST_MODE then
        local GameFramework = CS.UnityEngine.GameObject.Find("GameFramework")
        self.bulletMotionEditor = GameFramework.transform:GetComponent(typeof(CS.BulletMotionEditor))
    end
    self.battleMgr = battleManager---@type DataCenter.ZombieBattle.ZombieBattleManager
    self.squad=squad---@type Scene.LWBattle.BarrageBattle.Squad
    self.m_req = req
    self.guid = guid
    self.unitType=UnitType.Member
    self.fsm=nil---@type Framework.Common.FSM
    self.upFsm=nil---@type Framework.Common.FSM
    self.gameObject = nil
    self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 20)
    self.index=index
    self.heroData=heroData
    self.hero=heroData
    self:InitHeroData(campBuff)
    self.timeCount=0
    --在预制体加载完成前，数据必须先初始化
    self.localPosition=self.squad.formation:GetOffsetByIndex(self.index)
end

function Member:DestroyView()
    base.DestroyView(self)
    if self.transform then
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    if self.cannon then
        self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.cannon=nil
    end
    if self.colliderComponent then
        self.colliderComponent:Destroy()
        self.colliderComponent = nil
    end
    self.gameObject = nil
    self.transform = nil
    if self.m_req ~= nil then
        self.m_req:Destroy()
        self.m_req = nil
    end
    if self.fsm then
        self.fsm:Delete()
        self.fsm=nil
    end
    if self.upFsm then
        self.upFsm:Delete()
        self.upFsm=nil
    end
    if self.hpBar then
        self.hpBar:Destroy()
        self.hpBar = nil
    end
    if self.effReq ~= nil then
        self.effReq:Destroy()
        self.effReq = nil
    end
    self.firePoint=nil
    self.curBlood = 0
    self.anim=nil
end

function Member:DestroyData()
    self.squad=nil
    self.hero = nil
    self.bulletMotionEditor = nil
    self.curBlood = 0
    self.localPosition=nil
    self.isHuman=nil
    self.localForward=nil
    self.angular_speed_deg=nil
    self.superArmor=nil
    
    base.DestroyData(self)
end


function Member:OnCreate()
    if self.m_req ~= nil then
        self.gameObject = self.m_req.gameObject
        self.transform = self.gameObject.transform
    end
    self.transform:SetParent(self.squad.transform)
    self:ResetPosition()
    self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    self:ComponentDefine()
    self:InitFSM()
end

function Member:GetPosition()
    if not IsNull(self.transform) then
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()
        return self.curWorldPos
    else
        if self.squad and self.squad:GetPosition() then
            return self.squad:GetPosition()+self.localPosition
        else
            return self.curWorldPos
        end
    end
end

function Member:ResetPosition()
    self:SetLocalPosition(self.squad.formation:GetOffsetByIndex(self.index))
end

function Member:MoveToIndex(dstIndex,time)
    self.localPosition=self.squad.formation:GetOffsetByIndex(dstIndex)
    if time <= 0 then
        self:SetLocalPosition(self.localPosition)
    else
        self.transform:DOLocalMove(self.localPosition, time)
    end
end

function Member:SetLocalPosition(pos)
    self.localPosition=pos
    if not IsNull(self.transform) then
        self.transform:DOKill()
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
    end
end

function Member:SetPosition(pos)
    if not IsNull(self.transform) then
        self.transform:DOKill()
        self.transform.position=pos
    end
end

function Member:InitHeroData(campBuff)
    if not self.hero then
        Logger.LogError("获取英雄数据失败，heroUuid ：")
        return
    end
    self.meta = self.hero.config
    --self.isHuman = self.meta.is_human
    self.isHuman = true
    --self.heroEffectMeta=DataCenter.PveHeroEffectTemplateManager:GetTemplate(self.meta.hero_effect)

    --阵容加成（当做光环处理）
    if campBuff and campBuff.camp_effect then
        for k,v in pairs(campBuff.camp_effect) do
            self.buffManager:AddHaloBuff(string.format("%s/-%s",self:GetGuid(),k),{[k]=v})
        end
    end
    
    --计算公式：50014(PVE)=[50014(战斗外)+50006]*(1+75051+75060)
    --50014(战斗外)
    local HealPoint_Result = self:GetProperty(HeroEffectDefine.HealPoint_Result)
    --50006
    local HealthPoint = self:GetProperty(HeroEffectDefine.HealthPoint)
    --75060
    local LineupHpAddRate = self:GetProperty(HeroEffectDefine.LineupHpAddRate)
    --75051
    local BuffHpAddRate = self:GetProperty(HeroEffectDefine.BuffHpAddRate)
    
    self.curBlood = math.floor((HealPoint_Result+HealthPoint)*(1+BuffHpAddRate+LineupHpAddRate))
    self.maxBlood = self.curBlood
end

function Member:GetRawProperty(type)
    return self.hero:GetHeroProperty(type)
end


function Member:InitFSM()
    self:PlaySimpleAnim("idle")
    self.fsm = FSM.New()
    self.fsm:AddState(MemberState.Stay,MemberStateStay.New(self))
    self.fsm:AddState(MemberState.Move,MemberStateMove.New(self))
    self.fsm:AddState(MemberState.Dead,MemberStateDie.New(self))
    self.fsm:ChangeState(MemberState.Stay)
    
    self.upFsm = FSM.New()
    self.upFsm:AddState(AttackState.AutoAttack,MemberUpStateAutoAttack.New(self))
    self.upFsm:AddState(AttackState.Ultimate,MemberUpStateUltimate.New(self))
    self.upFsm:AddState(AttackState.StationAttack,MemberUpStateStationAttack.New(self))
    self.upFsm:AddState(AttackState.HoldFire,MemberUpStateNoAttack.New(self))
    self.upFsm:ChangeState(AttackState.AutoAttack)
end



function Member:HandleInput(command,param)
    if command==MemberCommand.Move then
        self.fsm:ChangeState(MemberState.Move,param)
    elseif command==MemberCommand.Stay then
        self.fsm:ChangeState(MemberState.Stay,param)
    elseif command==MemberCommand.AutoAttack then
        if self.upFsm:GetStateIndex()~=AttackState.Ultimate and
            self.upFsm:GetStateIndex()~=AttackState.HoldFire then
            self.upFsm:ChangeState(AttackState.AutoAttack,param)
        end
    elseif command==MemberCommand.StationAttack then
        if self.upFsm:GetStateIndex()~=AttackState.Ultimate and
            self.upFsm:GetStateIndex()~=AttackState.HoldFire then
            self.upFsm:ChangeState(AttackState.StationAttack,param)
        end
    elseif command==MemberCommand.Ultimate then
        if self:UltimateIsReady() then
            self.upFsm:ChangeState(AttackState.Ultimate,param)
            return true
        else
            return false
        end
    end
end


function Member:ComponentDefine()

    base.ComponentDefine(self)
    self.hpBar = HPBarCell.New(Const.HPBarStyle.Self,self.transform,2)
    self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
    --PveUtil.SetLayerRecursively(self.gameObject,"Default")
    self.collider.gameObject.layer=LayerMask.NameToLayer("Member")
    
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if not self.anim then
        Logger.LogError("该单位下面没挂SimpleAnimation脚本，gameObject:"..self.gameObject.name)
    end
    local appearanceMeta=self.hero.appearanceMeta
    --设置大小
    self.transform:Set_localScale(appearanceMeta.model_size,appearanceMeta.model_size,appearanceMeta.model_size)
    -- 加载武器
    local fire_path = appearanceMeta.fire_path
    self.firePoint=self.transform:Find(fire_path)
    if not self.firePoint or string.IsNullOrEmpty(fire_path) then
        Logger.LogError("开火点路径配置错误，路径不应包含预制体名，外观id："..self.hero.modelId.."，开火点路径："..fire_path)
    end
    
    if self.isHuman then
        self.cannon = self.transform
    else
        local canon_path = appearanceMeta.canon_path
        self.cannon=self.transform:Find(canon_path)
        if not self.cannon or string.IsNullOrEmpty(canon_path) then
            Logger.LogError("炮台路径配置错误，注意路径不应包含预制体名，外观id："..self.hero.modelId.."，炮台路径："..canon_path)
        else
            self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        end
        --炮台旋转修正
        local canonFix = appearanceMeta.canon_rotation
        if canonFix and #canonFix==3 then--存在修正
            self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1],canonFix[2],canonFix[3])
        end
    end
    self.angular_speed_deg = (self.meta.angular_speed or 20) * 60
    
    --if Const.UseTestModel then
    --    self.firePoint=self.transform:Find(Const.TestFirePoint)
    --    self.cannon=self.transform:Find(Const.TestCannon)
    --end
    
    self.effReq = Resource:InstantiateAsync(MemberEffect)
    self.effReq:completed('+', function(effreq)
        local effGo = effreq.gameObject
        effGo.transform:SetParent(self.transform)
        effGo.transform:Set_localPosition(0, 0, 0)
    end)
    self:InitSkill()
end


function Member:InitSkill()
    --加载本地技能配置
    if CS.CommonUtils.IsDebug() and LOCAL_HERO_SKILL_OVERRIDE then
        for k, id in pairs(self.meta.skills) do
            local skillInfo = SkillInfo.New()
            local message = {}
            message['skillId'] = id
            message['heroUuid'] = 0
            message['slot'] = k
            message['state'] = 1
            message['uuid'] = 0
            skillInfo:UpdateSkillInfo(message)
            if skillInfo.skillTemplateData == nil then
                Logger.LogError("添加技能时，技能配置找不到,技能Id："..id)
            end
            self.skillManager:AddSkill(skillInfo.skillTemplateData,skillInfo)
        end
    else
        local skills=self.hero:GetAllUnlockSkillsExcludeUltimate()
        for _,skillInfo in pairs(skills) do
            if skillInfo.skillTemplateData == nil then
                Logger.LogError("添加技能时，技能配置找不到,技能Id："..skillInfo.id)
            else
                self.skillManager:AddSkill(skillInfo.skillTemplateData,skillInfo)
            end
        end
        local skillInfo=self.hero:GetUltimateSkill()
        if skillInfo then
            --Logger.Log("英雄"..self.hero.heroId.."拥有大招"..skillInfo.skillId)
            local ultimateSkill = self.skillManager:AddSkill(skillInfo.skillTemplateData,skillInfo,true)
            if self:UltimateIsLock() and self:UltimateCanUnlock() then
                self.skillManager:ResetCooldown(ultimateSkill)
            end
        end
    end
    --无敌
    if CS.CommonUtils.IsDebug() and INVINCIBLE then
        self:SetInvincible(true)
        ---一个99999倍攻击力的buff
        self.buffManager:AddHaloBuff(string.format("%s/%s",self:GetGuid(),-1),{[HeroEffectDefine.BuffAttackAddRate]=99999})
    end
end


function Member:GetCannonTransform()
    return self.cannon
end




function Member:OnUpdate()
    base.OnUpdate(self)
    if self.fsm then
        self.fsm:OnUpdate()
    end
    if self.upFsm then
        self.upFsm:OnUpdate()
    end
    if self.hpBar then    --更新血条位置
        self.hpBar:Update()
    end
    if PVE_TEST_MODE and self.bulletMotionEditor then
        self.timeCount=self.timeCount-Time.deltaTime
        if self.timeCount<0 then
            self.timeCount=1
            local id = self.bulletMotionEditor.SkillId
            local isUltimate = self.bulletMotionEditor.IsUltimate
            if id and id>0 and not self.skillManager:HasSkill(id) then
                local skillTemplateData = DataCenter.HeroSkillTemplateManager:GetTemplate(id)
                if skillTemplateData then
                    self.skillManager:RemoveAllSkills()
                    local skillData = SkillInfo.New()
                    local message = {}
                    message['skillId'] = id
                    message['heroUuid'] = 0
                    message['slot'] = 1
                    message['state'] = 1
                    message['uuid'] = 0
                    skillData:UpdateSkillInfo(message)
                    if skillData.skillTemplateData == nil then
                        Logger.LogError("添加技能时，技能配置找不到,技能Id："..id)
                    end
                    self.skillManager:AddSkill(skillData.skillTemplateData,skillData,isUltimate)
                end
            end
        end
    end
end





function Member:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff)
    if self.invincible then
        return
    end
    base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff)
    
    --print("Member be attack", self.guid, self.curBlood, hurt)
    EventManager:GetInstance():Broadcast(EventId.MemberBeAttack,{index=self.index,hp=self.curBlood/self.maxBlood})
    if self.curBlood <= 0 then
        --print("Member die", self.guid)
        self.fsm:ChangeState(MemberState.Dead)
        self.upFsm:ChangeState(AttackState.HoldFire)
    end
    
    if(hurt > 0 ) then
        if self.hpBar then
            self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
        end
    end
    
end

function Member:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
    if self.invincible then
        return
    end
    base.AfterBeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
end

---检查是否进入警戒状态（警戒范围内是否有敌人）
function Member:CheckEnemyInAlertRange()
    return self.battleMgr and PveUtil.CheckHasUnitInSphereRange(self.battleMgr,self:GetPosition(),
            Const.MEMBER_ALERT_RADIUS,LayerMask.GetMask("Zombie"),nil,1)
end


function Member:SetWeaponActive(active)
end



function Member:GetFirePoint()
    return self.firePoint
end


function Member:GetMoveSpeed()
    return (self.meta.speed_battle or 4) * (1 + self:GetProperty(HeroEffectDefine.BattleHeroMoveSpeed))  
end

function Member:IsMoving()
    return self.fsm and self.fsm:GetStateIndex()==MemberState.Move
end

function Member:IsSuperArmor()--狂飙状态
    self.superArmor = false
    local buff = self.buffManager:GetPropertyBuff(HeroEffectDefine.SuperArmor)
    if buff > 0 then
        self.superArmor = true
    end
    return self.superArmor
end

function Member:InitColliderComponent(layerMask,OnCollision)
    if not self.colliderComponent and self.transform then
        self.colliderComponent = ColliderComponent.New()
        self.colliderComponent:InitCollider(self.transform, 10, layerMask)
        self.colliderComponent:SetOnCollide(OnCollision)
    end
end

function Member:GetCurAndMaxHp()
    return self.curBlood,self.maxBlood
end

function Member:GetLocationType()
    return self.index>2 and LocationType.Back or LocationType.Front
end

function Member:GetHeroCamp()
    return self.hero.heroType
end

function Member:UltimateIsReady()
    local ultimateSkill=self.skillManager:GetUltimateSkill()
    if not ultimateSkill then--没大招
        return false
    end
    if ultimateSkill.lock then
        return false
    end
    local curCD = ultimateSkill:GetCurAndMaxCD()
    if curCD>0 then
        return false
    end
    if self.curBlood <= 0 then
        return false
    end
    if self:IsSuperArmor() then--狂飙状态不能施法
        return false
    end
    if self.upFsm:GetStateIndex()==AttackState.Ultimate or self.upFsm:GetStateIndex()==AttackState.HoldFire then
        return false
    end
    return true
end


function Member:UltimateIsLock()
    if self.skillManager then
        local ultimateSkill = self.skillManager:GetUltimateSkill()
        return ultimateSkill and ultimateSkill.lock
    else
        return false
    end
end

function Member:GetUltimateTimeStopDuration()
    return self.skillManager:GetUltimateTimeStopDuration()
end

function Member:UltimateCanUnlock()
    return false
    --local hasUnlockPrevSkill = self.heroData:CanUnlockSkillByPrevSkillLimit(ULTIMATE_SKILL_SLOT_INDEX)
    --if not hasUnlockPrevSkill then
    --    return false
    --end
    --local unlockSkillCost = DataCenter.HeroUnlockSkillCostDataManager:GetCostByQualityAndSlot(
    --        self.heroData.quality, ULTIMATE_SKILL_SLOT_INDEX)
    --local costId,costCount
    --for id, count in pairs(unlockSkillCost) do
    --    costId = id
    --    costCount = count
    --end
    --local have = DataCenter.ItemData:GetItemCount(costId)
    --if have < costCount then
    --    -- UIUtil.ShowTipsId(151044)
    --    -- LWResourceLackUtil:GotoGoodsItemLack(self.costId,self.costCount-have)
    --    return false
    --end
    --return true
end

function Member:UnlockUltimate()
    if self:UltimateCanUnlock() then
        local ultimateSkill=self.skillManager:GetUltimateSkill()
        self.skillManager:SetUnlock(ultimateSkill)
        SFSNetwork.SendMessage(MsgDefines.HeroSkillUnlock, self.heroData.uuid,ULTIMATE_SKILL_SLOT_INDEX)
    end
end

function Member:ChangeStage(stage)
    if stage == BarrageState.PreExit then
        self:SetInvincible(true)
    elseif stage == BarrageState.Exit then
        self:SetInvincible(true)
        if self.transform then
            self.battleMgr:ShowEffectObj(
                    "Assets/_Art/Effect_B/Prefab/Common/Eff_duiwujiasu.prefab",self.transform.localPosition,nil,-1,self.transform.parent)
        end
    end
end

function Member:OnBuffAdded(buff)
    base.OnBuffAdded(self, buff)
    if buff.meta.type==BuffType.Stun then
        self.upFsm:ChangeState(AttackState.HoldFire)
    end
end

function Member:OnBuffRemoved(buff)
    if buff.meta.type==BuffType.Stun then
        if not self.buffManager or not self.buffManager:HasAnyBuffWithType(BuffType.Stun) then
            self.upFsm:ChangeState(AttackState.AutoAttack)
        end
    end
end

function Member:InterruptSkill()
    if self.skillManager then
        self.skillManager:Interrupt()
    end
end



return Member