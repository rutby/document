--- Created by shimin.
--- DateTime: 2023/3/6 18:10
--- 黑骑士活动阶段奖励数据

local ActBlackKnightLevelRewardInfo = BaseClass("ActBlackKnightLevelRewardInfo")

function ActBlackKnightLevelRewardInfo:__init()
    self.rank = 0--档位 int  
    self.memberKill = 0--需要的个人积分 long  
    self.allianceKill = 0--需要的联盟积分 long  
    self.reward = {}-- 通用奖励显示
end

function ActBlackKnightLevelRewardInfo:__delete()
    self.rank = 0--档位 int  
    self.memberKill = 0--需要的个人积分 long  
    self.allianceKill = 0--需要的联盟积分 long  
    self.reward = {}-- 通用奖励显示
end

function ActBlackKnightLevelRewardInfo:ParseInfo(message)
    if message["rank"] ~= nil then
        self.rank = message["rank"]
    end
    if message["memberKill"] ~= nil then
        self.memberKill = message["memberKill"]
    end
    if message["allianceKill"] ~= nil then
        self.allianceKill = message["allianceKill"]
    end
    if message["reward"] ~= nil then
        self.reward = DataCenter.RewardManager:ReturnRewardParamForView(message["reward"])
    end
end

return ActBlackKnightLevelRewardInfo