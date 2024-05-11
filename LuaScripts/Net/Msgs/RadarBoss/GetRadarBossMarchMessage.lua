--- Created by shimin.
--- DateTime: 2023/9/25 18:45
--- 获取世界雷达boss行军信息

local GetRadarBossMarchMessage = BaseClass("GetRadarBossMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetRadarBossMarchMessage:OnCreate()
    base.OnCreate(self)
end

function GetRadarBossMarchMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.RadarBossManager:GetRadarBossMarchHandle(message)
end

return GetRadarBossMarchMessage