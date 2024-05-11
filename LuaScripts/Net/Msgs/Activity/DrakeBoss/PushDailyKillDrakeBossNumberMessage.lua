--- 推送德雷克活动boos参与击杀次数
--- Created by shimin.
--- DateTime: 2023/10/30 21:13

local PushDailyKillDrakeBossNumberMessage = BaseClass("PushDailyKillDrakeBossNumberMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushDailyKillDrakeBossNumberMessage:OnCreate()
    base.OnCreate(self)
end

function PushDailyKillDrakeBossNumberMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.ActDrakeBossManager:PushDailyKillDrakeBossNumberHandle(t)
end

return PushDailyKillDrakeBossNumberMessage