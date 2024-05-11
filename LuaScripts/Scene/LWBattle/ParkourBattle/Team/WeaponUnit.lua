---
---无人机，继承自MemberUnit
---
local base = require("Scene.LWBattle.ParkourBattle.Team.MemberUnit")
---@class Scene.LWBattle.ParkourBattle.Team.WeaponUnit : Scene.LWBattle.ParkourBattle.Team.MemberUnit
---@field hero HeroInfo
---@field skillManager Scene.LWBattle.Skill.SkillManager
local WeaponUnit = BaseClass("WeaponUnit",base)


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
--死亡
local StateDead = require("Scene.LWBattle.ParkourBattle.Team.FSM.DeathState")
local Const = require("Scene.LWBattle.Const")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
--local SkillBarCell = require "DataCenter.ZombieBattle.HpBar.WeaponSkillBarCell"

function WeaponUnit:Init(logic, team, parent, localPos, weapon, appearanceMeta,skillChips)
    base.Init(self,logic,team,parent,localPos)
    self.type = Const.ParkourUnitType.Weapon
    self.isHuman = false
    self.unitType = UnitType.TacticalWeapon
    self.weaponData = weapon
    local path = "Assets/Main/Prefabs/LWBattle/Hero/army_t1_01.prefab"
    self.appearanceMeta = appearanceMeta
    if self.appearanceMeta then
        path = self.appearanceMeta.model_path
        self.appearanceId = self.appearanceMeta.id
    end
    self.skillChips = skillChips
    self:InitWeaponData(skillChips)
    self.maxBlood = 1
    self.curBlood = 1
    
    self.modelVisible = false
    self.modelValid = false
    self.delayShow = 0
    
    self.curPosX = self.localPosition.x
    self.curPosY = self.localPosition.y
    self.curPosZ = self.localPosition.z

    self.req = Resource:InstantiateAsync(path)
    self.req:completed('+', function(request)
        self.gameObject = request.gameObject
        self.transform = request.gameObject.transform
        self.transform:SetParent(self.parent)
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_eulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
        self.transform:SetParent(nil) --无人机不跟随队伍横向移动
        self.curPosX, self.curPosY, self.curPosZ = self.transform:Get_position()
        self:ComponentDefine()
        self:InitFSM()

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
            --由于不释放技能时，隐藏了mesh，所以不能用CullCompletely模式，否则开启渲染的第一帧会看见TPose
            self.anim.cullingMode = CS.UnityEngine.AnimatorCullingMode.AlwaysAnimate
        end

        local appearanceMeta = self.appearanceMeta
        if appearanceMeta then
            -- 设置大小
            self.transform:Set_localScale(appearanceMeta.model_size, appearanceMeta.model_size,
                appearanceMeta.model_size)
            local fire_path = appearanceMeta.fire_path
            self.firePoint = self.transform:Find(fire_path)
            if not self.firePoint or string.IsNullOrEmpty(fire_path) then
                Logger.LogError("开火点路径配置错误，路径不应包含预制体名，外观id：" ..
                                    self.hero.modelId .. "，开火点路径：" .. fire_path)
            end
            local canon_path = appearanceMeta.canon_path
            self.cannon = self.transform:Find(canon_path)
            if not self.cannon or string.IsNullOrEmpty(canon_path) then
                Logger.LogError("炮台路径配置错误，注意路径不应包含预制体名，外观id：" ..
                                    self.hero.modelId .. "，炮台路径：" .. canon_path)
            else
                self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            end
            local canonFix = appearanceMeta.canon_rotation -- 炮台旋转修正
            if canonFix and #canonFix == 3 then -- 存在修正
                self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
            end
        end
        self.angular_speed_deg = 360
        self:ShowBornEffect()
        self:InitSkill(self.skillChips)
        if self.isExiting then
            self:StartExiting()
        end
    end)
end

function WeaponUnit:ComponentDefine()
    base.ComponentDefine(self)
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    --PveUtil.SetLayerRecursively(self.gameObject,"Default")
    -- self.collider.gameObject.layer=LayerMask.NameToLayer("Member")
end

function WeaponUnit:InitUnitProperties(skillChips)
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

function WeaponUnit:InitWeaponData()
    self.skillManager = SkillManager.New(self.logic, self) ---@type Scene.LWBattle.Skill.SkillManager
    self.skillManager.battleMgr = DataCenter.LWBattleManager.logic

    self.propertyData = DeepCopy(self.weaponData:GetPropetyData())

    self:InitUnitProperties(self.skillChips)
end


function WeaponUnit:InitSkill(skillChips)
    if not self.weaponData then
        return
    end
    if self.skillManager then
        self.skillManager:RemoveAllSkills()
    end
    local skillInfos = self.weaponData:GetSkillInfos()
    for _, skillInfo in pairs(skillInfos) do
        self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, false)
        break
    end
    -- 无人机技能
    if skillChips then
        for _, skillChip in pairs(skillChips) do
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

function WeaponUnit:InitFSM()
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
    self.fsm:AddState(Const.ParkourFireState.Dead,StateDead.New(self))
    self.fsm:ChangeState(Const.ParkourFireState.Stay)
    --运动状态机
    base.InitFSM(self)
end

function WeaponUnit:OnUpdate()
    base.OnUpdate(self)

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
    
    if self.fsm then
        self.fsm:OnUpdate()
    end
    if skillManagerValid then
        self.skillManager:OnUpdate()
    end
end



function WeaponUnit:GetFirePoint()
    return self.firePoint
end

function WeaponUnit:GetMoveVelocity()
    if self.fsm and self.fsm:GetStateIndex()==Const.ParkourFireState.Straight then
        return Vector3.New(0,0,self.team.speedZ)
    else
        return Vector3.zero
    end
end

function WeaponUnit:DestroyView()
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
end

function WeaponUnit:DestroyData()
    base.DestroyData(self)
    if self.skillManager then
        self.skillManager:DestroyData()
        self.skillManager = nil
    end
end

function WeaponUnit:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
    -- if self.invincible then
    --     return
    -- end
    -- base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
    -- if(hurt > 0 ) then
    --     self.curBlood = math.max(self.curBlood - hurt, 0)
        
    --     if self.curBlood <= 0 then
    --         DataCenter.LWBattleManager.logic:DealMemberDie(self)
    --     end
    -- end
end

function WeaponUnit:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
    -- if self.invincible then
    --     return
    -- end
    -- base.AfterBeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
end



function WeaponUnit:GetRawProperty(type)
    if self.propertyData == nil then
        return 0
    end
    return self.propertyData:GetProperty(type)
end


function WeaponUnit:ChangeStage(stage)
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
            --无人机都改成自由攻击模式
            self.fsm:ChangeState(Const.ParkourFireState.RotateAndShoot)
        end

        if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
            --塔防模式增加头顶技能栏显示
            --if self.weaponData.id > 0 then
            --    if not self.skillBar then
            --        self.skillBar = SkillBarCell.New()
            --        self.skillBar:Load(self, self.transform, 2)
            --    end
            --end
        end
    elseif stage == Const.ParkourBattleState.Lose then
        if self.skillBar then
            self.skillBar:SetActive(false)
        end
        if self.fsm then
            self.fsm:ChangeState(Const.ParkourFireState.Dead)
        end
    end
end

function WeaponUnit:GetMoveSpeed()
    return 1
end

function WeaponUnit:OnFingerDown(pos)
    base.OnFingerDown(self)
    if self:GetState(AnimName.Run) then
        self:PlaySimpleAnim(AnimName.Run)
    elseif self:GetState(AnimName.Walk) then
        self:PlaySimpleAnim(AnimName.Walk)
    end
end

function WeaponUnit:OnFingerUp()
    base.OnFingerUp(self)
    if self:GetState(AnimName.Idle) then
        self:PlaySimpleAnim(AnimName.Idle)
    end
end


function WeaponUnit:ChangeSkillChips(skillChips)
    skillChips = skillChips ~= nil and skillChips or {}
    self.skillChips = skillChips
    self:InitUnitProperties(self.skillChips)
    self:InitSkill(self.skillChips)
end

---被动技能触发
---@param skill Scene.LWBattle.Skill.Skill
function WeaponUnit:OnPassiveSkillCast(skill)
    base.OnPassiveSkillCast(self, skill)
    
    EventManager:GetInstance():Broadcast(EventId.OnPVETacticalWeaponCastSkill, skill)

end

function WeaponUnit:UpdateRelativePosition(x, z)
    if self.transform then
        self.curPosZ = z
        self.transform:Set_position(self.curPosX, self.curPosY, self.curPosZ)
    end
end


return WeaponUnit
