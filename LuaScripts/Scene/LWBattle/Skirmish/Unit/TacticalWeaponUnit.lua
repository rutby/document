---
---TacticalWeapon 战术武器
---
local base = require("Scene.LWBattle.Skirmish.Unit.SkirmishUnit")
---@class Scene.LWBattle.Skirmish.Unit.TacticalWeaponUnit : Scene.LWBattle.Skirmish.Unit.SkirmishUnit
local TacticalWeaponUnit = BaseClass("TacticalWeaponUnit",base)


--攻击状态之瞄准(英雄专用）
local FireStateAim=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateAim")
--攻击状态之施法(英雄专用）
local FireStateCasting=require("Scene.LWBattle.Skirmish.UnitFSM.FireStateCasting")
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")
local Resource = CS.GameEntry.Resource


function TacticalWeaponUnit:Init(logic, army, weaponData, index)
    base.Init(self,logic, army, weaponData,Vector3.zero, index)
    self.index=index
    self.army=army
    self.logic=logic
    self.sceneData = self.logic.sceneData
    self.battleData = self.logic.battleData
    self.weapon = TacticalWeaponInfo.New()
    self.weapon:CreateFromTemplate(weaponData.heroId, weaponData.heroLevel)--, weaponData.exp)
    self.weaponData = weaponData
    self.meta = self.weapon.template
    if index == 11 then
        self.unitType = UnitType.TacticalWeapon
    elseif index == 12 then
        self.unitType = UnitType.TacticalWeapon
    end
    self.appearanceMeta = nil
    local skinId = weaponData.skinId
    local appearanceId = nil
    if skinId ~= nil and skinId > 0 then
        appearanceId = DataCenter.DecorationTemplateManager:GetAppearanceIdBySkinId(skinId)
    else
        appearanceId = self.weapon:GetAppearance()
    end
    self.appearanceId = appearanceId
    self.appearanceMeta = DataCenter.AppearanceTemplateManager:GetTemplate(appearanceId)
    local path = ""
    if self.appearanceMeta then
        path = self.appearanceMeta.model_path
    end
    self.skillChips = self.weaponData.skillChips

    self.maxBlood = 1
    self.curBlood = 1
    self.initBlood = 1
    self.totalHurt = 0
    self.skillManager = SkillManager.New(self.logic, self) ---@type Scene.LWBattle.Skill.SkillManager
    self.localPosition = self.sceneData.platoonLocalPos[index]

    self.modelVisible = false
    self.modelValid = false
    self.delayShow = 0

    self.req = Resource:InstantiateAsync(path)
    self.req:completed('+', function(request)
        self.gameObject = request.gameObject
        self.transform = request.gameObject.transform
        self.transform:SetParent(self.platoon.transform)
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        self.transform:Set_localPosition(self.localPosition.x, self.localPosition.y, self.localPosition.z)
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
                                    (self.weaponData.heroId or "") .. "，开火点路径：" .. fire_path)
            else
                self.firePointOffset = Vector3.HorizonDistance(self.firePoint.position, self.transform.position) -- 开火点到中心点距离
            end
            local canon_path = appearanceMeta.canon_path
            self.cannon = self.transform:Find(canon_path)
            if not self.cannon or string.IsNullOrEmpty(canon_path) then
                Logger.LogError("炮台路径配置错误，注意路径不应包含预制体名，外观id：" ..
                                    (self.weaponData.heroId or "") .. "，prefab路径：" .. path .. "，炮台路径：" ..
                                    canon_path)
            else
                self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            end
            local canonFix = appearanceMeta.canon_rotation -- 炮台旋转修正
            if canonFix and #canonFix == 3 then -- 存在修正
                self.localForward = Vector3.forward * Quaternion.Euler(canonFix[1], canonFix[2], canonFix[3])
            end
        end
        self.angular_speed_deg = 60
        self:InitSkill()
        if self.logic then
            self.logic:AddCaptain(self.index,self)
            self.logic:AddUnit(self)
        end
    end)
end




function TacticalWeaponUnit:ComponentDefine()
    base.ComponentDefine(self)
    --PveUtil.SetLayerRecursively(self.gameObject,"Default")
    -- if self.index == 11 then--上方玩家扮演丧尸
    --     self.collider.gameObject.layer=LayerMask.NameToLayer("Member")
    -- elseif self.index == 12 then
    --     self.collider.gameObject.layer=LayerMask.NameToLayer("Zombie")
    -- end
end

function TacticalWeaponUnit:InitFSM()
    base.InitFSM(self)
    --攻击状态机
    self.fsm:AddState(SkirmishFireState.Aim,FireStateAim.New(self))
    self.fsm:AddState(SkirmishFireState.Casting,FireStateCasting.New(self))
end

function TacticalWeaponUnit:InitSkill()
    local skillInfos = self.weapon:GetSkillInfos()
    for _, skillInfo in pairs(skillInfos) do
        if skillInfo.skillTemplateData == nil then
            Logger.LogError("添加技能时，技能配置找不到,技能Id：" .. skillInfo.id)
        end
        self.skillManager:AddSkill(skillInfo.skillTemplateData, skillInfo, true)
    end

    -- 芯片技能
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



function TacticalWeaponUnit:OnUpdate()
    base.OnUpdate(self)

    if self.delayShow > 0 then
        self.delayShow = self.delayShow - 1
        if self.delayShow == 0 then
            --self.rendererArray.enabled = true
            local length = self.rendererArray.Length - 1
            for i = 0, length do
                self.rendererArray[i].enabled = true
            end

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
    
    if skillManagerValid and self.logic.stage==SkirmishStage.Fight then
        self.skillManager:OnUpdate()
    end
    -- if self.tinyHead then
    --     self.tinyHead:Update()
    -- end
end

function TacticalWeaponUnit:DestroyView()
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
    -- if self.tinyHead then
    --     self.tinyHead:Destroy()
    --     self.tinyHead = nil
    -- end
    if self.cannon then
        self.cannon:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    if self.skillManager then
        self.skillManager:DestroyView()
    end
end

function TacticalWeaponUnit:DestroyData()
    if self.skillManager then
        self.skillManager:DestroyData()
        self.skillManager = nil
    end
    base.DestroyData(self)
end

function TacticalWeaponUnit:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)

--    base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
end

function TacticalWeaponUnit:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)

--    base.AfterBeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff,skill,deathEff)
end

function TacticalWeaponUnit:GetRawProperty(type)
    return self.weaponData.effect[type] or 0
end

function TacticalWeaponUnit:DoAction(action,param)
    if action.phase==ActionPhase.Cast then
        ---@type Scene.LWBattle.Skill.Skill
        local skill = self.skillManager:GetSkillById(action.skillId)
        if not skill then
            Logger.LogError(self.index.."号位".."战术武器"..self.weaponData.heroId.."没有技能"..action.skillId)
            return
        end
        if not skill:IsActiveSkill() then
            --非主动技，不走状态机
            local targets = {}
            for _,v in pairs(action.targets) do
                table.insert(targets,self.logic:GetCaptain(v.index))
            end
            skill:Cast(targets, true)
            if self.index == 11 then
                --自己的无人机
                EventManager:GetInstance():Broadcast(EventId.OnPVPTacticalWeaponCastSkill, skill)
            end
            
        elseif skill:IsBuffSkill() then--Buff类技能，不用瞄准直接开火
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
        -- if self.index == 11 and DataCenter.HeroTemplateManager:IsUltimate(action.skillId) then
        --     EventManager:GetInstance():Broadcast(EventId.SkirmishCastUltimate,action)
        -- end
    elseif action.phase==ActionPhase.FIRE_BULLET then
        local skill = self.skillManager:GetSkillById(action.skillId)
        if not skill then
            Logger.LogError(self.index.."号位".."战术武器"..self.weaponData.heroId.."没有技能"..action.skillId)
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
        --for _,v in pairs(param.buffChanges) do
        --    local meta = DataCenter.LWBuffTemplateManager:GetTemplate(v.buffId)
        --    if meta.type==BuffType.Property then--属性变化
        --        self:AddBuff(v.buffId,v.skillLevel)
        --    elseif meta.type==BuffType.BeTaunt then--被嘲讽
        --        self:AddBuff(v.buffId,self.logic:GetCaptain(action.casterIndex))
        --    elseif meta.type==BuffType.Shield then
        --        self:AddBuff(v.buffId,self.logic:GetCaptain(action.casterIndex))
        --    end
        --end
    elseif action.phase==ActionPhase.Damage then
        -- self:DoDamageAction(action,param)
    end
end


function TacticalWeaponUnit:UnDoAction(action,param)
    if action.phase==ActionPhase.Cast then

    elseif action.phase==ActionPhase.Damage then
        -- self:UnDoDamageAction(action,param)
    end
end


function TacticalWeaponUnit:GoDie()
    base.GoDie(self)
    -- self.platoon.army:OnCaptainDie(self.index)
end

function TacticalWeaponUnit:Revive()
    base.Revive(self)
    -- self.platoon.army:OnCaptainRevive(self.index)
end

function TacticalWeaponUnit:DestroyTinyHead()
end

function TacticalWeaponUnit:ChangeStage(stage)
    base.ChangeStage(self,stage)
    if stage == SkirmishStage.Load then

    elseif stage == SkirmishStage.Opening then

    elseif stage == SkirmishStage.Fight then
        -- self:DestroyTinyHead()
    elseif stage == SkirmishStage.End then
        if self.skillManager then
            self.skillManager:Interrupt()
        end
        
        if self.battleData.topPlayerWin and self.index == 11 then
            self:GoDie()
        elseif not self.battleData.topPlayerWin and self.index == 12 then
            self:GoDie()
        end
    end
end

--返回开火点到目标中心的距离
function TacticalWeaponUnit:GetCaptainDistance(targetIndex)
    return self.sceneData:GetCaptainDistance(self.index,targetIndex)-self.firePointOffset
end

function TacticalWeaponUnit:GetPosition()
    if self.transform then
        self.curWorldPos.x,self.curWorldPos.y,self.curWorldPos.z = self.transform:Get_position()
        return self.curWorldPos
    else
        return self.army:GetPosition()+self.localPosition * self.dirMultiplier
    end
end

---被动技能触发
---@param skill Scene.LWBattle.Skill.Skill
function TacticalWeaponUnit:OnPassiveSkillCast(skill)
    base.OnPassiveSkillCast(self, skill)

    if self.index == 11 then
        EventManager:GetInstance():Broadcast(EventId.OnPVPTacticalWeaponCastSkill, skill)
        
    end

end

return TacticalWeaponUnit
