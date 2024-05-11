--- Created by shimin.
--- DateTime: 2023/9/26 10:40
--- 每天实际领取奖励的次数

local GetRadarBossRewardCountMessage = BaseClass("GetRadarBossRewardCountMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetRadarBossRewardCountMessage:OnCreate()
    base.OnCreate(self)
end

function GetRadarBossRewardCountMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.RadarBossManager:GetRadarBossRewardCountHandle(message)
end

return GetRadarBossRewardCountMessage