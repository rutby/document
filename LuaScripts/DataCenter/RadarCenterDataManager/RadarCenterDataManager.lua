---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/2 11:13
---
local rapidjson = require "rapidjson"
local RadarCenterDataManager = BaseClass("RadarCenterDataManager")
local Setting = CS.GameEntry.Setting
local Localization = CS.GameEntry.Localization
local auto_get_info_time_gap = 300000

local function __init(self)
    self.detectInfo = {}
    self.events = {}
    self.records = {}
    self.timer_action = function(temp)
        self:CheckRefreshTimeAndAutoRefresh()
    end
    DataCenter.DetectEventBubbleManager:StartUp()

    self:SetCompleteByHelperRecordList()
end

local function HandleResetData(self, message)
    if message["detectInfo"] ~= nil then
        self:UpdateDetectInfo(message["detectInfo"])
    end
    if message["deleteEventUuid"] ~= nil then
        self:RemoveDetectEventInfo(message["deleteEventUuid"])
    end
    if message["newEvent"] ~= nil then
        self:UpdateOneDetectEventInfo(message["newEvent"])
    end
    if message["gold"] ~= nil then
        LuaEntry.Player.gold = message["gold"]
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
end

local function UpdateDetectEventInfo(self, message)
    self.detectInfo = {}
    if message["detectInfo"] ~= nil then
        self:UpdateDetectInfo(message["detectInfo"])
    end
    self.events = {}
    if message["events"] ~= nil then
        table.walk(message["events"], function (k, v)
            self:UpdateOneDetectEventInfo(v)
        end)
    end
    DataCenter.FakeCollectGarbageMarchManager:RemoveAllDisappearEvent()
    DataCenter.FakeHelperMarchManager:RemoveAllDisappearEvent()
    DataCenter.FakeRescueMarchManager:RemoveAllDisappearEvent()
end

local function GetDetectEventInfoUuids(self)
    local tmp = table.keys(self.events)
    local result = {}
    table.walk(tmp, function (k, v)
        local data = self:GetDetectEventInfo(v)
        if data ~= nil then
            local templateType = DataCenter.DetectEventTemplateManager:GetTableValue(data.eventId,"type")
            if templateType ~= nil and (templateType == DetectEventType.DetectEventTypeSpecial or
                    templateType == DetectEventType.DetectEventRadarRally or
                    templateType == DetectEventType.DetectEventPVE or
                    templateType == DetectEventType.SPECIAL_OPS or
                    data.endTime > UITimeManager:GetInstance():GetServerTime() or
                    data.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
            then
                table.insert(result, v)
            end
        end
    end)

    table.sort(result, function (k, v)
        local data1 = self:GetDetectEventInfo(k)
        local data2 = self:GetDetectEventInfo(v)
        if data1 ~= nil and data2 ~= nil then
            if data1.state ~= data2.state then
                return data2.state == DetectEventState.DETECT_EVENT_STATE_FINISHED
            end
            local posA = SceneUtils.IndexToTilePos(data1.pointId, ForceChangeScene.World)
            local posB = SceneUtils.IndexToTilePos(data2.pointId, ForceChangeScene.World)
            return posB.y < posA.y
        end
        return false
    end)
    return result
end

local function GetFinishedDetectEventNum(self)
    local count = 0
    table.walk(self.events, function (k, v)
        if v and v.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
            count = count + 1
        end
    end)
    return count
end

local function GetDetectEventInfo(self, uuid)
    return self.events[uuid]
end

local function GetDetectEventInfoByPointId(self, pointId)
    for _, v in pairs(self.events) do
        if v.pointId == pointId then
            return v
        end
    end
    return nil
end

local function GetDetectInfoLevel(self)
    if self.detectInfo == nil then
        return 1
    end
    return self.detectInfo.level or 1
end

local function GetDetectInfoPower(self)
    if self.detectInfo == nil then
        return 1
    end
    return self.detectInfo.power or 1
end

local function GetDetectInfoCompleteNum(self)
    if self.detectInfo == nil then
        return 1
    end
    return self.detectInfo.completeNum or 1
end

local function GetDetectInfoNextRefreshTime(self)
    if self.detectInfo == nil then
        return 1
    end
    return self.detectInfo.nextRefreshTime or 1
end

local function GetPowerRewardList(self)
    return self.detectInfo.powerRewardList
end

local function GetLevelRewardList(self)
    return self.detectInfo.levelRewardList
end

local function GetDetectInfo(self)
    return self.detectInfo
end

local function GetMaxDetectNum(self)
    return self.detectInfo.eventNum or 0
end

local function GetResetNum(self)
    return self.detectInfo.resetNum or 0
end

local function UpdateOneDetectEventInfo(self, message)
    if message["uuid"] ~= nil then
        local uuid = message["uuid"]
        if self.events[uuid] == nil then
            local info = DetectEventInfo.New()
            self.events[uuid] = info
        end
        self.events[uuid]:ParseData(message)
    end
end

local function UpdateDetectInfo(self, message)
    self.detectInfo.level = message["level"]
    self.detectInfo.power = message["power"]
    self.detectInfo.completeNum = message["completeNum"]
    self.detectInfo.nextRefreshTime = message["nextRefreshTime"]
    self.detectInfo.eventNum = message["eventNum"]
    self.detectInfo.signal = message["signal"]
    self.detectInfo.resetNum = message["resetNum"]
    self.detectInfo.specialOpsOrder = message["specialOpsOrder"] or 0
    self.detectInfo.specialOpsNum = message["specialOpsNum"] or 0
    self.detectInfo.bossProgress = message["bossProgress"] or 0--int 今日进度
    self.detectInfo.callBossTime = message["callBossTime"] or 0--long 上次召唤boss时间
    if message["dmgRateArr"] ~= nil then
        self.detectInfo.dmgRateArr = {}
        table.walk(message["dmgRateArr"], function (_, v)
            self.detectInfo.dmgRateArr[v.id] = v.dmgRate
        end)
    end
    
    self.detectInfo.levelRewardList = {}
    if message["levelReward"] then
        self.detectInfo.levelRewardList = DataCenter.RewardManager:ReturnRewardParamForView(message["levelReward"])
    end

    self.detectInfo.powerRewardList = {}
    if message["powerReward"] then
        self.detectInfo.powerRewardList = DataCenter.RewardManager:ReturnRewardParamForView(message["powerReward"])
    end
    self:AddRefreshTimer()
end

local function AddRefreshTimer(self)
    self:RemoveRefreshTimer()
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = (self.detectInfo.nextRefreshTime - now) / 1000
    if time <= 0 then
        return
    end
    if self.refreshTimer == nil then
        time = time + 3--避免前后台时间差异
        self.refreshTimer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, false,false,false)
    end

    self.refreshTimer:Start()
end

local function RemoveRefreshTimer(self)
    if self.refreshTimer ~= nil then
        self.refreshTimer:Stop()
        self.refreshTimer = nil
    end
end

local function CheckRefreshTimeAndAutoRefresh(self)
    if self.detectInfo == nil or self.detectInfo.nextRefreshTime == nil then
        return
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    if now > self.detectInfo.nextRefreshTime + 2000 then
        if self.lastAutoRequestTime == nil or now > self.lastAutoRequestTime + auto_get_info_time_gap then
            self:GetDetectEventData()
            self.lastAutoRequestTime = now
        end
    end
end

local function UpgradeDetectPowerInfo(self, message)
    self.detectInfo = {}
    if message["detectInfo"] ~= nil then
        self:UpdateDetectInfo(message["detectInfo"])
    end
    if message["reward"] ~= nil then
        DataCenter.RewardManager:ShowCommonReward(message)
        for _,v in pairs(message["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
end

local function RemoveDetectEventInfo(self, uuid)
    if table.containsKey(self.events, uuid) then
        self.events[uuid] = nil
    end
end

local function GetDetectEventRewardBack(self, message)
    if message["uuid"] ~= nil then
        self:RemoveDetectEventInfo(message["uuid"])
        self:RemoveCompleteByHelperRecord(message["uuid"])
    end
    if message["detectInfo"] ~= nil then
        self:UpdateDetectInfo(message["detectInfo"])
    end
    if message["reward"] ~= nil then
        DataCenter.RewardManager:ShowCommonReward(message)
        for _,v in pairs(message["reward"]) do
            DataCenter.RewardManager:AddOneReward(v)
        end
    end
    if message["gold"]~=nil then
        LuaEntry.Player.gold = message["gold"]
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if message["newEvent"] ~= nil then
        self:UpdateOneDetectEventInfo(message["newEvent"])
    end
end

local function __delete(self)
    self.detectInfo = nil
    self.events = nil
    self.records = nil
    self:RemoveRefreshTimer()
end

local function InitData(self)
    self:GetDetectEventData()
end

local function GetDetectEventData(self)
    SFSNetwork.SendMessage(MsgDefines.DetectInfoGet)
end

local function StartDetectEventPve(self, uuid, heroes, formations, pass)
    SFSNetwork.SendMessage(MsgDefines.FinishDetectEventPve, uuid, heroes, formations, pass)
end

local function ResetDetectEvent(self, uuid)
    SFSNetwork.SendMessage(MsgDefines.ResetDetectEvent, uuid)
end

local function FindMonsterBoss(self, level)
    SFSNetwork.SendMessage(MsgDefines.FindMonsterBoss, level, 1)
end

local function HandleFindMonsterBossBack(self, message)
    if message["errorCode"] ~= nil and message["errorCode"] ~= SeverErrorCode then
        UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
        return
    end
    if message["uuid"] ~= nil then
        local pointId = message["pointId"]
        UIManager.Instance:DestroyWindow(UIWindowNames.UIDetectEvent)
        GoToUtil.MoveToWorldPointAndOpen(pointId)
    end
end

local function IsCanUpdate(self)
    local currentPowerLv = DataCenter.RadarCenterDataManager:GetDetectInfoPower()
    local maxLv = LuaEntry.DataConfig:TryGetNum("detect_config", "k5")
    if currentPowerLv >= maxLv then
        return false
    end
    local needId, needNum = self:GetUpgradeItem()

    if needId == nil or needNum == nil then
        return false
    end
    local cnt = 0
    local item = DataCenter.ItemData:GetItemById(needId)
    if item ~= nil then
        cnt = item.count
    end

    return cnt >= needNum
end

local function GetUpgradeItem(self)
    local currentPowerLv = DataCenter.RadarCenterDataManager:GetDetectInfoPower()

    local needItemId = LuaEntry.DataConfig:TryGetNum("detect_config", "k6")

    local needItemNumStr = LuaEntry.DataConfig:TryGetStr("detect_config", "k7")
    local needItemNums = string.split(needItemNumStr,";")

    if table.count(needItemNums) < currentPowerLv then
        return nil
    end
    return needItemId, toInt(needItemNums[currentPowerLv])
end

local function IsDetectEventDoing(self, uuid)
    local eventData = self:GetDetectEventInfo(uuid)
    if eventData == nil then
        return false
    end
    if DataCenter.FakeCollectGarbageMarchManager:IsEventDoing(eventData.pointId) then
        return true
    end
    if DataCenter.FakeHelperMarchManager:IsEventDoing(eventData.pointId) then
        return true
    end
    local Player = LuaEntry.Player
    local allianceId = Player.allianceId
    local myUid = Player.uid
    local allList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()

    if allList ~= nil then
        for _, v in ipairs(allList) do
            if v.state == ArmyFormationState.March then
                local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(myUid,v.uuid,allianceId)
                if march ~= nil and eventData.uuid == march.targetUuid and march:GetMarchTargetType() ~= MarchTargetType.BACK_HOME then
                    return true
                end
            end
        end
    end
    return false
end

local function GetSpecialEventInfo(self)
    if self.events ~= nil then
        for k,v in pairs(self.events) do
            local templateType = DataCenter.DetectEventTemplateManager:GetTableValue(v.eventId,"type")
            if templateType == DetectEventType.DetectEventTypeSpecial then
                return v
            end
        end
    end
end

local function GetRadarRallyTotalNum(self)
    return table.count(self.events)
end

local function GetRadarRallyFinishedNum(self)
    local count = 0
    for _, event in pairs(self.events) do
        if event.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
            local templateType = DataCenter.DetectEventTemplateManager:GetTableValue(event.eventId,"type")
            if templateType == DetectEventType.DetectEventRadarRally then
                count = count + 1
            end
        end
    end
    return count
end

local function AddToFakeGarbageMarchManager(self, pointId)
    DataCenter.FakeCollectGarbageMarchManager:AddMarchIndex(pointId)
end

local function IsCanReset(self, type)
    return type ~= DetectEventType.DetectEventTypeSpecial and type ~= DetectEventType.DetectEventRadarRally and type ~= DetectEventType.HeroTrial and type ~= DetectEventType.SPECIAL_OPS
end

local function UpdateEventNum(self, count)
    if self.detectInfo ~= nil then
        self.detectInfo.eventNum = count
    end
end

--获取所有雷达怪
local function GetRadarMonsterList(self)
    local result = {}
    for _, event in pairs(self.events) do
        if event.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
            local templateType = DataCenter.DetectEventTemplateManager:GetTableValue(event.eventId,"type")
            if templateType == DetectEventType.DetectEventTypeNormal then
                table.insert(result, event)
            end
        end
    end
    return result
end

--通过事件类型取出未完成且品质最低的事件
local function GetOneInfoByEventTypeAndState(self,eventType,state)
    local result = nil
    local quality = 999
    if self.events ~= nil then
        for _, event in pairs(self.events) do
            if event.state == state then
                local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(event.eventId)
                if template:getValue("type") == eventType then
                    local tempQuality = template:getValue("quality")
                    if quality > tempQuality then
                        quality = tempQuality
                        result = event
                    end
                end
            end
        end
    end
    return result
end

local function GetRadarBubbleOpenMainCityLevel(self)
    if self.bubbleOpenLv == nil then
        self.bubbleOpenLv = LuaEntry.DataConfig:TryGetNum("buildingBubble_control","k2")
    end
    return self.bubbleOpenLv or 0
end

local function CheckGuideOpenBuildBubble(self)
    local mainBuildLV = DataCenter.BuildManager.MainLv
    if mainBuildLV >= self:GetRadarBubbleOpenMainCityLevel() then
        return true
    end
    return DataCenter.GuideManager:IsShowRadarBubble()
end

local function GetNextSpecialEventRefreshTime(self)
    local timeGap = LuaEntry.DataConfig:TryGetNum("detect_config", "k20") * 3600 * 1000
    local time = UITimeManager:GetInstance():GetServerTime()
    local nextDayTime = UITimeManager:GetInstance():GetNextDayMs()
    local leftTime = nextDayTime - time
    return timeGap, nextDayTime - math.floor(leftTime / timeGap) * timeGap
end

local function GetSpecialEvent(self)
    if self.events ~= nil then
        for k,v in pairs(self.events) do
            local templateType = DataCenter.DetectEventTemplateManager:GetTableValue(v.eventId,"type")
            if templateType == DetectEventType.SPECIAL_OPS then
                return v
            end
        end
    end
    return nil
end

local function GetCurrentShowSpecialEventName(self)
    if self.detectInfo == nil then
        return ""
    end
    local order = self.detectInfo.specialOpsOrder or 0
    local num = self.detectInfo.specialOpsNum or 0
    if num == 0 then
        order = order + 1
    end
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplateByOrder(order)
    if template ~= nil then
        return DataCenter.DetectEventTemplateManager:GetRealName(template:getValue("id"))
    end
    return ""
end

local function GetDetectEventInfoByType(self)
    
end

local function GotoWorldAndFindBlank(self, uuid)
    local GotoAndOpen = function()
        local desertMap = DataCenter.WorldPointManager:GetDesertPointList()
        if desertMap ~= nil and table.count(desertMap) > 0 then
            local pointList = {}
            for k,v in pairs(desertMap) do
                local pi = v:GetWorldDesertInfo()
                local typeNew = pi:GetPlayerType()
                local param = {}
                param.point = pi.pointIndex
                param.lv = GetTableData(TableName.Desert, pi.desertId, "desert_level")
                if pi:GetPlayerType() == CS.PlayerType.PlayerNone then
                    table.insert(pointList,param)
                end
            end
            if next(pointList) then
                table.sort(pointList,function(a,b)
                    if a.lv < b.lv then
                        return true
                    end
                    return false
                end)
                local pos = pointList[1]
                local worldPos = SceneUtils.TileIndexToWorld(pos.point, ForceChangeScene.World)
                GoToUtil.GotoWorldPos(worldPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                    --WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPos)
                    UIUtil.OnClickWorld(pos.point)
                end)
            end
        end
    end

    if not CS.SceneManager.IsInWorld() then
        SceneUtils.ChangeToWorld(function()
            TimerManager:GetInstance():DelayInvoke(function()
                GotoAndOpen()
            end, 0.5)
        end)
    else
        GotoAndOpen()
    end

end

local function GetPanelPreOpenTime(self)
    local key = "detect_event_panel_open" .. LuaEntry.Player.uid
    return Setting:GetInt(key, 0)
end

local function SetPanelPreOpenTime(self)
    local key = "detect_event_panel_open" .. LuaEntry.Player.uid
    local time = UITimeManager:GetInstance():GetServerSeconds()
    Setting:SetInt(key, time)
end

local function IsOpenInSameDay(self)
    local currentTime = UITimeManager:GetInstance():GetServerSeconds()
    local preOpenTime = self:GetPanelPreOpenTime()
    UITimeManager:GetInstance():IsSameDayForServer(currentTime, preOpenTime)
end

local function IsUnFinishFakeGarbageEvent(self, index)
    local result = false
    local info = self:GetDetectEventInfoByPointId(index)
    if info ~= nil and info.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(info.eventId)
        local templateType = DataCenter.DetectEventTemplateManager:GetTableValue(info.eventId,"type")
        if templateType == DetectEventType.DetectEventPickGarbage then
            result = true
        end
    end
    return result
end

--获取boss召唤进度
function RadarCenterDataManager:GetBossProgress()
    return self.detectInfo.bossProgress or 0
end
--获取boss召唤时间
function RadarCenterDataManager:GetCallBossTime()
    return self.detectInfo.callBossTime or 0
end

--设置boss召唤时间
function RadarCenterDataManager:SetCallBossTime(time)
    if self.detectInfo ~= nil then
        self.detectInfo.callBossTime = time
    end
end

--获取上一个boss攻击伤害
function RadarCenterDataManager:GetDmgRate(bossId)
    if self.detectInfo.dmgRateArr ~= nil then
        return self.detectInfo.dmgRateArr[bossId] or 0
    end
    return 0
end

function RadarCenterDataManager:GetDetectEventInfoByEventId(eventId)
    for _, v in pairs(self.events) do
        if v.eventId == eventId then
            return v
        end
    end
    return nil
end

--是否可以显示气泡（大本超过配置等级不显示）
function RadarCenterDataManager:CanShowBubble()
    local needLevel = LuaEntry.DataConfig:TryGetNum("detect_config", "k21")
    local mainBuildLV = DataCenter.BuildManager.MainLv
    if needLevel > 0 and mainBuildLV >= needLevel then
        return false
    end
    return true
end


function RadarCenterDataManager:CanShowBuildBubble(ignore)
    if self:CanShowBubble() and self:CheckGuideOpenBuildBubble() or ignore then
        for k, v in pairs(self.events) do
            local templateType = DataCenter.DetectEventTemplateManager:GetTableValue(v.eventId, "type")
            if templateType ~= nil and templateType ~= DetectEventType.SPECIAL_OPS
                    and (templateType == DetectEventType.DetectEventTypeSpecial or
                    templateType == DetectEventType.DetectEventRadarRally or
                    templateType == DetectEventType.DetectEventPVE or
                    v.endTime > UITimeManager:GetInstance():GetServerTime() or
                    v.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
            then
                return true
            end
        end
    end
    
    return false
end

local function GetHelperEventDataByBuildUid(self, uid)
    local helperEventData = nil

    if self.events ~= nil then
        for k,v in pairs(self.events) do
            if v.helpInfo ~= nil and v.helpInfo.bUid == uid then
                local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(v.eventId)
                if template.type == DetectEventType.HELP then
                    helperEventData = v
                    break
                end
            end
        end
    end

    return helperEventData
end

local function GetCompleteByHelperList(self)
    local result = {}
    if self.events ~= nil then
        for k,v in pairs(self.events) do
            if v.completeByHelper ~= nil and not table.hasvalue(self.records, v.uuid) then
                table.insert(result, v)
            end
        end
    end
    return result
end

local function GetRecordKey(self)
    local curPlayerUid = LuaEntry.Player.uid
    local recordKey = "CompleteByHelper."
    local key = string.format("%s%s", recordKey, curPlayerUid)
    return key
end

local function AddCompleteByHelperRecord(self, list)
    if #list == 0 then
        return
    end
    for i, v in ipairs(list) do
        table.insert(self.records, v)
    end
    self:SaveCompleteByHelperRecord()
end

local function RemoveCompleteByHelperRecord(self, uuid)
    if #self.records == 0 then
        return
    end

    table.removebyvalue(self.records, uuid)
    self:SaveCompleteByHelperRecord()
end

local function SetCompleteByHelperRecordList(self)
    if #self.records > 0 then
        return self.records
    end

    local key = self:GetRecordKey()
    --Setting:SetPrivateString(key, "")
    local json = Setting:GetPrivateString(key, "")
    Logger.Log(string.format("Load %s", key) .. json)
    if json == "" then
        return
    end
    self.records = rapidjson.decode(json)
    return self.records
end

local function SaveCompleteByHelperRecord(self)
    local key = self:GetRecordKey()
    if #self.records == 0 then
        Setting:SetPrivateString(key, "")
    else
        local json = rapidjson.encode(self.records)
        Setting:SetPrivateString(key, json)
        Logger.Log(string.format("Save %s", key) .. json)
    end
end

local function GetDetectCostNum(type, self)
    if type == DetectEventType.PLOT then
        return 0
    elseif type == DetectEventType.HELP then
        local k16 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k16")
        return k16
    elseif type == DetectEventType.RESCUE then
        local k17 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k17")
        return k17
    elseif type == DetectEventType.DetectEventPickGarbage then
        local k10 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k10")
        return k10
    end
    return 10
end

RadarCenterDataManager.GetPanelPreOpenTime = GetPanelPreOpenTime
RadarCenterDataManager.SetPanelPreOpenTime = SetPanelPreOpenTime
RadarCenterDataManager.IsOpenInSameDay = IsOpenInSameDay
RadarCenterDataManager.__init = __init
RadarCenterDataManager.__delete = __delete
RadarCenterDataManager.UpdateDetectEventInfo = UpdateDetectEventInfo
RadarCenterDataManager.GetDetectEventRewardBack = GetDetectEventRewardBack
RadarCenterDataManager.UpdateOneDetectEventInfo = UpdateOneDetectEventInfo
RadarCenterDataManager.UpdateDetectInfo = UpdateDetectInfo
RadarCenterDataManager.UpgradeDetectPowerInfo = UpgradeDetectPowerInfo
RadarCenterDataManager.GetDetectEventInfoUuids = GetDetectEventInfoUuids
RadarCenterDataManager.GetDetectEventInfo = GetDetectEventInfo
RadarCenterDataManager.GetDetectInfo = GetDetectInfo
RadarCenterDataManager.GetDetectInfoLevel = GetDetectInfoLevel
RadarCenterDataManager.GetDetectInfoPower = GetDetectInfoPower
RadarCenterDataManager.GetDetectInfoCompleteNum = GetDetectInfoCompleteNum
RadarCenterDataManager.GetDetectInfoNextRefreshTime = GetDetectInfoNextRefreshTime
RadarCenterDataManager.RemoveDetectEventInfo = RemoveDetectEventInfo
RadarCenterDataManager.GetPowerRewardList = GetPowerRewardList
RadarCenterDataManager.GetLevelRewardList = GetLevelRewardList
RadarCenterDataManager.GetFinishedDetectEventNum = GetFinishedDetectEventNum
RadarCenterDataManager.InitData = InitData
RadarCenterDataManager.GetDetectEventData = GetDetectEventData
RadarCenterDataManager.GetDetectEventInfoByPointId = GetDetectEventInfoByPointId
RadarCenterDataManager.GetDetectEventInfoByType = GetDetectEventInfoByType

RadarCenterDataManager.IsCanUpdate = IsCanUpdate
RadarCenterDataManager.GetUpgradeItem = GetUpgradeItem
RadarCenterDataManager.IsDetectEventDoing = IsDetectEventDoing
RadarCenterDataManager.GetSpecialEventInfo = GetSpecialEventInfo
RadarCenterDataManager.GetRadarRallyTotalNum = GetRadarRallyTotalNum
RadarCenterDataManager.GetRadarRallyFinishedNum = GetRadarRallyFinishedNum
RadarCenterDataManager.AddToFakeGarbageMarchManager = AddToFakeGarbageMarchManager
RadarCenterDataManager.StartDetectEventPve = StartDetectEventPve
RadarCenterDataManager.GetMaxDetectNum = GetMaxDetectNum
RadarCenterDataManager.IsCanReset = IsCanReset
RadarCenterDataManager.ResetDetectEvent = ResetDetectEvent
RadarCenterDataManager.HandleResetData = HandleResetData
RadarCenterDataManager.GetResetNum = GetResetNum
RadarCenterDataManager.UpdateEventNum = UpdateEventNum
RadarCenterDataManager.FindMonsterBoss = FindMonsterBoss
RadarCenterDataManager.HandleFindMonsterBossBack = HandleFindMonsterBossBack
RadarCenterDataManager.GetRadarMonsterList = GetRadarMonsterList
RadarCenterDataManager.GetOneInfoByEventTypeAndState = GetOneInfoByEventTypeAndState
RadarCenterDataManager.CheckGuideOpenBuildBubble = CheckGuideOpenBuildBubble
RadarCenterDataManager.GetNextSpecialEventRefreshTime = GetNextSpecialEventRefreshTime
RadarCenterDataManager.GetSpecialEvent = GetSpecialEvent
RadarCenterDataManager.GetRadarBubbleOpenMainCityLevel = GetRadarBubbleOpenMainCityLevel
RadarCenterDataManager.GetCurrentShowSpecialEventName = GetCurrentShowSpecialEventName
RadarCenterDataManager.GotoWorldAndFindBlank = GotoWorldAndFindBlank
RadarCenterDataManager.AddRefreshTimer = AddRefreshTimer
RadarCenterDataManager.RemoveRefreshTimer = RemoveRefreshTimer
RadarCenterDataManager.CheckRefreshTimeAndAutoRefresh = CheckRefreshTimeAndAutoRefresh
RadarCenterDataManager.IsUnFinishFakeGarbageEvent = IsUnFinishFakeGarbageEvent
RadarCenterDataManager.GetHelperEventDataByBuildUid = GetHelperEventDataByBuildUid
RadarCenterDataManager.GetDetectCostNum = GetDetectCostNum
RadarCenterDataManager.GetCompleteByHelperList = GetCompleteByHelperList
RadarCenterDataManager.GetRecordKey = GetRecordKey
RadarCenterDataManager.AddCompleteByHelperRecord = AddCompleteByHelperRecord
RadarCenterDataManager.RemoveCompleteByHelperRecord = RemoveCompleteByHelperRecord
RadarCenterDataManager.SetCompleteByHelperRecordList = SetCompleteByHelperRecordList
RadarCenterDataManager.SaveCompleteByHelperRecord = SaveCompleteByHelperRecord
return RadarCenterDataManager