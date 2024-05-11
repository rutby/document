---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/7 10:52
---

local DecorationGiftPackageData = BaseClass("DecorationGiftPackageData")

local function __init(self)
    self.activityId = 0
    self.exchangeIds = {}
    self.reward = {}
    self.rewardState = 0--int  0不可领   1可领  2已领取
end

local function __delete(self)
    self.activityId = 0
    self.exchangeIds = {}
    self.reward = {}
    self.rewardState = 0
end

local function ParseData(self, param)
    if param["activityId"] then
        self.activityId = param["activityId"]
    end
    if param["exchangeIds"] then
        self.exchangeIds = string.split(param["exchangeIds"], ";")
    end
    if param["reward"] then
        self.reward = DataCenter.RewardManager:ReturnRewardParamForView(param["reward"])
    end
    if param["rewardState"] then
        self.rewardState = param["rewardState"]
    end
end

DecorationGiftPackageData.__init = __init
DecorationGiftPackageData.__delete = __delete
DecorationGiftPackageData.ParseData = ParseData

return DecorationGiftPackageData