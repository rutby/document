---
--- 推送怪物攻城信息
--- Created by shimin.
--- DateTime: 2023/3/6 18:33
---
local PushMonsterAttackMessage = BaseClass("PushMonsterAttackMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushMonsterAttackMessage:OnCreate()
    base.OnCreate(self)
end

function PushMonsterAttackMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ActBlackKnightManager:PushMonsterAttackHandle(t)
end

return PushMonsterAttackMessage