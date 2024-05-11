---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2024/3/29 16:25
---

---
--- 丧尸围城活动，一次攻城的数据
---
local CitySiegeAttackData = BaseClass("CitySiegeAttackData")

local function __init(self)
    self.uuid = 0
    self.attackId = 0
    self.serverState = CitySiegeServerState.None
    self.endTime = 0
    self.aliveZombieIds = {}
    self.finishZombieIds = {}
    self.justFinishZombieId = 0
    self.reward = {}
    
    -- 前端
    self.questIds = {}
end

local function __delete(self)
    
end

local function ParseServerData(self, serverData, isInit)
    if serverData.uuid then
        self.uuid = serverData.uuid
    end
    if serverData.attackId then
        self.attackId = serverData.attackId
        
        local questStr = GetTableData(TableName.CitySiegeAttack, self.attackId, "show_quest")
        if not string.IsNullOrEmpty(questStr) then
            for i, str in ipairs(string.split(questStr, ";")) do
                self.questIds[i] = tonumber(str)
            end
        end
    end
    if serverData.status then
        self.serverState = serverData.status
        EventManager:GetInstance():Broadcast(EventId.CitySiegeStateChange)
    end
    if serverData.endTime then
        self.endTime = serverData.endTime
    end
    if serverData.finishZombie then
        if isInit then
            self.finishZombieIds = {}
            self.aliveZombieIds = {}
            self.justFinishZombieId = 0
            for _, str in ipairs(string.split(serverData.finishZombie, ";")) do
                local zombieId = tonumber(str)
                if zombieId then
                    table.insert(self.finishZombieIds, zombieId)
                end
            end
            local zombieIdStr = GetTableData(TableName.CitySiegeAttack, self.attackId, "city_zombie")
            for _, str in ipairs(string.split(zombieIdStr, "|")) do
                local zombieId = tonumber(str)
                if not table.hasvalue(self.finishZombieIds, zombieId) then
                    table.insert(self.aliveZombieIds, zombieId)
                end
            end
        else
            for _, str in ipairs(string.split(serverData.finishZombie, ";")) do
                local zombieId = tonumber(str)
                if zombieId then
                    if not table.hasvalue(self.finishZombieIds, zombieId) then
                        table.insert(self.finishZombieIds, zombieId)
                        table.removebyvalue(self.aliveZombieIds, zombieId)
                        self.justFinishZombieId = zombieId
                    end
                end
            end
        end
    end
    if serverData.reward then
        self.reward = serverData.reward
    end
end

local function GetState(self)
    if self.serverState == CitySiegeServerState.Pending then
        return CitySiegeAttackState.Pending
    elseif self.serverState == CitySiegeServerState.Active then
        local questFinished = true
        for _, questId in ipairs(self.questIds) do
            if not DataCenter.TaskManager:IsFinishTask(tostring(questId)) and not DataCenter.ChapterTaskManager:CheckIsSuccess(tostring(questId)) then
                questFinished = false
                break
            end
        end
        if questFinished then
            return CitySiegeAttackState.Ready
        else
            return CitySiegeAttackState.PreTask
        end
    elseif self.serverState == CitySiegeServerState.ZombieActive then
        return CitySiegeAttackState.Playing
    elseif self.serverState == CitySiegeServerState.Pass then
        return CitySiegeAttackState.Victory
    elseif self.serverState == CitySiegeServerState.Expire then
        return CitySiegeAttackState.Expired
    elseif self.serverState == CitySiegeServerState.Finish then
        return CitySiegeAttackState.Finish
    end
    return CitySiegeAttackState.None
end

CitySiegeAttackData.__init = __init
CitySiegeAttackData.__delete = __delete

CitySiegeAttackData.ParseServerData = ParseServerData
CitySiegeAttackData.GetState = GetState

return CitySiegeAttackData