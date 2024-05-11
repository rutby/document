--- Created by shimin.
--- DateTime: 2023/3/6 18:10
--- 黑骑士活动杀怪排名奖励数据

local ActBlackKnightKillRewardInfo = BaseClass("ActBlackKnightKillRewardInfo")

function ActBlackKnightKillRewardInfo:__init()
    self.rank = 0--档位 int  
    self.reward = {}-- 通用奖励显示
end

function ActBlackKnightKillRewardInfo:__delete()
    self.rank = 0--档位 int  
    self.reward = {}-- 通用奖励显示
end

function ActBlackKnightKillRewardInfo:ParseInfo(message)
    if message["rank"] ~= nil then
        self.rank = message["rank"]
    end
    if message["reward"] ~= nil then
        self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
        if self.reward[2] ~= nil then
            table.sort(self.reward, function(a,b)
                return a.rewardType < b.rewardType
            end)
        end
    end
end

return ActBlackKnightKillRewardInfo