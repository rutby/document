---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
---
---
local RechargeStageInfo = BaseClass("RechargeStageInfo")

local function __init(self)
    self.needScore = nil    --所需积分
    self.reward = {}        --通用奖励
    self.stageId = nil      
    self.state = nil        --0未领取 1已经领取
end

local function __delete(self)
    self.needScore = nil
    self.reward = nil
    self.stageId = nil
    self.state = nil
end

local function ParseData(self,message)
    if not message then
        return
    end
    if message.needScore then
        self.needScore = message.needScore
    end
    if message.stageId then
        self.stageId = message.stageId
    end
    if message.state then
        self.state = message.state
    end

    if message["reward"] then
        self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
        local index = nil
        local info = nil
        for i = 1, table.count(self.reward) do
            if self.reward[i].rewardType == RewardType.HERO then
                index = i
                info = self.reward[i]
            end
        end
        if index ~= nil then
            table.remove(self.reward,index)
            table.insert(self.reward,1,info)
        end
    end
end

local function UpdateState(self,state)
    self.state = state
end


RechargeStageInfo.__init = __init
RechargeStageInfo.__delete = __delete
RechargeStageInfo.ParseData = ParseData
RechargeStageInfo.UpdateState = UpdateState

return RechargeStageInfo