--- 获得上一次召唤的未被击杀的德雷克boss
--- Created by shimin.
--- DateTime: 2023/10/30 21:13
---
local GetUserDrakeBossMessage = BaseClass("GetUserDrakeBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetUserDrakeBossMessage:OnCreate()
    base.OnCreate(self)
end

function GetUserDrakeBossMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ActDrakeBossManager:GetUserDrakeBossHandle(t)
end

return GetUserDrakeBossMessage