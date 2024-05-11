---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/9/26 14:56
---
local RecordRewardItem = BaseClass("RecordRewardItem")
local function __init(self)
    self.score = 0
    self.rewards = {}
end

local function __delete(self)
    self.score = 0
    self.rewards = {}
end

local function UpdateData(self,message)
    if message["score"]~=nil then
        self.score = message["score"]
    end
    if message["reward"]~=nil then
        self.rewards =DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
    end
end
RecordRewardItem.__init = __init
RecordRewardItem.__delete = __delete
RecordRewardItem.UpdateData = UpdateData
return RecordRewardItem