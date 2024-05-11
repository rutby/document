---
--- 怪物攻城奖励信息
--- Created by shimin.
--- DateTime: 2023/3/6 17:57
---
local MonsterSiegeRewardInfoMessage = BaseClass("MonsterSiegeRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MonsterSiegeRewardInfoMessage:OnCreate()
    base.OnCreate(self)
end

function MonsterSiegeRewardInfoMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ActBlackKnightManager:MonsterSiegeRewardInfoHandle(t)
end

return MonsterSiegeRewardInfoMessage