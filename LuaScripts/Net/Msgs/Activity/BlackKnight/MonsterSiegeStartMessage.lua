---
--- 联盟开启怪物攻城(R4和盟主有权限开启)
--- Created by shimin.
--- DateTime: 2023/3/6 17:41
---
local MonsterSiegeStartMessage = BaseClass("MonsterSiegeStartMessage", SFSBaseMessage)
local base = SFSBaseMessage

function MonsterSiegeStartMessage:OnCreate()
    base.OnCreate(self)
end

function MonsterSiegeStartMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ActBlackKnightManager:MonsterSiegeStartHandle(t)
end

return MonsterSiegeStartMessage