---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2023/1/10 09:59
---
local base = require "Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj"

local Resource = CS.GameEntry.Resource
local Physics = CS.UnityEngine.Physics
local Const = require("Scene.LWBattle.Const")
local IdleAndSearchState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateIdle")
local DefenseRunState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.DefenseRunState")
local RunState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateRun")
local AttackState = require("Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateAttack")
local DieState = require("Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.FSM.CommonAI.DieState")
local ZombieStateHardControl = require"Scene.LWBattle.BarrageBattle.ZombieState.ZombieStateHardControl"
local FSM=require("Framework.Common.FSM")
local LWBattleRVOAgent = CS.LWBattleRVOAgent
local HPBarCell = require "DataCenter.ZombieBattle.HpBar.HpBarCell"
local MultHpBarCell = require "DataCenter.ZombieBattle.HpBar.MultHpBarCell"
local EliteEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_purple.prefab"
local BossEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_orange.prefab"
local TargetEffect = "Assets/_Art/Effect_B/Prefab/Common/Eff_ring_yellow.prefab"
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")

---@class Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.CommonAIMonster : Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.MonsterObj
local CommonAIMonster = BaseClass("CommonAIMonster",base)

function CommonAIMonster:Init(logic,mgr,guid,x,y,monsterMeta)
    base.Init(self,logic,mgr,guid,x,y,monsterMeta)
    self.rotation = Quaternion.identity
    self.currState = nil
    self.stateList = {}
    self.tombstone = nil
    self.attackTargetId = nil
    self.pathIndex = 2
    self.isVisible = true
    self.colliderArray = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Collider), 20)
    self.agent=nil--@type CS.LWBattleRVOAgent
    self.sid = 0
    self.skillManager = SkillManager.New(self.logic,self)---@type Scene.LWBattle.Skill.SkillManager
    self.outOfRangeCD = 1

    if monsterMeta.is_boss == 1 or monsterMeta.monster_type == Const.MonsterType.Boss then
        -- boss 显示界面预警
        EventManager:GetInstance():Broadcast(EventId.ParkourBossEnterBattle)
    end
end


function CommonAIMonster:DestroyView()
    base.DestroyView(self)
    if self.hpBar then
        self.hpBar:Destroy()
        self.hpBar = nil
    end
    if self.fsm then
        self.fsm:Delete()
        self.fsm = nil
    end
    if self.skillManager then
        self.skillManager:DestroyView()
    end
    if self.agent then
        CS.UnityEngine.GameObject.Destroy(self.agent)
        self.agent=nil
    end
    self.anim=nil
end


function CommonAIMonster:DestroyData()
    base.DestroyData(self)
    if self.skillManager then
        self.skillManager:DestroyData()
        self.skillManager = nil
    end
    self.isAlert=nil
end


function CommonAIMonster:ComponentDefine()
    base.ComponentDefine(self)    
    self.anim = self.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    --if not self.anim then
    --    Logger.LogError("该单位下面没挂SimpleAnimation脚本，gameObject:"..self.gameObject.name)
    --end
    --self.shadowGo = self.transform:Find("Shadow").gameObject
    --if DataCenter.LWBattleManager.qualityLevel <= EnumQualityLevel.Low then
    --    PveUtil.SetLayerRecursively(self.gameObject, "Default")
    --    self.shadowGo:SetActive(true)
    --else
    --    PveUtil.SetLayerRecursively(self.gameObject, "OutlineAndShadow")
    --    self.shadowGo:SetActive(false)
    --end
    self.collider.gameObject.layer=LayerMask.NameToLayer("Zombie")
end

function CommonAIMonster:OnLoadComplete()
    local pos = self.transform.position
    self.sid = self.mgr.logic.rvoMgr:AddAgent(pos,self.gameObject,5,self.monsterMeta.collide_radius)
    self.agent= self.transform:GetComponent(typeof(LWBattleRVOAgent))
    self.gameObject.name = "Zombie_" .. tostring(self.sid)
    self:InitSkills()
    self:InitFsm()
    if self.monsterMeta.monster_type == Const.MonsterType.Boss then
        self:InitHpBar()
    end

    self.transform:Set_localEulerAngles(0, 180, 0)
end
function CommonAIMonster:InitHpBar()
    if not self.hpBar then
        if self.monsterMeta.hp_bar_num > 1 then
            self.hpBar = MultHpBarCell.New(Const.HPBarStyle.Enemy,self.transform,self.monsterMeta.hp_bar_height,self.monsterMeta.hp_bar_num)
            self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
        else
            self.hpBar = HPBarCell.New(Const.HPBarStyle.Enemy,self.transform,self.monsterMeta.hp_bar_height)
            self.hpBar:LoadAndSetHp(self.curBlood, self.maxBlood)
        end
    end
    
end
function CommonAIMonster:InitSkills()
    if self.monsterMeta.skill then
        for _,skillId in pairs(self.monsterMeta.skill) do
            local skillMeta = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
            if skillMeta == nil then
                Logger.LogError("技能表中没有id为"..skillId.."的技能")
            end
            self.skillManager:AddSkill(skillMeta)
        end
    end
end
function CommonAIMonster:TriggerSkill(triggerType,param)
    if self.skillManager then
        self.skillManager:PassiveCast(triggerType,param)
    end
end
function CommonAIMonster:InitFsm()
    self.fsm=FSM.New()---@type Framework.Common.FSM
    if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
        self.fsm:AddState(ZombieState.Idle,DefenseRunState.New(self))
    else
        self.fsm:AddState(ZombieState.Idle,IdleAndSearchState.New(self))
    end
    
    self.fsm:AddState(ZombieState.Run,RunState.New(self))
    self.fsm:AddState(ZombieState.Attack,AttackState.New(self))
    self.fsm:AddState(ZombieState.Die,DieState.New(self))
    self.fsm:AddState(ZombieState.HardControl,ZombieStateHardControl.New(self))
    self.fsm:ChangeState(ZombieState.Idle)
end
function CommonAIMonster:SetVisible(visible)
    self.isVisible = visible
    if self.gameObject then
        self.gameObject:SetActive(visible)
    end
end
function CommonAIMonster:OnUpdate()
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
    if self.monsterMeta.monster_type ~= Const.MonsterType.Boss then
        self.outOfRangeCD = self.outOfRangeCD - Time.deltaTime
        if self.outOfRangeCD<0 then
            self.outOfRangeCD = 1
            self:CheckOutOfRenderRange()
        end
    end
    
    --todo by wsf 塔防模式没有更新commonAIMonster的 self.y，需要从transform读取，AI怪会自动走向小队，暂时不更新了，有需要时再更新
end

function CommonAIMonster:CheckOutOfRenderRange()
    if self.battleMgr.team:GetPosition().z - self:GetPosition().z > ZOMBIE_REMOVE_DISTANCE_Z then
        self.mgr:RemoveMonster(self.guid)
    end
end

function CommonAIMonster:GetCurBlood()
    return self.curBlood
end


function CommonAIMonster:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff)
    base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,dir,hitEff)
    
    if (not self.logic.battleType) or self.logic.battleType == Const.ParkourBattleType.Attack then
        --跑酷关卡，只有正常进攻模式被击中才进警界状态，塔防模式需要到达配置的警界范围才行
        self.isAlert=true
    end
    if hurt > 0 and self.curBlood > 0 then
        if not self.hpBar then
            self:InitHpBar()
        end
        self.hpBar:SetHp(self.curBlood, self.maxBlood, self:GetShieldValue())
    end

    self:BeAttackEffect(stiffTime, dir)
    --触发死亡时被动技能
    if self.curBlood <= 0 then
        self:TriggerSkill(SkillTriggerType.Death)
    end
end

--受击效果处理
function CommonAIMonster:BeAttackEffect(stiffTime,dir)
    if dir and self.meta.ignore_hit_back==0 then--击退
        if self.curBlood>0 then
            self.fsm:ChangeState(ZombieState.HardControl,HardControlType.Imprison,0.5)
        end
        self.transform:DOMove(self.transform.position+dir, 0.5)
            :SetEase(CS.DG.Tweening.Ease.OutCirc)
    elseif stiffTime>0 and self.meta.ignore_hit_stiff==0 then--硬直
        if self.curBlood>0 then
            self.fsm:ChangeState(ZombieState.HardControl,HardControlType.Stiff,stiffTime)
        end
    end
    
end

--override
function CommonAIMonster:Death()
    if self.fsm then
        self.fsm:ChangeState(ZombieState.Die)
    end
    if self.hpBar then
        self.hpBar:Destroy()
        self.hpBar = nil
    end
end

function CommonAIMonster:CreateBeHitEffect()
    
end

function CommonAIMonster:SetDestination(x,z)
    return self.agent:SetTargetPosition(x,z)
end

function CommonAIMonster:RemoveDestination()
    return self.agent:SetActive(false)
end

function CommonAIMonster:CheckEnemyInAlertRange()
    local posZ = self.mgr.logic.team:GetPositionZ()
    return math.abs(self.transform.position.z - posZ) <= self.meta.alert_range
end
function CommonAIMonster:GetFirePoint()
    return self.transform
end

function CommonAIMonster:OnBuffAdded(buff)
    if buff.meta.type==BuffType.Imprison and self.agent then

        --禁锢不能移动
        self.agent.speed = 0
    end
    
    base.OnBuffAdded(self, buff)
    
end

function CommonAIMonster:OnBuffRemoved(buff)

    if buff.meta.type==BuffType.Imprison then
        if not self.buffManager or not self.buffManager:HasAnyBuffWithType(BuffType.Imprison) then
            if self.agent and self.logic and self.fsm then
                if self.fsm:GetStateIndex() == ZombieState.Idle then
                    if self.logic.battleType and self.logic.battleType == Const.ParkourBattleType.Defense then
                        self.agent.speed = self.logic:GetMoveSpeedZ()
                    else
                        self.agent.speed = 1
                    end

                else
                    self.agent.speed = self.meta.move_speed

                    --self:PlaySimpleAnim(ZombieAnim.Run,1)
                end
                
            end
        end
    end
    
    base.OnBuffRemoved(self, buff)
end

return CommonAIMonster