---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/2/22 22:11
---Npc数据类，兼容战斗属性和非战斗属性
local base = require "DataCenter.Survival.Character.CharacterBaseInfo"
local NpcInfo = BaseClass("NpcInfo",base)

function NpcInfo:__init(npcId)
    base.__init(self)
    self.m_npcId = npcId
    
    self:__initTemplate()
end

function NpcInfo:__initTemplate()
    self.cityTemplate = DataCenter.PveNpcTemplateManager:GetTemplate(self.m_npcId)
    
    if (self.cityTemplate == nil) then
        Logger.LogError("npcId not exit: " .. tostring(self.m_npcId))
    end
    if self.cityTemplate.aps_pve_zombie_id ~= nil then
        self.fightTemplate = DataCenter.PveZombieTemplateManager:GetTemplate(self.cityTemplate.aps_pve_zombie_id)
        self:SetMaxBlood(self.fightTemplate.maxBlood)
        self:SetCurBlood(self.fightTemplate.maxBlood)
    else
        self:SetMaxBlood(100)
        self:SetCurBlood(100)
    end
    
    local constData =  DataCenter.PveNpcTemplateManager:GetConstData()
    self.npc_chat_radius = constData.npc_chat_radius --NPC交谈触发半径
    self.player_chat_radius = constData.player_chat_radius --玩家和NPC触发交谈半径
    self.rest_trigger = constData.rest_trigger --休息触发距离
    self.rest_time = constData.rest_time --休息时间
    self.move_build_speed = constData.move_build_speed --跑步建造建筑的速度
    self.chat_interval_time = constData.chat_interval_time --聊天间隔时间
    self.rest_interval_time = constData.rest_interval_time --聊天间隔时间
    self.run_speed = constData.run_speed
    self.rest_coordinates = {}
    local pos
    for _,p in ipairs(constData.rest_coordinates) do
        pos = SceneUtils.TileToWorld(p)
        table.insert(self.rest_coordinates,pos)
    end
end

function NpcInfo:__delete()
    base.__delete(self)
    self.fightTemplate = nil
    self.cityTemplate = nil
end

--------------战斗相关属性--------------------
function NpcInfo:GetChaseRadius()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.chaseRadius
    end
    return 0
end

function NpcInfo:GetAttack()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.attack
    end
    return 0
end

function NpcInfo:GetAttackSpeed()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.attackSpeed
    end
    return 0
end

function NpcInfo:GetAttackRange()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.attackRange
    end
    return 0
end

function NpcInfo:GetDefence()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.defence
    end
    return 0
end

function NpcInfo:GetMoveSpeed()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.moveSpeed
    end
    return 1
end

function NpcInfo:GetPartId()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.part
    end
    return 0
end

function NpcInfo:GetAnimation()
    if self.fightTemplate ~= nil then
        return self.fightTemplate.animation
    end
    return 0
end
------------------------------------------

--------------City相关属性------------------
function NpcInfo:GetType()
    return self.cityTemplate.type
end

function NpcInfo:GetModelName()
    return self.cityTemplate.low_model
end

function NpcInfo:GetMistressId()
    return self.cityTemplate.mistress_id
end

function NpcInfo:GetActionGroup()
    return self.cityTemplate.action_group
end

function NpcInfo:GetWalkPath()
    return self.cityTemplate.walk_path
end

function NpcInfo:GetChatProbability()
    return self.cityTemplate.chat_probability
end

function NpcInfo:GetNpcChatGroupId()
    return self.cityTemplate.npc_chat_group_id
end

function NpcInfo:GetRestProbability()
    return self.cityTemplate.rest_probability
end

function NpcInfo:GetPlayerChatProbability()
    return self.cityTemplate.player_chat_probability
end

function NpcInfo:GetPlayerChatGroupId()
    return self.cityTemplate.player_chat_group_id
end

function NpcInfo:GetWalkSpeed()
    return self.cityTemplate.speed
end

function NpcInfo:GetNpcChatGroup()
    return self.cityTemplate.npc_chat_group
end

function NpcInfo:GetRunSpeed()
    return self.run_speed
end

function NpcInfo:GetNpcChatRadius()
    return self.npc_chat_radius
end

function NpcInfo:GetPlayerChatRadius()
    return self.player_chat_radius
end

function NpcInfo:GetRestTrigger()
    return self.rest_trigger
end

function NpcInfo:GetRestTime()
    return self.rest_time
end

function NpcInfo:GetMoveBuildSpeed()
    return self.move_build_speed
end

function NpcInfo:GetChatIntervalTime()
    return self.chat_interval_time
end

function NpcInfo:GetRestIntervalTime()
    return self.rest_interval_time
end

function NpcInfo:GetRestCoordinates()
    return self.rest_coordinates
end

---------------------------------------------

return NpcInfo