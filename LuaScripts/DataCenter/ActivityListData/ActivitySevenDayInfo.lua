---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local ActivitySevenDayInfo = BaseClass("ActivitySevenDayInfo")


local function __init(self)

    self.score =0 --当前积分
    self.days= 0
    self.endTime = 0
    self.scoreMax=0  --最大积分
    self.scoreReward = {}
    self.dayActs = {}
    self.taskRedNum = 0
    self.taskRed = {} --任务红点
end

local function __delete(self)
    self.score = nil
    self.days=nil
    self.endTime = nil
    self.scoreMax = nil
    self.scoreReward = nil
    self.dayActs = nil
    self.taskRedNum = nil
    self.taskRed = nil
end

local function ParseActivityData(self, dayActsMessage)
    if dayActsMessage ==nil then
        return
    end

    if dayActsMessage["score"] ~=nil then
        self.score = dayActsMessage["score"]
    end
    if dayActsMessage["days"] ~=nil then
        self.days = dayActsMessage["days"]
    end
    if dayActsMessage["endTime"] ~=nil then
        self.endTime = dayActsMessage["endTime"]
    end

    if dayActsMessage["scoreMax"] ~=nil then
        self.scoreMax = dayActsMessage["scoreMax"]
    end

    for i=1,#dayActsMessage.dayActs do
        self.dayActs[i] = dayActsMessage.dayActs[i]
        for j=1,#dayActsMessage.dayActs[i] do
            self.dayActs[i][j] = dayActsMessage.dayActs[i][j]
            local id = self.dayActs[i][j].id
            local dayAct_table = LocalController:instance():getLine(TableName.DayAct, id)
            if dayAct_table == nil then
                return
            end
            self.dayActs[i][j].type1_text = dayAct_table.type1_text
            self.dayActs[i][j].type2_text = dayAct_table.type2_text
        end
    end

    --specialReward特殊奖励 needVip需要vip  specialRewardFlag特殊奖励是否领取
    if dayActsMessage["scoreReward"] ~= nil then
        self.scoreReward = dayActsMessage["scoreReward"]
    end

    self:CheckRedDot()
    EventManager:GetInstance():Broadcast(EventId.SevenDayGetReward)
end

--检查红点
--1 积分达到且宝箱未领取 有红点
--2 任务完成可领取 有红点
-- .rewardFlag =0宝箱未领取, 1宝箱已领取
local function CheckRedDot(self)
    self.taskRedNum = 0
    local vipInfo = DataCenter.VIPManager:GetVipData()
    local switch = LuaEntry.DataConfig:CheckSwitch("dayact_vip")
    --1 积分红点检查
    if self.scoreReward ~= nil then
        for i = 1, #self.scoreReward do
            local reward = self.scoreReward[i]
            if reward ~= nil and reward.rewardFlag == 0 then
                --检查普通奖励
                if reward.rewardFlag == 0 then
                    if self.score >= reward.needScore then
                        self.taskRedNum = self.taskRedNum + 1
                    end
                end
            end
            --检查vip奖励
            if vipInfo and switch and reward.specialRewardFlag == 0 then
                if self.score >= reward.needScore and vipInfo.level >= reward.needVip then
                    self.taskRedNum = self.taskRedNum + 1
                end
            end
        end
    end

    --任务完成状态检查
    if self.dayActs ~= nil then
        for i = 1, #self.dayActs do
            self.taskRed[i] = {}
            local dayInfos = self.dayActs[i]
            if i <= self.days then
                for j = 1, #dayInfos do
                    local tasks = dayInfos[j].tasks
                    self.taskRed[i][j] = 0
                    for k = 1, #tasks do
                        local taskId = tasks[k].taskId
                        local taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
                        if taskValue ~= nil then
                            local state = taskValue.state
                            if state == 2 then
                                --已领取
                            elseif state == 1 then
                                --可领取
                                self.taskRedNum = self.taskRedNum + 1
                                self.taskRed[i][j] = 1
                            end
                        end
                    end
                end
            end
        end
    end
end

--检查是否是七日任务
local function CheckIsSevenDayTask(self,taskId)
    if self.dayActs ~= nil then
        for i = 1, #self.dayActs do
            local dayInfos = self.dayActs[i]
            if i <= self.days then
                for j = 1, #dayInfos do
                    local tasks = dayInfos[j].tasks
                    for k = 1, #tasks do
                        if taskId == tasks[k].taskId then
                            return true
                        end
                    end
                end
            end
        end
    end
end

--设置积分宝箱领取状态
--index 宝箱序号 从1开始
--state 宝箱领取状态，0未领取，1已领取
local function SetScoreBoxState(self,message)
    if self.scoreReward ~= nil then
        if message.type == 0 then
            self.scoreReward[message.index].rewardFlag = 1
        elseif message.type == 1 then
            self.scoreReward[message.index].specialRewardFlag = 1
        end
    end
end

--获取达到某一阶段的宝箱积分
local function GetScoreByIndex(self,index)
    local score = 0
    if self.scoreReward ~= nil then
        local data = self.scoreReward[index]
        if data ~= nil and data["needScore"] ~= nil then
            score = data["needScore"]
        end
    end
    return score
end

--按需求对显示任务排序
local function SortTask(self,tasks)
    local list = {}
    if tasks ~= nil then
        local canReceiveList = {}
        local unFinishList = {}
        local hasFinishList = {}
        for i = 1, #tasks do
            local taskId = tasks[i].taskId
            local taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
            if taskValue ~= nil then
                local state = taskValue.state
                if state == 2 then
                    --已领取
                    table.insert(hasFinishList , tasks[i])

                elseif state == 1 then
                    --可领取
                    table.insert(canReceiveList , tasks[i])
                else
                    --前往
                    table.insert(unFinishList , tasks[i])
                end
            end
        end
        list = canReceiveList
        for i = 1, #unFinishList do
            table.insert(list , unFinishList[i])
        end
        for i = 1, #hasFinishList do
            table.insert(list , hasFinishList[i])
        end
    end
    return list
end

--统计当天的所有奖励，同一类型奖励数量累加
local function GetRewardItemListByDay(self,day)
    if self.dayActs == nil then
        return nil
    end
    local rewardList = {}
    local dayAct = self.dayActs[day]
    if dayAct ~= nil then
        local count = #dayAct
        for i = 1, count do
            local tasks = dayAct[i].tasks
            for j = 1, #tasks do
                local taskValue = DataCenter.TaskManager:FindTaskInfo(tasks[j].taskId)
                for k = 1 , #taskValue.rewardList do
                    if rewardList[tonumber(taskValue.rewardList[k].itemId)] == nil then
                        local reward = {}
                        reward.type = taskValue.rewardList[k].rewardType
                        reward.count = taskValue.rewardList[k].count
                        reward.itemId = tonumber(taskValue.rewardList[k].itemId)
                        rewardList[reward.itemId] = reward
                    else
                        rewardList[tonumber(taskValue.rewardList[k].itemId)].count = taskValue.rewardList[k].count+rewardList[tonumber(taskValue.rewardList[k].itemId)].count
                    end

                end
            end
        end
    end
    return rewardList
end

local function UpdateDayActScore(self,message)
    self.score = message["score"]
    self:CheckRedDot()
    EventManager:GetInstance():Broadcast(EventId.SevenDayGetReward)
end

local function GetBoxRewardRed(self)
    local redNum = 0
    local vipInfo = DataCenter.VIPManager:GetVipData()
    local switch = LuaEntry.DataConfig:CheckSwitch("dayact_vip")
    if self.scoreReward ~= nil then
        for i = 1, #self.scoreReward do
            local reward = self.scoreReward[i]
            if reward ~= nil and reward.rewardFlag == 0 then
                --检查普通奖励
                if reward.rewardFlag == 0 then
                    if self.score >= reward.needScore then
                        redNum = redNum + 1
                    end
                end
            end
            --检查vip奖励
            if switch and reward.specialRewardFlag == 0 then
                if vipInfo and self.score >= reward.needScore and vipInfo.level >= reward.needVip then
                    redNum = redNum + 1
                end
            end
        end
    end
    return redNum
end

ActivitySevenDayInfo.__init = __init
ActivitySevenDayInfo.__delete = __delete
ActivitySevenDayInfo.ParseActivityData = ParseActivityData
ActivitySevenDayInfo.CheckRedDot = CheckRedDot
ActivitySevenDayInfo.GetScoreByIndex = GetScoreByIndex
ActivitySevenDayInfo.SortTask = SortTask
ActivitySevenDayInfo.SetScoreBoxState = SetScoreBoxState
ActivitySevenDayInfo.GetRewardItemListByDay = GetRewardItemListByDay
ActivitySevenDayInfo.UpdateDayActScore = UpdateDayActScore
ActivitySevenDayInfo.CheckIsSevenDayTask = CheckIsSevenDayTask
ActivitySevenDayInfo.GetBoxRewardRed = GetBoxRewardRed

return ActivitySevenDayInfo