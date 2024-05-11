---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/1/4 15:36
---


local KeepPayData = BaseClass("KeepPayData")

local function __init(self, id)
    self.id = id
    self.startTime = 0
    self.endTime = 0
    self.rechargeType = RechargeType.Normal
    self.stages = {}
    self.score = 0
    self.lastRewardTime = 0
    self.scoreTime = 0
    -- recharge config
    self.name = nil
    self:InitLineData()
end

local function __delete(self)
    self.id = nil
    self.startTime = nil
    self.endTime = nil
    self.rechargeType = nil
    self.stages = nil
    self.score = nil
    self.lastRewardTime = nil
    self.scoreTime = nil
    self.name = nil
end

local function InitLineData(self)
    LocalController:instance():visitTable("recharge", function(_, lineData)
        if self.id == tonumber(lineData:getValue("para2")) then
            self.name = lineData:getValue("name")
        end
    end)
end

local function GetTodayScore(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.scoreTime // 1000)
    return sameDay and self.score or 0
end

local function GetMaxLevel(self)
    return #self.stages
end

local function GetTodayLevel(self)
    local level = self:GetLastReceivedLevel()
    if self:IsTodayReceived() then
        return math.max(level, 1)
    else
        return math.min(level + 1, self:GetMaxLevel())
    end
end

local function GetLastReceivedLevel(self)
    local level = 0
    for _, stage in ipairs(self.stages) do
        if stage.state == 1 then
            level = stage.level
        else
            break
        end
    end
    return level
end

local function GetRedNum(self)
    local redNum = 0
    if self:IsNew() then
        redNum = 1
    end
    local level = self:GetTodayLevel()
    local stage = self.stages[level]
    if stage and stage.state == 0 and self:GetTodayScore() >= stage.needScore then
        redNum = 1
    end

    return redNum
end

local function IsTodayReceived(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local sameDay = UITimeManager:GetInstance():IsSameDayForServer(curTime // 1000, self.lastRewardTime // 1000)
    return sameDay
end

local function IsNew(self)
    local visitTime = tonumber(Setting:GetPrivateString(SettingKeys.KEEP_PAY_VISIT_TIME .. self.id, "0")) or 0
    return visitTime < self.startTime
end

KeepPayData.__init = __init
KeepPayData.__delete = __delete

KeepPayData.InitLineData = InitLineData
KeepPayData.GetTodayScore = GetTodayScore
KeepPayData.GetMaxLevel = GetMaxLevel
KeepPayData.GetTodayLevel = GetTodayLevel
KeepPayData.GetLastReceivedLevel = GetLastReceivedLevel
KeepPayData.GetRedNum = GetRedNum
KeepPayData.IsTodayReceived = IsTodayReceived
KeepPayData.IsNew = IsNew

return KeepPayData