local repaidJson = require "rapidjson"
local MailScoutReport = BaseClass("MailScoutReport") 

function MailScoutReport:__init()
    self._scoutReport = {}
end

function MailScoutReport:ParseContent(mailContent)
    if table.IsNullOrEmpty(mailContent) then
        return
    end
    
    local scoutReport = mailContent["scoutContent"] or ""
    local pb_ScoutReport = PBController.ParsePb1(scoutReport, "protobuf.ScoutReport")
    self._scoutReport = pb_ScoutReport
end

function MailScoutReport:GetExtData()
    return self._scoutReport
end

function MailScoutReport:GetHeroExpAddInfo()
    return {}
end

--获取坐标点（一维的）
function MailScoutReport:GetPointId()
    local data = self:GetExtData()
    if data ~= nil then
        if data.targetUser then
            --部分侦察邮件没有point
            if data.targetUser.point then
                return SceneUtils.TileXYToIndex(data.targetUser.point.x.value, data.targetUser.point.y.value, ForceChangeScene.World)
            end
        end
    end
    return 0
end

--侦察邮件拆分，pve pvp
function MailScoutReport:IsPveScout()
    local data = self:GetExtData()
    if data ~= nil then
        if data.targetType then
            if data.targetType == ScoutMailTargetType.MAIN_BUILDING or data.targetType == ScoutMailTargetType.ALLIANCE_CITY or data.targetType == ScoutMailTargetType.MARCH 
            or data.targetType == ScoutMailTargetType.BUILDING  or data.targetType == ScoutMailTargetType.CROSS_WORM_HOLE or data.targetType == ScoutMailTargetType.ALLIANCE_BUILD or data.targetType == ScoutMailTargetType.DRAGON_BUILDING then
                return false
            elseif data.targetType == ScoutMailTargetType.COLLECT_BUILDING or data.targetType == ScoutMailTargetType.DESERT then
                local army = data.army
                if army and army.help and army.help.formation and next(army.help.formation) then
                    return false
                end
            end
        end
    end
    return true
end

return MailScoutReport