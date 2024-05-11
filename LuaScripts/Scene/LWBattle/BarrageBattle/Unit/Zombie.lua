---
--- PVE 丧尸
---

local base = require("Scene.LWBattle.BarrageBattle.Unit.BarrageUnit")

---@class Scene.LWBattle.BarrageBattle.Unit.Zombie
local Zombie = BaseClass("Zombie",base)

local Resource = CS.GameEntry.Resource
local Const = require("Scene.LWBattle.Const")
local ZombieStateIdle = require"Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateIdle"
local ZombieStateRun = require"Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateRun"
local ZombieStateAttack = require"Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateAttack"
local ZombieStateDie = require"Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateDie"
local ZombieStateHardControl = require"Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateHardControl"
local FSM=require("Framework.Common.FSM")
local LWBattleRVOAgent = CS.LWBattleRVOAgent
local HPBarCell = require "DataCenter.ZombieBattle.HpBar.HpBarCell"
local MultHpBarCell = require "DataCenter.ZombieBattle.HpBar.MultHpBarCell"
local EliteEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_purple.prefab"
local BossEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_orange.prefab"
local TargetEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_yellow.prefab"
local TargetArrowEffect = "Assets/Main/Prefabs/Guide/GuideWorldArrow.prefab"

local ColliderArrayCapacity=20


function Zombie:Init(battleMgr, guid, meta)
    base.Init(self,battleMgr, guid, meta)
    self.unitType=self.meta.monster_type == Const.MonsterType.Junk and UnitType.Junk or UnitType.Zombie
    self.currState = nil
    --self.battleMgr = battleMgr---@type DataCenter.ZombieBattle.ZombieBattleManager
    self.stateList = {}
    self.attackTargetId = nil
    self.pathIndex = 2
    self.isVisible = true
    self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), ColliderArrayCapacity)
    self.agent=nil--@type CS.LWBattleRVOAgent
    self.sid = 0
    self.hpBonus =1
    self.heroEffectMeta=DataCenter.PveHeroEffectTemplateManager:GetTemplate(meta.monster_effect)
    self.outOfRangeCD=1
end


---@param pos Common.Tools.UnityEngine.Vector3
function Zombie:Create(pos)
    --在预制体加载完成前，数据必须先初始化
    self.curWorldPos=pos
    --最终生命50014=英雄50006*(1+75050)
    self.curBlood = self:GetRawProperty(HeroEffectDefine.HealthPoint)*(1+self:GetRawProperty(HeroEffectDefine.HpAddRate)) * self.hpBonus
    self.maxBlood = self.curBlood
    
    self.req = Resource:InstantiateAsync(self.meta.asset)
    self.req:completed('+', function(req)
        if req.isError then
            return
        end
        local gameObject = req.gameObject
        local transform = gameObject.transform
        self.gameObject = gameObject
        self.transform = transform
        self:ComponentDefine()
        transform.localScale=Vector3.one*self.meta.model_size
        transform:Set_position(pos.x,pos.y,pos.z)
        gameObject:SetActive(self.isVisible)
        
        if self.meta.monster_type == Const.MonsterType.Boss then
            self.hpBar = MultHpBarCell.New(Const.HPBarStyle.Enemy,transform,self.meta.hp_bar_height,self.meta.hp_bar_num)
            self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
        end
        self.sid = self.battleMgr.rvoMgr:AddAgent(pos,gameObject,5,self.meta.collide_radius)
        self.agent=transform:GetComponent(typeof(LWBattleRVOAgent))
        
        --PveUtil.SetLayerRecursively(self.gameObject,"Default")
        self.gameObject.name=UnitType2String[self.unitType]..self.guid
        if self.unitType==UnitType.Junk then
            self.collider.gameObject.layer=LayerMask.NameToLayer("Junk")
            self:RemoveDestination()
        else
            self.collider.gameObject.layer=LayerMask.NameToLayer("Zombie")
            self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
            self.animator = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator), true)
            --if not self.anim then
            --    Logger.LogError("该单位下面没挂SimpleAnimation脚本，gameObject:"..self.gameObject.name)
            --end
            if not PVE_TEST_MODE then
                self:InitFsm()
            else
                if self.agent then
                    self.agent.speed = 0--暂停移动
                    self.agent:SetActive(false)
                end
            end
        end
        
        self:InitSkills()
        

        local effectPath = nil
        local winCondition = self.battleMgr.pveTemplate.winCondition

        if self.meta.monster_type == Const.MonsterType.Boss then
            effectPath = BossEffect
        else
            if self.meta.monster_type == Const.MonsterType.Elite then
                effectPath = EliteEffect
            end
            if winCondition.winType == Const.StageWinType.KillTargetMonster 
                    and winCondition.needKillTargetId == self.meta.id
            then
                effectPath = TargetEffect
            end
        end

        if effectPath ~= nil  then
            self.effReq = Resource:InstantiateAsync(effectPath)
            self.effReq:completed('+', function(effreq)
                local effGo = effreq.gameObject
                effGo.transform:SetParent(self.transform)
                effGo.transform:Set_localPosition(0, 0, 0)
                -- effGo.transform:Set_localScale(self.meta.collide_radius,1,self.meta.collide_radius)
                effGo.transform:Set_localScale(2 / self.transform.localScale.x, 1, 2 / self.transform.localScale.z)
            end)
        end
        
        if winCondition.winType == Const.StageWinType.KillTargetMonster and winCondition.needKillTargetId == self.meta.id then
            self.arrowReq = Resource:InstantiateAsync(TargetArrowEffect)
            self.arrowReq:completed('+', function(arrowreq)
                local effGo = arrowreq.gameObject
                effGo.transform:SetParent(self.transform)
                effGo.transform:Set_localPosition(0, self.meta.hp_bar_height, 0)
                -- effGo.transform:Set_localScale(self.meta.collide_radius,1,self.meta.collide_radius)
                effGo.transform:Set_localScale(2 / self.transform.localScale.x, 1, 2 / self.transform.localScale.z)
            end)
        end
        
    end)
end

function Zombie:DestroyView()
    base.DestroyView(self)
    self.gameObject = nil
    self.transform = nil
    if self.fsm then
        self.fsm:Delete()
        self.fsm = nil
    end
    if self.effReq ~= nil then
        self.effReq:Destroy()
        self.effReq = nil
    end
    if self.arrowReq ~= nil then
        self.arrowReq:Destroy()
        self.arrowReq = nil
    end
    
    if self.hpBar then
        self.hpBar:Destroy()
        self.hpBar = nil
    end

    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil
    end

    if self.agent then
        CS.UnityEngine.GameObject.Destroy(self.agent)
        self.agent = nil
    end
    
    if self.JunkDeadTimer then
        self.JunkDeadTimer:Stop()
        self.JunkDeadTimer = nil
    end
    self.anim=nil
end

function Zombie:DestroyData()
    self.isAlert=nil
    self.overwriteMeta = nil
    base.DestroyData(self)
    
end

--覆盖作用号
function Zombie:OverwriteEffectNum(maxHp,monsterMeta)
    self.overwriteMeta = monsterMeta
    self.curBlood = maxHp
    self.maxBlood = maxHp
end

function Zombie:InitFsm()
    self.fsm=FSM.New()---@type Framework.Common.FSM
    self.fsm:AddState(ZombieState.Idle,ZombieStateIdle.New(self))
    self.fsm:AddState(ZombieState.Run,ZombieStateRun.New(self))
    self.fsm:AddState(ZombieState.Attack,ZombieStateAttack.New(self))
    self.fsm:AddState(ZombieState.Die,ZombieStateDie.New(self))
    self.fsm:AddState(ZombieState.HardControl,ZombieStateHardControl.New(self))
    self.fsm:ChangeState(ZombieState.Idle)
end

function Zombie:InitSkills()
    if self.meta.skill then
        for _,skillId in pairs(self.meta.skill) do
            local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
            if skillMeta == nil then
                Logger.LogError("技能表中没有id为"..skillId.."的技能")
            end
            self.skillManager:AddSkill(skillMeta)
        end
    end
end

function Zombie:ComponentDefine()
    base.ComponentDefine(self)
end


function Zombie:OnUpdate()
    base.OnUpdate(self)
    if self.hpBar then--更新血条位置
        self.hpBar:Update()
    end
    if self.fsm then
        self.fsm:OnUpdate()
    end
    if self.meta and self.meta.monster_type ~= Const.MonsterType.Boss then
        self.outOfRangeCD = self.outOfRangeCD - Time.deltaTime
        if self.outOfRangeCD<0 then
            self.outOfRangeCD = 1
            self:CheckOutOfRenderRange()
        end
    end
end

function Zombie:CheckOutOfRenderRange()
    if self.battleMgr.squad:GetPosition().z - self:GetPosition().z > ZOMBIE_REMOVE_DISTANCE_Z then
        self.battleMgr:RemoveUnit(self) 
    end
end


function Zombie:SetVisible(visible)
    self.isVisible = visible
    if self.gameObject then
        self.gameObject:SetActive(visible)
    end
end





---@param hitPoint number @--受击点
---@param hitDir number @--受击方向
---@param whiteTime number @--闪白时间
---@param stiffTime number @--硬直时间
---@param dir Common.Tools.UnityEngine.Vector3 @--击退位移
function Zombie:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff)

    if PVE_TEST_MODE then
        return
    end
    
    self.isAlert=true
    base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff)
    
    if dir and self.unitType~=UnitType.Junk and self.meta.ignore_hit_back==0 then--击退
        if self.curBlood>0 then
            self.fsm:ChangeState(ZombieState.HardControl,HardControlType.Imprison,0.5)
        end
        self.transform:DOMove(self.transform.position+dir, 0.5)
            :SetEase(CS.DG.Tweening.Ease.OutCirc)
    elseif stiffTime>0 and self.unitType~=UnitType.Junk and self.meta.ignore_hit_stiff==0 then--硬直
        if self.curBlood>0 then
            self.fsm:ChangeState(ZombieState.HardControl,HardControlType.Stiff,stiffTime)
        end
    end
    
    --print("Zombie be attack", self.guid, self.curBlood, hurt)
    if self.curBlood <= 0 then
        --print("Zombie die", self.guid)
        --todo:优化
        if self.unitType==UnitType.Junk then
            self.battleMgr:OnMonsterDeath(self)
            self.gameObject:SetActive(false)
            self.JunkDeadTimer=TimerManager:DelayInvoke(function()
                self.battleMgr:RemoveUnit(self)
            end, 5)
        else
            self.fsm:ChangeState(ZombieState.Die)
        end
        
    end

    if hurt > 0 then
        if(self.curBlood > 0 and not self.hpBar)then
            if self.meta.hp_bar_num > 1 then
                self.hpBar = MultHpBarCell.New(Const.HPBarStyle.Enemy,self.transform,self.meta.hp_bar_height,self.meta.hp_bar_num)
                self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
            else
                self.hpBar = HPBarCell.New(Const.HPBarStyle.Enemy,self.transform,self.meta.hp_bar_height)
                self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
            end
        end
        if self.hpBar then
            if self.curBlood <= 0 then
                self.hpBar:Destroy()
                self.hpBar = nil
            else
                self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
            end
        end
    end
end


function Zombie:AfterBeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff,skill,deathEff,forceAnim)
    if PVE_TEST_MODE then
        return
    end
    
    base.AfterBeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff,skill,deathEff)
    if self.fsm and self.curBlood > 0 and (hurt > 0.5 * self.maxBlood or forceAnim) then
        self.fsm:ChangeState(ZombieState.HardControl,HardControlType.Hurt,0.5)
    end
end

function Zombie:SetDestination(x,z)
    return self.agent:SetTargetPosition(x,z)
end

function Zombie:RemoveDestination()
    return self.agent:SetActive(false)
end



function Zombie:SetPosition(pos)
    Logger.LogError("Zombie:SetPosition(pos)")
    if self.transform then
        self.transform.position = pos
    end
end

function Zombie:SetRotation(quaternion)
    if self.transform then
        self.transform.rotation = quaternion
    end
end

function Zombie:GetMoveSpeed()
    return self.meta.move_speed
end

function Zombie:GetPhysicsDefence()
    return self.meta.physics_defence
end

function Zombie:GetMagicDefence()
    return self.meta.magic_defence
end






function Zombie:CheckEnemyInAlertRange()
    return PveUtil.CheckHasUnitInSphereRange(self.battleMgr,self.transform.position,self.meta.alert_range,LayerMask.GetMask("Member"))
end


function Zombie:GetAttackTarget()
    if self.attackTargetId==nil then
        return nil
    end
    return self.battleMgr:GetUnit(self.attackTargetId)
end



function Zombie:GetFirePoint()
    return self.transform
end

function Zombie:GetRawProperty(type)
    if self.overwriteMeta then
        return self.overwriteMeta.property[type] or 0
    end
    return self.meta.property[type] or 0
end

--function Zombie:PlaySimpleAnim(name,speed)
--    base.PlaySimpleAnim(self,name,speed)
--    if speed then
--        Logger.Log(self.gameObject.name.."PlaySimpleAnim:"..name..speed)
--    else
--        Logger.Log(self.gameObject.name.."PlaySimpleAnim:"..name)
--    end
--end

function Zombie:OnBuffAdded(buff)
    base.OnBuffAdded(self, buff)
    if buff.meta.type==BuffType.Stun and self.fsm then
        self.fsm:ChangeState(ZombieState.HardControl,HardControlType.Stun,buff.duration)
    end
end

function Zombie:OnBuffRemoved(buff)
    if buff.meta.type==BuffType.Stun then
        if not self.buffManager or not self.buffManager:HasAnyBuffWithType(BuffType.Stun) then
            if self.fsm then self.fsm:ChangeState(ZombieState.Idle) end
        end
    end
end

return Zombie