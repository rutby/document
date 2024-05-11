--- Created by shimin.
--- DateTime: 2023/9/25 15:41
--- 召唤雷达boss

local CallRadarBossMessage = BaseClass("CallRadarBossMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CallRadarBossMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("monsterId", param.monsterId)
    end
end

function CallRadarBossMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.RadarBossManager:CallRadarBossHandle(message)
end

return CallRadarBossMessage