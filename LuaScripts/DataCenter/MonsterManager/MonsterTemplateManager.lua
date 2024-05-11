---
--- Created by shimin.
--- DateTime: 2021/7/12 11:46
---
local MonsterTemplateManager = BaseClass("MonsterTemplateManager");

local function __init(self)
    self.monsterMaxLevel = -1
end

local function __delete(self)
    self.monsterMaxLevel = -1
end

local function GetMonsterTemplate(self,id)
    local intId = tonumber(id)
    return LocalController:instance():getLine(TableName.Monster,intId)
end

local function GetTableValue(self,id,name)
    return GetTableData(TableName.Monster,id, name)
end

local function GetMonsterMaxLevel(self)
    if self.monsterMaxLevel<=0 then
        LocalController:instance():visitTable(TableName.Monster,function(id,lineData)
            local level = lineData:getValue("level")
            if level > self.monsterMaxLevel then
                self.monsterMaxLevel = level
            end
        end)
    end
    return self.monsterMaxLevel
end

function MonsterTemplateManager:GetRecommendPower(monsterId)
    local power = 0
    if LuaEntry.DataConfig:CheckSwitch("new_army_power") then
        power = self:GetTableValue(monsterId,"recommend_power_b")
    else
        power = self:GetTableValue(monsterId,"recommend_power")
    end
    power = toInt(power)
    return power
end

function MonsterTemplateManager:GetNeedHeroLevel(monsterId)
    --if #self.recommend_hero>=1 then
    --    return self.recommend_hero[1]
    --end
    return 0
end
function MonsterTemplateManager:GetNeedHeroCount(monsterId)
    --if #self.recommend_hero>=2 then
    --    return self.recommend_hero[2]
    --end
    return 0
end

function MonsterTemplateManager:GetNeedArmyLevel(monsterId)
    local recommend_troops = GetTableValue(monsterId,"recommend_troops")
    if #recommend_troops>=1 then
        return recommend_troops[1]
    end
    return 0
end
function MonsterTemplateManager:GetNeedArmyCount(monsterId)
    local recommend_troops = GetTableValue(monsterId,"recommend_troops")
    if #recommend_troops>=2 then
        return recommend_troops[2]
    end
    return 0
end
function MonsterTemplateManager:GetShowReward(monsterId)
    local line = self:GetMonsterTemplate(monsterId)
    local boss = line:getValue("boss")
    local show_reward = line:getValue("show_reward")
    local effect_show_reward = line:getValue("effect_show_reward")
    if boss == 0 and LuaEntry.Effect:GetGameEffect(EffectDefine.MONSTER_EXTRA_REWARD) == 1 or
            boss == 1 and LuaEntry.Effect:GetGameEffect(EffectDefine.BOSS_EXTRA_REWARD) == 1 then
        local dict = {}
        for _, reward in ipairs({ show_reward, effect_show_reward }) do
            for _, str in ipairs(reward) do -- str: "id;rewardType;num"
                local spls = string.split(str, ";")
                if #spls == 3 then
                    local k = spls[1] .. ";" .. spls[2]
                    local v = tonumber(spls[3])
                    dict[k] = (dict[k] or 0) + v
                end
            end
        end
        local t = {}
        for k, v in pairs(dict) do
            table.insert(t, k .. ";" .. v)
        end
        table.sort(t)
        return t
    else
        local showReward = show_reward
        return showReward
    end
end

function MonsterTemplateManager:GetFirstShowReward(monsterId)
    return self:GetTableValue(monsterId,"first_show_reward")
end
MonsterTemplateManager.__init = __init
MonsterTemplateManager.__delete = __delete
MonsterTemplateManager.GetMonsterTemplate = GetMonsterTemplate
MonsterTemplateManager.GetTableValue = GetTableValue
MonsterTemplateManager.GetMonsterMaxLevel = GetMonsterMaxLevel

return MonsterTemplateManager
