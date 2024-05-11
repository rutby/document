---
--- PVE 单位基类。英雄、丧尸、路障的基类
---
---@type Scene.LWBattle.UnitBase
local base = require("Scene.LWBattle.UnitBase")
---@class Scene.LWBattle.BarrageBattle.Unit.BarrageUnit : Scene.LWBattle.UnitBase
---@field skillManager Scene.LWBattle.Skill.SkillManager
local BarrageUnit = BaseClass("BarrageUnit",base)
---@type Scene.LWBattle.Skill.SkillManager
local SkillManager = require("Scene.LWBattle.Skill.SkillManager")



function BarrageUnit:Init(battleMgr, guid, meta)
    base.Init(self,battleMgr, guid, meta)
    self.battleMgr = battleMgr---@type DataCenter.ZombieBattle.ZombieBattleManager
    self.guid = guid
    self.unitType=nil
    self.meta = meta
    self.isVisible = true
    self.skillManager = SkillManager.New(self.battleMgr,self)---@type Scene.LWBattle.Skill.SkillManager
end

function BarrageUnit:DestroyView()
    base.DestroyView(self)
    if self.skillManager then
        self.skillManager:DestroyView()
    end
end

function BarrageUnit:DestroyData()
    base.DestroyData(self)
    if self.skillManager then
        self.skillManager:DestroyData()
        self.skillManager=nil
    end
    self.battleMgr = nil
end



function BarrageUnit:OnUpdate()
    base.OnUpdate(self)
    if self.skillManager then
        self.skillManager:OnUpdate()
    end
end



function BarrageUnit:TriggerSkill(triggerType,param)
    if self.skillManager then
        self.skillManager:PassiveCast(triggerType,param)
    end
end

function BarrageUnit:SetVisible(visible)
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
function BarrageUnit:BeAttack(hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)
    base.BeAttack(self,hurt,hitPoint,hitDir,whiteTime,stiffTime,hitBackDistance,hitEff)

    --扣护盾
    hurt = self:ReduceShieldValue(hurt)
    
    --扣血
    self.curBlood = math.max(self.curBlood - hurt, 0)

    --触发死亡时被动技能
    if self.curBlood <= 0 then
        self:TriggerSkill(SkillTriggerType.Death)
    end
    
end





return BarrageUnit