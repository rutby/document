--- Created by yixing
--- DateTime: 2020/03/08 14:42
---联盟军备数据
---
--------------------------------------------------------
--local ActivityScoreInfo = require "DataCenter.ActivityListData.ActivityScoreInfo"
local ActivityEventInfo = require "DataCenter.ActivityListData.ActivityEventInfo"
local base = ActivityScoreInfo

local ActAllianceBattleInfo = BaseClass("ActAllianceBattleInfo", ActivityScoreInfo)

local function __init(self)
    base.__init(self)
    self.vsAllianceInfo = nil
    self.winReward = nil
    self.eventInfo = nil
    self.matchGroupId = ""
    self.crossServerInfo = nil
end


local function parseServerData(self, activity)
    if activity ==nil then
        return
    end
    base.parseServerData(self, activity)
    --todo:处理lua端不能解析二维数组数据，添加此字段，使用时转到c#转化
    self.serverActivity = activity
    if activity["activityId"] ~= nil then
        self.activityId = activity["activityId"]
        -- printInfo(self.id.."打印联盟军备获取积分条件-2 activityid ="..activity["activityId"])
    end
    if activity["ranking"] ~= nil then
        self.ranking = tonumber(activity["ranking"])
    end
    if activity["type"] then
        --积分活动类型的活动类型
        self.scoreType = activity["type"]
    end
    --printInfo("打印联盟军备获取积分条件 activityid="..self.activityId)
    if activity["eventList"] ~= nil then
        self.eventList = activity["eventList"]
        self.eventInfoList = {} 
        table.walk(self.eventList, function(k,v)                    
            local info = ActivityEventInfo.New()
            info:ParseData(v)
            -- printInfo("打印联盟军备获取积分条件1,"..info.actId)
            self.eventInfoList[info.actId] = info
            --todo eventList数组结构就一个，取第一个
            self.eventInfo = info
        end)
    end

    if activity["matchGroupId"]~=nil then
        self.matchGroupId = activity["matchGroupId"]
    end
    
    
end

local function GetEventInfo(self)
    -- printInfo("打印出来====eventInfo="..self.id)    
    return self.eventInfo
end

local function GetCanReward(self)
    local eventInfo = self:GetEventInfo()
    if eventInfo ~= nil then
        local canReceiveFlag = nil
        if eventInfo.rewardFlagList ~= nil then
            local count = #eventInfo.rewardFlagList
            for i = 1, count do
                canReceiveFlag = eventInfo.rewardFlagList[i] 
                local state1 = false
                if canReceiveFlag ~= nil and tonumber(canReceiveFlag) == i then
                    state1 = true
                end
                local state2 = false
                local getFlag = nil
                if eventInfo.newRewardFlagList ~= nil then
                    getFlag = eventInfo.newRewardFlagList[i]
                    if getFlag ~= nil and tonumber(getFlag) == i then
                        state2 = true
                    end
                end
                if state1 == true and state2 == false then
                    return true
                end
            end
        end
    end
    return false
end

local function GetRewardCount(self)
    local eventInfo = self:GetEventInfo()
    if eventInfo ~= nil then
        return eventInfo:GetCanReceiveCount()
    end
    return 0
end

local function GetBoxReceiveState(self, index)
    local getFlag = nil
    local isGet = 1
    local canReceiveFlag = nil
    if self.eventInfo.rewardFlagList ~= nil then
        canReceiveFlag = self.eventInfo.rewardFlagList[index]
    end
    if canReceiveFlag ~= nil and tonumber(canReceiveFlag) == index then
        isGet = 2
    end
    if self.eventInfo.newRewardFlagList ~= nil then
        getFlag = self.eventInfo.newRewardFlagList[index]
    end
    if getFlag ~= nil and tonumber(getFlag) == index then
        isGet = 3
    end
    return isGet
end

local function __delete(self)
    self.vsInfos = nil
    self.vsAllianceList = nil
    self.winReward = nil
    base.__delete()
end

--1未解锁，2可领取，3已领取
local function UpdateBoxStatus(self, boxIndex, status)
    if self.eventInfo then
        if not self.eventInfo.rewardFlagList then
            self.eventInfo.rewardFlagList = {}
        end
        if not self.eventInfo.newRewardFlagList then
            self.eventInfo.newRewardFlagList = {}
        end
        if status == 1 then
            self.eventInfo.rewardFlagList[boxIndex] = -1
            self.eventInfo.newRewardFlagList[boxIndex] = -1
        elseif status == 2 then
            self.eventInfo.rewardFlagList[boxIndex] = boxIndex
            self.eventInfo.newRewardFlagList[boxIndex] = -1
        elseif status == 3 then
            self.eventInfo.rewardFlagList[boxIndex] = -1
            self.eventInfo.newRewardFlagList[boxIndex] = boxIndex
        end
    end
end

ActAllianceBattleInfo.__init = __init
ActAllianceBattleInfo.__delete = __delete
ActAllianceBattleInfo.parseServerData = parseServerData
ActAllianceBattleInfo.GetEventInfo = GetEventInfo
ActAllianceBattleInfo.GetCanReward = GetCanReward
ActAllianceBattleInfo.GetBoxReceiveState = GetBoxReceiveState
ActAllianceBattleInfo.GetRewardCount = GetRewardCount
ActAllianceBattleInfo.UpdateBoxStatus = UpdateBoxStatus
return ActAllianceBattleInfo