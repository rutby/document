---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/4/8 17:14
---

local PresidentMineRefreshManager = BaseClass("PresidentMineRefreshManager")
local PresidentMineRefreshInfo = require("DataCenter.PresidentMineRefreshManager.PresidentMineRefreshInfo")

local function __init(self)
    self.info = nil
    self.activityPara1 = nil
    self.activityId = 0
    self.desertId = {}
end

local function __delete(self)
    self.info = nil
    self.activityPara1 = nil
    self.activityId = 0
    self.desertId = {}
end

local function GetRefreshDesertActivityInfo(self, activityId)
    self.activityId = activityId
    SFSNetwork.SendMessage(MsgDefines.GetRefreshDesertActivityInfo, activityId)
end

local function GetRefreshDesertActivityInfoHandler(self, message)
    if message == nil then
        return
    end
    if message["errorCode"] ~= nil then
        local errorCode = message["errorCode"]
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(message["errorCode"])
        end
        return
    end
    self:UpgradeInfo(message)
    EventManager:GetInstance():Broadcast(EventId.RefreshDesertActivityInfoUpdate)
end

local function KingRefreshDesert(self, pointId)
    SFSNetwork.SendMessage(MsgDefines.KingRefreshDesert, self.activityId, pointId)
end

local function KingRefreshDesertHandler(self, message)
    if message == nil then
        return
    end
    if message["errorCode"] ~= nil then
        local errorCode = message["errorCode"]
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(message["errorCode"])
        end
        return
    end
    self:UpgradeInfo(message)
    EventManager:GetInstance():Broadcast(EventId.RefreshDesertActivityInfoUpdate)
end

local function KingRefreshDesertPushHandler(self, message)
    if message == nil then
        return
    end
    if message["errorCode"] ~= nil then
        local errorCode = message["errorCode"]
        if errorCode ~= SeverErrorCode then
            UIUtil.ShowTipsId(message["errorCode"])
        end
        return
    end
    self:UpgradeInfo(message)
    EventManager:GetInstance():Broadcast(EventId.RefreshDesertActivityInfoUpdate)
end

local function GetInfo(self)
    return self.info
end

local function UpgradeInfo(self, message)
    if message == nil then
        return
    end
    if self.info == nil then
        self.info = PresidentMineRefreshInfo.New()
    end
    self.info:ParseData(message)
end

local function GetPresidentAuthorityActivityPara1(self)
    if self.activityPara1 == nil then
        local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
        if activityInfo and not string.IsNullOrEmpty(activityInfo.para1) then
            local vec = string.split(activityInfo.para1, "|")
            if table.count(vec) >= 4 then
                self.activityPara1 = {}
                self.activityPara1.skillIcon = string.format(LoadPath.BuildIconOutCity, vec[1])
                self.activityPara1.skillName = vec[2]
                self.activityPara1.skillDesc = vec[3]
                self.activityPara1.skillDescInWorldChannel = vec[4]
            end
        end
    end
    return self.activityPara1
end

local function NeedShowNew(self)
    if self.activityId == 0 then
        return false
    end

    return self:CheckIfIsNew()
end

local function CheckIfIsNew(self)
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if actListData == nil then
        return false
    end
    local key = "PresidentAuthorityActivity_" .. LuaEntry.Player.uid.."_"..actListData.startTime
    local isFirstOpen = CS.GameEntry.Setting:GetBool(key, true)
    return isFirstOpen
end

local function SetIsNew(self)
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if actListData == nil then
        return
    end
    local key = "PresidentAuthorityActivity_" .. LuaEntry.Player.uid.."_"..actListData.startTime
    CS.GameEntry.Setting:SetBool(key, false)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function ShowChatMessage(self)
    if self.activityId == 0 or self.info == nil or self.info.pointId == 0 then
        return false
    end
    local key = "PresidentRefreshMine_" .. LuaEntry.Player.uid.."_"..self.info.nextRefreshTime
    local closeChatMessage = CS.GameEntry.Setting:GetBool(key, true)
    return closeChatMessage
end

local function SetCloseChatMessage(self)
    local key = "PresidentRefreshMine_" .. LuaEntry.Player.uid.."_"..self.info.nextRefreshTime
    CS.GameEntry.Setting:SetBool(key, false)
end

local function GetMineLevel(self)
    local day = DataCenter.SeasonDataManager:GetSeasonDurationDay() + 1
    local k2 = LuaEntry.DataConfig:TryGetStr("wonder_stone_skill", "k2")
    local k3 = LuaEntry.DataConfig:TryGetStr("wonder_stone_skill", "k3")
    if string.IsNullOrEmpty(k2) or string.IsNullOrEmpty(k3) then
        return 1
    end
    local k2Vec = string.split(k2, ";")
    local k3Vec = string.split(k3, ";")
    if #k2Vec ~= #k3Vec then
        return 1
    end

    for k, v in ipairs(k2Vec) do
        local vec = string.split(v, "-")
        if #vec == 2 then
            local min = toInt(vec[1])
            local max = toInt(vec[2])
            if day >= min and day <= max then
                return toInt(k3Vec[k])
            end
        end
    end
    return 1
end

local function GetDesertId(self, type, level)
    local key = type.."_"..level
    if self.desertId[key] ~= nil then
        return self.desertId[key]
    end
    local curSeason = DataCenter.SeasonDataManager:GetSeason()
    LocalController:instance():visitTable(TableName.Desert, function(id, lineData)
        local xmlType = toInt(lineData["desert_type"])
        local xmlLevel = toInt(lineData["desert_level"])
        local xmlSeason = toInt(lineData["season"])
        if xmlSeason == curSeason and xmlLevel == level and xmlType == type then
            local id = lineData["id"]
            self.desertId[key] = id
        end
    end)
    
    return self.desertId[key]
end

PresidentMineRefreshManager.__init = __init
PresidentMineRefreshManager.__delete = __delete
PresidentMineRefreshManager.GetRefreshDesertActivityInfo = GetRefreshDesertActivityInfo
PresidentMineRefreshManager.GetRefreshDesertActivityInfoHandler = GetRefreshDesertActivityInfoHandler
PresidentMineRefreshManager.KingRefreshDesert = KingRefreshDesert
PresidentMineRefreshManager.KingRefreshDesertHandler = KingRefreshDesertHandler
PresidentMineRefreshManager.KingRefreshDesertPushHandler = KingRefreshDesertPushHandler
PresidentMineRefreshManager.GetInfo = GetInfo
PresidentMineRefreshManager.UpgradeInfo = UpgradeInfo
PresidentMineRefreshManager.GetPresidentAuthorityActivityPara1 = GetPresidentAuthorityActivityPara1
PresidentMineRefreshManager.NeedShowNew = NeedShowNew
PresidentMineRefreshManager.CheckIfIsNew = CheckIfIsNew
PresidentMineRefreshManager.SetIsNew = SetIsNew
PresidentMineRefreshManager.ShowChatMessage = ShowChatMessage
PresidentMineRefreshManager.SetCloseChatMessage = SetCloseChatMessage
PresidentMineRefreshManager.GetMineLevel = GetMineLevel
PresidentMineRefreshManager.GetDesertId = GetDesertId

return PresidentMineRefreshManager