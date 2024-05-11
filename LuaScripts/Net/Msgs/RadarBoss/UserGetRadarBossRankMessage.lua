--- Created by shimin.
--- DateTime: 2023/9/25 23:06
--- 获取雷达boss排行信息

local UserGetRadarBossRankMessage = BaseClass("UserGetRadarBossRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserGetRadarBossRankMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

function UserGetRadarBossRankMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.RadarBossManager:UserGetRadarBossRankHandle(message)
end

return UserGetRadarBossRankMessage