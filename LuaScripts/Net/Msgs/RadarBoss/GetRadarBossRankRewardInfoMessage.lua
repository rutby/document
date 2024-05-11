--- Created by shimin.
--- DateTime: 2023/9/25 23:11
--- 雷达boss奖励

local GetRadarBossRankRewardInfoMessage = BaseClass("GetRadarBossRankRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetRadarBossRankRewardInfoMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

function GetRadarBossRankRewardInfoMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.RadarBossManager:GetRadarBossRankRewardInfoHandle(message)
end

return GetRadarBossRankRewardInfoMessage