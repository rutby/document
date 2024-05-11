---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/2/22 16:09
---
local base = require "DataCenter.Survival.Character.CharacterBaseInfo"
local ZombieInfo = BaseClass("ZombieInfo",base)

function ZombieInfo:__init(zombieId,levelBuff)
    base.__init(self)
    self.m_zombieId = zombieId
    
    local template = DataCenter.PveZombieTemplateManager:GetTemplate(self.m_zombieId)
    if template == nil then
        Logger.LogError("Zombie not found template, id : "..self.m_zombieId)
    end
    self:SetTemplate(template)

    local hpLevelBuff = 1
    local atkLevelBuff = 1
    local defLevelBuff = 1
    if levelBuff ~= nil then
        hpLevelBuff = tonumber(levelBuff.hp_buff) or 1
        atkLevelBuff = tonumber(levelBuff.atk_buff) or 1
        defLevelBuff = tonumber(levelBuff.def_buff) or 1
    end
    self.m_atkLevelBuff = atkLevelBuff
    self.m_defLevelBuff = defLevelBuff
    
    self:SetMaxBlood(self.m_template.maxBlood * hpLevelBuff)
    self:SetCurBlood(self.m_template.maxBlood * hpLevelBuff)
    self.m_goBackSpeedPercent = (LuaEntry.DataConfig:TryGetNum("Zombie_Parameter", "k1") or 100) / 100
    self.m_chaseRadiusPercent = (LuaEntry.DataConfig:TryGetNum("Zombie_Parameter", "k2") or 100) / 100
end

function ZombieInfo:GetConfigType()
    return self.m_template.type
end

function ZombieInfo:GetAttack()
    return base.GetAttack(self) * self.m_atkLevelBuff
end

function ZombieInfo:GetDefence()
    return base.GetDefence(self) * self.m_defLevelBuff
end

function ZombieInfo:GetChaseRadius()
    return self.m_template.chaseRadius
end

function ZombieInfo:GetWalkSpeed()
    return self.m_template.walkSpeed
end

function ZombieInfo:GetSkillOrder()
    return self.m_template.skillOrder
end

function ZombieInfo:GetHpStage()
    return self.m_template.hpStage
end

function ZombieInfo:GetPatrolRadius()
    return self.m_template.patrolRadius
end

function ZombieInfo:GetPatrolIntervalTime()
    return self.m_template.patrolIntervalTime
end

function ZombieInfo:GetModelName()
    return self.m_template.modelName
end

function ZombieInfo:GetAnimation()
    return self.m_template.animation
end

function ZombieInfo:GetAiType()
    return self.m_template.aiType
end

function ZombieInfo:GetBackChaseRadius()
    return self.m_template.backChaseRadius
end

function ZombieInfo:GetAngle()
    return self.m_template.angle
end
--攻击失败距离
function ZombieInfo:GetAttackDropDistance()
    return self.m_template.AttackDropDistance
end
--距离出生点逃脱距离
function ZombieInfo:GetMoveRange()
    return self.m_template.MoveRange
end
--距离玩家的逃脱距离
function ZombieInfo:GetDisengageDistance()
    return self.m_template.DisengageDistance
end

function ZombieInfo:GetDeadVFX()
    return self.m_template.deathEffect
end

function ZombieInfo:GetGoBackSpeed()
    return self:GetMoveSpeed() * self.m_goBackSpeedPercent
end

function ZombieInfo:GetNewChaseRadius()
    return self:GetChaseRadius() * self.m_chaseRadiusPercent
end

function ZombieInfo:GetPartId()
    return self.m_template.part
end

return ZombieInfo