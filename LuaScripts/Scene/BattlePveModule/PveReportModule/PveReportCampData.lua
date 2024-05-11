---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/9/13 21:40
---阵营的回合战报
local PveReportCampData = BaseClass("PveReportCampData")
local PveReportRound = require("Scene.BattlePveModule.PveReportModule.PveReportRound")

function PveReportCampData:__init()
    self.m_startRound = 0       --起始回合
    self.m_endRound = 0         --结束回合
    self.m_currentRound = 0     --当前回合
    self.m_maxHealth = 0        --阵营的最大血量
    self.m_currentHealth = 0    --阵营的当前血量
    self.m_damage = 0           --伤害值
    self.m_rounds = {}          --每回合数据

    self.m_campDamage = 0
end

function PveReportCampData:InitData(startRound,endRound,maxHealth)
    self.m_startRound = startRound
    self.m_endRound = endRound
    self.m_maxHealth = maxHealth
    self.m_currentHealth = maxHealth
end

function PveReportCampData:PlayRound(roundIndex)
    self.m_currentRound = roundIndex

    --local round = self.m_rounds[roundIndex]

    --if round ~= nil then
    --    round:CalculateNormalDamage() --计算当前回合伤害
    --end
    self:CheckPlaySkill()
end

function PveReportCampData:CheckPlaySkill()
    local round = self.m_rounds[self.m_currentRound]
    if round ~= nil then
        local skills = round:GetSkill()
        for i, skill in ipairs(skills) do
            EventManager:GetInstance():Broadcast(EventId.SU_PveReportDoSkill,skill)
        end
    end
end

function PveReportCampData:AddRoundItem(item)
    local round = self:GetRound(item:GetRoundIndex())

    round:AddItem(item)
end

function PveReportCampData:GetRound(index)
    local round = self.m_rounds[index]
    if round == nil then
        round = PveReportRound.New()
        self.m_rounds[index] = round
    end
    return round
end

function PveReportCampData:GetNormalDamageByRound(roundIndex)
    local round = self.m_rounds[roundIndex]
    if round ~= nil then
        return round:GetTotalDamage()
    end
    return 0
end

function PveReportCampData:CalculateNormalDamage()
    for _, round in pairs(self.m_rounds) do
        round:CalculateNormalDamage()

        self.m_damage = self.m_damage + round:GetTotalDamage()
    end
end
--添加技能没有打出去的伤害
function PveReportCampData:AddSkillDamage(skillDamage)
    if skillDamage > 0 then
        self.m_damage = self.m_damage + skillDamage
    end
end

--分配普通伤害
function PveReportCampData:AssignNormalDamage(assignDamage)
    local damage,differenceDamage = 0
    local totalDamage = 0
    for roundIndex, round in pairs(self.m_rounds) do
        if roundIndex <= self.m_currentRound then
            damage,differenceDamage = round:AssignNormalDamage(assignDamage,differenceDamage)

            --self.m_campDamage = self.m_campDamage + damage
            --Logger.LogError(string.format("roundIndex = %s,assignDamage = %s, damage = %s,differenceDamage = %s, roundDamage = %s,campDamage = %s, roundTotalDamage = %s",
            --        roundIndex,assignDamage,damage,differenceDamage,round.m_damage,self.m_campDamage,round:GetTotalDamage()))
            totalDamage = totalDamage + damage
            if differenceDamage == 0 then
                break --不需要补伤害
            else
                assignDamage = assignDamage - damage --扣除已经计算出来的伤害
            end
        end
    end

    if totalDamage == 0 and assignDamage ~= 0 and self.m_damage > 0 and self.m_currentRound >= self.m_endRound then
        --已经最后一个回合了，普通伤害打完了，可能有些技能的触发者死了，所以把没触发的技能伤害当成普通伤害打出去
        --if assignDamage < self.m_damage then
        --    totalDamage = assignDamage
        --else
        --    totalDamage = self.m_damage
        --end
        --Logger.LogError("触发了伤害补漏机制，分配的伤害计算存在BUG，有存量伤害没有打出去")
        totalDamage = self.m_damage
    end

    self.m_damage = self.m_damage - totalDamage

    return totalDamage
end
--是否没有伤害了
function PveReportCampData:IsDamageEmpty()
    local isEmpty = true
    for _, round in pairs(self.m_rounds) do
        if round:GetDamage() > 0 then
            isEmpty = false
            break
        end
    end

    return isEmpty and self.m_damage <= 0
end

function PveReportCampData:GetActiveBuffs()
    local currentActiveBuffs = {}
    local buffs = {}
    local roundActiveBuffs
    local roundBuffs
    for _, round in pairs(self.m_rounds) do
        roundActiveBuffs,roundBuffs = round:GetActiveBuffs(self.m_currentRound)
        table.insertto(currentActiveBuffs,roundActiveBuffs)
        table.merge(buffs,roundBuffs)
    end
    return currentActiveBuffs,buffs
end

function PveReportCampData:GetMaxHealth()
    return self.m_maxHealth
end

function PveReportCampData:ClearData()
    self.m_startRound = 0       --起始回合
    self.m_currentRound = 0     --当前回合
    self.m_maxHealth = 0        --阵营的最大血量
    self.m_currentHealth = 0    --阵营的当前血量
    self.m_damage = 0           --伤害值
    self.m_rounds = {}          --每回合数据

    self.m_campDamage = 0
end

return PveReportCampData