---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 3/23/22 9:59 PM
---
--[[
    这个类表示技能管理类,基本上逻辑接口为 A对B做了什么操作
]]
local PveSkillMgr = BaseClass("PveSkillMgr")
local Const = require "Scene.BattlePveModule.Const"
-- 默认
local DefaultSkill = require "Scene.BattlePveModule.SkillModule.Skill.SkillBase"
-- 普攻
local Skill_NormalAttack = require "Scene.BattlePveModule.SkillModule.Skill.Skill_NormalAttack"
-- 反击
local Skill_CounterAttack = require "Scene.BattlePveModule.SkillModule.Skill.Skill_CounterAttack"
-- 护盾攻击
local Skill_ShieldAttack = require "Scene.BattlePveModule.SkillModule.Skill.Skill_ShieldAttack"
-- 护盾
local Skill_Shield = require "Scene.BattlePveModule.SkillModule.Skill.Skill_Shield"
-- 伤病恢复
local Skill_RecoveryDamage = require "Scene.BattlePveModule.SkillModule.Skill.Skill_RecoveryDamage"
-- 添加BUFF
local Skill_AddEffect = require "Scene.BattlePveModule.SkillModule.Skill.Skill_AddEffect"
-- 使用技能
local Skill_UseSkill = require "Scene.BattlePveModule.SkillModule.Skill.Skill_UseSkill"
-- 怒气
local Skill_AddAnger = require "Scene.BattlePveModule.SkillModule.Skill.Skill_AddAnger"


function PveSkillMgr:__init()

end

function PveSkillMgr:DoAttack(actionItem, callback,maxTime)
    local _defIdx = actionItem:GetTargetIndex()
    local _targetModelList = _defIdx == Const.CampType.Player and PveActorMgr:GetInstance():GetModelListByCamp(Const.CampType.Player) or PveActorMgr:GetInstance():GetModelListByCamp(Const.CampType.Target)
    if _targetModelList==nil then
        if (callback ~= nil) then
            callback()
        end
        return
    else
        local isNotDead = false
        for _, modelObj in pairs(_targetModelList) do
            if (not modelObj:IsDead()) then
                isNotDead = true
            end
        end
        if isNotDead == false then
            if (callback ~= nil) then
                callback()
            end
            return
        end
    end
    
    local actionType = actionItem:GetActionItemType()
    local _skill = nil
    if actionType == eMailDetailActionType.USE_SKILL then -- 使用技能
        _skill = Skill_UseSkill.New()
    else
        self:DoBuff(actionItem, callback,maxTime)
        return
    end
    _skill:DoAttack(actionItem, callback,maxTime)
end

--[[
    这块没有弄好,暂时先定在这个地方,关于BUFF的回头可以拆一个文件出来
]]
function PveSkillMgr:DoBuff(actionItem, callback,maxTime)
    -- 这块做一个处理,如果是最后一轮,这个时候如果自身当前血量已经为0,则不响应BUFF直接返回
    --if (PveActorMgr:GetInstance():IsFinalRound()) then
    --    if (callback ~= nil) then
    --        callback()
    --    end
    --    return

    --end
    local actionType = actionItem:GetActionItemType()
    local _skill = nil
    if actionType == eMailDetailActionType.SHIELD_ATTACK then
        -- 护盾反击
        _skill = Skill_ShieldAttack.New()
    elseif actionType == eMailDetailActionType.SHIELD then
        -- 护盾
        _skill = Skill_Shield.New()
    elseif actionType == eMailDetailActionType.RECOVER_DAMAGE then
        -- 恢复伤兵
        _skill = Skill_RecoveryDamage.New()
    elseif actionType == eMailDetailActionType.ADD_EFFECT then
        -- 添加BUFF
        _skill = Skill_AddEffect.New()
    elseif actionType == eMailDetailActionType.ADD_ANGER then
        -- 增加怒气
        _skill = Skill_AddAnger.New()
    elseif (actionType == eMailDetailActionType.ATTACK) then
        -- 这个之后还需要通过skillId来做不同的表现
        _skill = Skill_NormalAttack.New()
    else
        if callback~=nil then
            callback()
        end
        return
    end
    _skill:DoAttack(actionItem, callback,maxTime)
end




return PveSkillMgr