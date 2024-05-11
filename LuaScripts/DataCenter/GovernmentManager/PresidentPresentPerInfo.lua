---
--- Created by shimin
--- DateTime: 2023/3/17 17:19
--- 王座每个礼包信息
---
local PresidentPresentPerInfo = BaseClass("PresidentPresentPerInfo")

function PresidentPresentPerInfo:__init()
    self.presentId = 0 --礼包id
    self.useCount = 0 --已经使用了多少
    self.reward = {}--奖励信息
end

function PresidentPresentPerInfo:__delete()
    self.presentId = 0 --礼包id
    self.useCount = 0 --已经使用了多少
    self.reward = {}--奖励信息
end

function PresidentPresentPerInfo:ParseData(message)
    if message == nil then
        return
    end
    self.presentId = message["presentId"]
    self.useCount = message["useCount"]
    if message["reward"] ~= nil then
        self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
    end
end

return PresidentPresentPerInfo