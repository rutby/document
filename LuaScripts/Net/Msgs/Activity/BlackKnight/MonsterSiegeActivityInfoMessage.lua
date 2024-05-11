---
--- 获取黑骑士活动信息
--- Created by shimin.
--- DateTime: 2023/3/6 16:57
---
local MonsterSiegeActivityInfoMessage = BaseClass("MonsterSiegeActivityInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MonsterSiegeActivityInfoMessage:OnCreate()
    base.OnCreate(self)
end

function MonsterSiegeActivityInfoMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ActBlackKnightManager:MonsterSiegeActivityInfoHandle(t)
end

return MonsterSiegeActivityInfoMessage