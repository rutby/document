
---队员


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
local MemberEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_blue.prefab"

---@type Scene.LWBattle.BarrageBattle.Unit.BarrageUnit
local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")

---队员，相当于原来的player类
---@class Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember : Scene.LWBattle.BarrageBattle.Unit.BarrageUnit
local TacticalWeaponMember = BaseClass("TacticalWeaponMember",base)


---@param battleManager DataCenter.ZombieBattle.ZombieBattleManager
function TacticalWeaponMember:Init(battleManager,squad,guid,req,weaponData,appearanceMeta,campBuff,skillChips)
    base.Init(self,battleManager,guid)
    if PVE_TEST_MODE then
        local GameFramework = CS.UnityEngine.GameObject.Find("GameFramework")
        self.bulletMotionEditor = GameFramework.transform:GetComponent(typeof(CS.BulletMotionEditor))
    end
    self.battleMgr = battleManager---@type DataCenter.ZombieBattle.ZombieBattleManager
    self.squad=squad---@type Scene.BarrageBattle.Squad
    self.m_req = req
    self.guid = guid
    self.unitType=UnitType.TacticalWeapon
    self.fsm=nil---@type Framework.Common.FSM
    self.upFsm=nil---@type Framework.Common.FSM
    self.gameObject = nil
    self.weaponData=weaponData
    self.campBuff = campBuff
    self.skillChips = skillChips
    self.propertyData = nil
    self:InitWeaponData()
    self.timeCount=0
    self.maxBlood = 1
    self.curBlood = 1

    self.modelVisible = false
    self.modelValid = false
    self.delayShow = 0
    
    if weaponData and appearanceMeta == nil then
        self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(weaponData:GetAppearance())
    else
        self.appearanceMeta = appearanceMeta
    end
    self.appearanceId = self.appearanceMeta.id--外观id
    --在预制体加载完成前，数据必须先初始化
    self.localPosition=self.squad.formation:GetWeaponOffset()
end

function TacticalWeaponMember:DestroyView()
    if self.modelValid and self.gameObject then
        --还原渲染
        --self.rendererArray.enabled = true
        local length = self.rendererArray.Length - 1
        for i = 0, length do
            self.rendererArray[i].enabled = true
        end
    end
    self.modelValid = false
    
    if self.anim then
        self.anim.cullingMode = CS.UnityEngine.AnimatorCullingMode.CullCompletely
    end
    
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
end

function TacticalWeaponMember:DestroyData()
    base.DestroyData(self)
    self.squad=nil
    self.weaponData=nil
    self.appearanceMeta=nil
    self.propertyData = nil
    self.bulletMotionEditor = nil
    self.curBlood = 0
    self.skillChips = nil
    self.campBuff = nil
end


function TacticalWeaponMember:OnCreate()
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

function TacticalWeaponMember:GetPosition()
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

function TacticalWeaponMember:ResetPosition()
    self:SetLocalPosition(self.squad.formation:GetWeaponOffset())
end

function TacticalWeaponMember:SetLocalPosition(pos)
    self.localPosition=pos
    if not IsNull(self.transform) then
        self.transform:DOKill()
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
    end
end

function TacticalWeaponMember:SetPosition(pos)
    if not IsNull(self.transform) then
        self.transform:DOKill()
        self.transform.position=pos
    end
end

function TacticalWeaponMember:InitUnitProperties(campBuff,skillChips)
    if not self.weaponData then
        return
    end
    if not self.propertyData then
        self.propertyData = HeroPropertyData.New()
    else
        self.propertyData:Clear()
    end
    local weaponPropData = self.weaponData:GetPropetyData()
    if weaponPropData then
        weaponPropData:WalkAllProperties(function(id, value)
            self.propertyData:SetProperty(id, value)
        end)
    end

    -- 无人机战斗前需要进行属性映射 因为无人机目前不会被攻击 可以只处理攻击属性
    -- 阵容加成（当做光环处理）
    if campBuff and campBuff.camp_effect then
        for k, v in pairs(campBuff.camp_effect) do
            self.buffManager:AddHaloBuff(string.format("%s/-%s", self:GetGuid(), k), {
                [k] = v
            })
        end
    end

    -- 芯片属性加到无人机
    if skillChips then
        for _, chip in pairs(skillChips) do
            if chip then
                local properties = chip:GetProperties()
                if properties then
                    for id, value in pairs(properties) do
                        local newValue = self.propertyData:GetProperty(id) or 0 + value
                        self.propertyData:SetProperty(id, newValue)
                    end
                end
            end
        end
    end

    -- 无人机属性 
    local weaponAtk = self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponAtk) -- (HeroEffectDefine.TacticalWeaponAtk_Result)
    -- 50099*(1+50088)
    weaponAtk = weaponAtk + self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponAtk_Battle_Add) * (1 + self.propertyData:GetProperty(50088))
    self.propertyData:SetProperty(HeroEffectDefine.PhysicalAttack, weaponAtk)

    -- effect
    local weaponHp = self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponHp)
    -- 50098(1+50087)
    weaponHp = weaponHp + self.propertyData:GetProperty(HeroEffectDefine.TacticalWeaponHp_Battle_Add) * (1 + self.propertyData:GetProperty(50087))

    -- 命中 暴击率等
    local tmeplate = self.weaponData.template
    if tmeplate and not table.IsNullOrEmpty(tmeplate.base_attr) then
        for id, value in pairs(tmeplate.base_attr) do
            self.propertyData:SetProperty(id, value)
        end
    end

    self.maxBlood = weaponHp
    self.curBlood = self.maxBlood
end

function TacticalWeaponMember:InitWeaponData()
    if not self.weaponData then
        -- self.propertyData = HeroPropertyData.New()
        Logger.LogError("获取战术武器数据失败，heroUuid：")
        return
    end
    self.levelTemplate = self.weaponData.levelTemplate
    self.curBlood = 1
    self.maxBlood = 1
    self:InitUnitProperties(self.campBuff,self.skillChips)
end


function TacticalWeaponMember:GetRawProperty(theType)
    if not self.propertyData then
        return 0
    end
    return self.propertyData:GetProperty(theType)
end


function TacticalWeaponMember:InitFSM()
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

function TacticalWeaponMember:ComponentDefine()
    base.ComponentDefine(self)

    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    if not self.anim then
        Logger.LogError("该单位下面没挂SimpleAnimation脚本，gameObject:" .. self.gameObject.name)
    end

    self.rendererArray = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
    self.modelValid = not IsNull(self.rendererArray)
    if self.modelValid then
        local length = self.rendererArray.Length - 1
        for i = 0, length do
            self.rendererArray[i].enabled = self.modelVisible
        end
        --self.rendererArray.enabled = self.modelVisible
    end

    if self.anim then
        self.anim.cullingMode = CS.UnityEngine.AnimatorCullingMode.AlwaysAnimate
    end
    
    if self.appearanceMeta then
        -- 设置大小
        self.transform:Set_localScale(self.appearanceMeta.model_size, self.appearanceMeta.model_size, self.appearanceMeta.model_size)
        -- 加载武器
        local fire_path = self.appearanceMeta.fire_path
        self.firePoint = self.transform:Find(fire_path)
        if not self.firePoint or string.IsNullOrEmpty(fire_path) then
            -- Logger.LogError("开火点路径配置错误，路径不应包含预制体名，外观id：" ..
            --                     self.hero.modelId .. "，开火点路径：" .. fire_path)
        end
        if self.isHuman then
            self.cannon = self.transform
        else
            local canon_path = self.appearanceMeta.canon_path
            self.cannon = self.transform:Find(canon_path)
            if not self.cannon or string.IsNullOrEmpty(canon_path) then
                -- Logger.LogError("炮台路径配置错误，注意路径不应包含预制体名，外观id：" ..
                --                     self.hero.modelId .. "，炮台路径：" .. canon_path)
            else
                self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            end
            -- 炮台旋转修正
            local canonFix = self.appearanceMeta.canon_rotation
            if canonFix and #canonFix == 3 then -- 存在修正
                self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
            end
        end
        self.angular_speed_deg = 360--self.meta.angular_speed * 60
    end

    local _objTransform = self.gameObject.transform
    self.vfxCollide = _objTransform:Find("VFX_Collide")

    --无人机不显示脚底圆圈
    --self.effReq = Resource:InstantiateAsync(MemberEffect)
    --self.effReq:completed('+', function(effreq)
    --    local effGo = effreq.gameObject
    --    effGo.transform:SetParent(self.transform)
    --    effGo.transform:Set_localPosition(0, 0, 0)
    --end)
    self:InitSkill(self.skillChips)
end

function TacticalWeaponMember:InitSkill()
    if not self.levelTemplate then
        return
    end
    if self.skillManager then
        self.skillManager:RemoveAllSkills()
    end
    -- 加载本地技能配置
    local skills = self.levelTemplate:GetSkillInfos()
    for _, skillInfo in pairs(skills) do
        if skillInfo.skillTemplateData == nil then
            Logger.LogError("添加技能时，技能配置找不到,技能Id：" .. skillInfo.id)
        else
            self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo,true)
        end
    end
    -- 无人机技能
    if self.skillChips then
        for _, skillChip in pairs(self.skillChips) do
            local skillInfo = skillChip:GetSkillInfo()
            if skillInfo ~= nil then
                if skillInfo.skillTemplateData == nil then
                    Logger.LogError("添加技能时，技能配置找不到,技能Id：" .. skillInfo.id)
                end
                self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, false)
            end

            local additionalSkillInfo = skillChip:GetAdditionalSkillInfo()
            if additionalSkillInfo ~= nil then
                if additionalSkillInfo.skillTemplateData == nil then
                    Logger.LogError("添加技能时，技能配置找不到,技能Id：" .. additionalSkillInfo.id)
                end
                self.skillManager:AddSkill(additionalSkillInfo.skillTemplateData, additionalSkillInfo, false)
            end
            --::continue::
        end

    end
end



function TacticalWeaponMember:GetCannonTransform()
    return self.cannon
end


function TacticalWeaponMember:GetTransform()
    return self.transform
end

function TacticalWeaponMember:GetGameObject()
    return self.gameObject
end

function TacticalWeaponMember:GetFirePoint()
    if self.firePoint ~= nil then
        return self.firePoint
    end
    if self.transform ~= nil then
        return self.transform
    end
    return Vector3.New(0,0,0)
end



function TacticalWeaponMember:OnUpdate()
    base.OnUpdate(self)
    if self.fsm then
        self.fsm:OnUpdate()
    end
    if self.upFsm then
        self.upFsm:OnUpdate()
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

    if self.delayShow > 0 then
        self.delayShow = self.delayShow - 1
        if self.delayShow == 0 then
            local length = self.rendererArray.Length - 1
            for i = 0, length do
                self.rendererArray[i].enabled = true
            end

            --self.rendererArray.enabled = true
        end
    end

    local skillManagerValid = self.skillManager

    if skillManagerValid then
        local casting = self.skillManager:GetCastingSkill() ~= nil
        if casting then
            if not self.modelVisible then
                self.modelVisible = true
                if self.modelValid then
                    --下一帧再开渲染
                    self.delayShow = 1
                    --self.renderer.enabled = true
                end
            end
        else
            if self.modelVisible then
                self.modelVisible = false
                self.delayShow = 0
                if self.modelValid then
                    --self.rendererArray.enabled = false
                    local length = self.rendererArray.Length - 1
                    for i = 0, length do
                        self.rendererArray[i].enabled = false
                    end

                end
            end
        end

    end
end

function TacticalWeaponMember:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff)
    return
end

function TacticalWeaponMember:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
    return
end

---检查是否进入警戒状态（警戒范围内是否有敌人）
function TacticalWeaponMember:CheckEnemyInAlertRange()
    return self.battleMgr and PveUtil.CheckHasUnitInSphereRange(self.battleMgr,self:GetPosition(),
            Const.MEMBER_ALERT_RADIUS,LayerMask.GetMask("Zombie"),nil,1)
end

function TacticalWeaponMember:IsMoving()
    return self.fsm and self.fsm:GetStateIndex()==MemberState.Move
end

function TacticalWeaponMember:IsSuperArmor()--狂飙状态
    self.superArmor = false
    local buff = self.buffManager:GetPropertyBuff(HeroEffectDefine.SuperArmor)
    if buff > 0 then
        self.superArmor = true
    end
    return self.superArmor
end

function TacticalWeaponMember:GetCurAndMaxHp()
    return self.curBlood,self.maxBlood
end

function TacticalWeaponMember:GetLocationType()
    return LocationType.None
end

function TacticalWeaponMember:GetHeroCamp()
    return HeroType.NONE
end

function TacticalWeaponMember:UltimateIsReady()
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

function TacticalWeaponMember:UltimateIsLock()
    if self.skillManager then
        local ultimateSkill = self.skillManager:GetUltimateSkill()
        return ultimateSkill and ultimateSkill.lock
    else
        return false
    end
end


function TacticalWeaponMember:GetUltimateTimeStopDuration()
    return self.skillManager:GetUltimateTimeStopDuration()
end

function TacticalWeaponMember:ChangeStage(stage)
    if stage == BarrageState.PreExit then
        self:SetInvincible(true)
    elseif stage == BarrageState.Exit then
        self:SetInvincible(true)
        if self.transform then
            self.battleMgr:ShowEffectObj(
                    "Assets/_Art/Effect_B/Prefab/Common/Eff_duiwujiasu.prefab",self.transform.localPosition,nil,-1,self.transform.parent)
        end
    elseif stage == BarrageState.Lose then
        if self.fsm then
            self.fsm:ChangeState(MemberState.Dead)
        end
    end
end

function TacticalWeaponMember:OnBuffAdded(buff)
    base.OnBuffAdded(self, buff)
    return
end

function TacticalWeaponMember:OnBuffRemoved(buff)
    return
end

function TacticalWeaponMember:InterruptSkill()
    if self.skillManager then
        self.skillManager:Interrupt()
    end
end

function TacticalWeaponMember:HandleInput(command,param)
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

function TacticalWeaponMember:ChangeSkillChips(skillChips)
    skillChips = skillChips ~= nil and skillChips or {}
    self.skillChips = skillChips
    self:InitUnitProperties(self.campBuff,self.skillChips)
    self:InitSkill(self.skillChips)
end

---被动技能触发
---@param skill Scene.LWBattle.Skill.Skill
function TacticalWeaponMember:OnPassiveSkillCast(skill)
    base.OnPassiveSkillCast(self, skill)

    EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)

end


return TacticalWeaponMember