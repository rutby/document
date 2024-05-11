local AllianceCompeteDataManager = BaseClass("AllianceCompeteDataManager")
local AllianceCityOccupyInfo = require "DataCenter.WorldAllianceCityData.AllianceCityOccupyInfo"
local function __init(self)
    self.heroEventInfo = nil--联盟对决页签的显隐控制
    self.rankInfoDic = {}
    self.rankList = {}
end

local function __delete(self)
    self.heroEventInfo = nil
    self.rankInfoDic = nil
    self.heroEventInfo = nil
    self.rankList = nil
end


local function RefreshWeekResultVS(self, message)
    if message == nil then
        return
    end
    local activity = message
    if activity["vsAllianceInfo"] ~= nil then
        local vsAllianceInfo = activity["vsAllianceInfo"]
        -- printInfo("RefreshWeekResultVS联盟对决，联盟名字=*a")     

        self.vsAllianceList = {}
        -- printInfo("RefreshWeekResultVS联盟对决，联盟名字=*b")     
        table.walk(vsAllianceInfo,function(k,v)
            -- printInfo("RefreshWeekResultVS联盟对决，联盟名字="..v["alName"])     
            local allianceId = v["allianceId"]
            self.vsAllianceList[allianceId] = {}
            self.vsAllianceList[allianceId].id = allianceId
            self.vsAllianceList[allianceId].alName = v["alName"]
            self.vsAllianceList[allianceId].abbr = v["abbr"]
            self.vsAllianceList[allianceId].icon = v["icon"]
            self.vsAllianceList[allianceId].alScore = v["alScore"]
            self.vsAllianceList[allianceId].win = v["win"]
            self.vsAllianceList[allianceId].winScore = v["winScore"]
            self.vsAllianceList[allianceId].serverId = v["serverId"]
        end)
        -- printInfo("返回结果=-1")
    end
    if message["mvpPlayer"] ~= nil then
        local mvpPlayer = message["mvpPlayer"]
        -- printInfo("RefreshWeekResultVS联盟对决，mvp名字=aaaaaa12=")
        -- printInfo("RefreshWeekResultVS联盟对决，mvp名字=aaaaaa123="..mvpPlayer["name"])
        self.vsAllianceList_mvpPlayer = {}
        self.vsAllianceList_mvpPlayer.uid = mvpPlayer["uid"]
        self.vsAllianceList_mvpPlayer.pic = mvpPlayer["pic"]
        self.vsAllianceList_mvpPlayer.picVer = mvpPlayer["picVer"]
        self.vsAllianceList_mvpPlayer.name = mvpPlayer["name"]
        -- printInfo("RefreshWeekResultVS联盟对决，mvp名字="..self.vsAllianceList_mvpPlayer.name)
    end
    if message["finishTime"] ~= nil then
        self.vsAllianceList_finishTime = message["finishTime"]
    end
    if message["isWin"] ~= nil then
        self.vsAllianceList_isWin = message["isWin"]
        -- printInfo("RefreshWeekResultVS联盟对决，结果="..self.vsAllianceList_isWin)
        EventManager:GetInstance():Broadcast(EventId.Nofity_Alliance_Battle_Week_Rusult_VS)
    end
end

local function RefreshRankList(self, message)
    if message["rankInfo"] then
        local rankArray = message["rankInfo"]
        local rankList = {}
        table.walk(rankArray , function(k , v)
            table.insert(rankList , v)
        end)
        
        if message["type"] then
            local tempType = message["type"]
            self.rankInfoDic[tempType] = rankList
        else
            self.rankList = rankList
        end
        EventManager:GetInstance():Broadcast(EventId.AllianceCompeteRankListUpdated)
    end
end

local function RefreshWeeklySummaryMsg(self, message)
    if message["resultArray"] then
        -- printInfo("-------------------------------------RefreshWeekResultMsg")   
        local resultArray = message["resultArray"]
        self.weekResultViewList = {}
        self.weekResultViewStartTime = message["startTime"]
        table.walk(resultArray , function(k , v)
            table.insert(self.weekResultViewList , v)
        end)
        self.extraActivitys = message["extraActivitys"]

        EventManager:GetInstance():Broadcast(EventId.AllianceCompeteWeeklySummaryUpdated)
    end
end

local function GetVSAllianceList(self)
    return self.vsAllianceList
end

local function GetFinishTime(self)
    return self.vsAllianceList_finishTime
end


local function GetRankList(self, rankType)
    return self.rankInfoDic[rankType] or self.rankList
end

local function GetWeeklySummaryList(self)
    return self.weekResultViewList
end

local function GetExtraActivityList(self)
    return self.extraActivitys;
end

local function GetWeeklySummaryStartTime(self)
    return self.weekResultViewStartTime
end

local function CheckIfIsInCompete(self)
    local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if not alCompeteInfo then
        return false
    end
    local eventInfo = alCompeteInfo:GetEventInfo()
    if eventInfo == nil or eventInfo.vsAllianceList == nil then
        return false
    end
    return true
end

local function GetFightServerId(self)
    local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if alCompeteInfo then
        local eventInfo = alCompeteInfo:GetEventInfo()
        if eventInfo then
            return eventInfo.targetServerId
        end
    end
    return 0
end

local function GetCrossServerEndTime(self)
    local alCompeteInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if alCompeteInfo then
        local eventInfo = alCompeteInfo:GetEventInfo()
        if eventInfo then
            return eventInfo.endTime
        end
    end
    return 0
end

local function GetFightAllianceId(self) --获取杀敌日对手联盟id
    if LuaEntry.Player:IsInAlliance() then
        local allianceActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
        if allianceActInfo~=nil then
            local eventInfo = allianceActInfo:GetEventInfo()
            if eventInfo~=nil then
                if eventInfo.crossFight>0 then
                    return eventInfo.targetAllianceId
                end
            end
        end
    end
    return ""
end

local function CacheOpeningTabIndex(self, tempTab)
    self.cacheTabIndex = tempTab
end

local function GetDefaultOpenTabIndex(self)
    local actRedCount = self:GetAlCompeteActivityRedCount()
    if actRedCount > 0 then
        return 1
    else
        return self.cacheTabIndex
    end
end

local function GetAlCompeteteTotalRedCount(self)
    local totalCount = 0

    local actRed = self:GetAlCompeteActivityRedCount()
    totalCount = actRed + totalCount

    return totalCount
end

local function GetAlCompeteActivityRedCount(self)
    local redCount = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(EnumActivity.AllianceCompete.Type, EnumActivity.AllianceCompete.ActId)
    return redCount
end

local function RequestFightServerAllianceCity(self)
    local fightServerId = self:GetFightServerId()
    if fightServerId~=nil then
        SFSNetwork.SendMessage(MsgDefines.GetWorldCityInfo,fightServerId)
    end
end

local function SetFightAlliancePosition(self,message)
    local serverId = message["serverId"]
    local fightServerId = self:GetFightServerId()
    local allianceId = self:GetFightAllianceId()
    if allianceId ==nil or allianceId == "" then
        return
    end
    if serverId~=nil then
        if fightServerId~=serverId then
            return
        end
    end
    local cityLv = 0
    local cityPos = nil
    if message["content"]~=nil then
        local obj =  PBController.ParsePb1(message["content"], "protobuf.WorldAllAllianceCityInfo")
        if obj~=nil then
            local list = obj["infoes"]
            if list~=nil then
                for k,v in pairs(list) do
                    local oneData = AllianceCityOccupyInfo.New()
                    oneData:ParseData(v)
                    if oneData.cityId ~= 0 and oneData.allianceId == allianceId then
                        if oneData.cityLevel > cityLv then
                            cityLv = oneData.cityLevel
                            cityPos = oneData.posV2
                        end
                    end
                end
            end
        end
    end
    if cityLv>0 and cityPos~=nil then
        local targetPos = SceneUtils.TilePosToIndex(cityPos, ForceChangeScene.World)
        local str = serverId..";"..targetPos
        EventManager:GetInstance():Broadcast(EventId.CrossServerAlliancePoint,str)
    end
end

local function GetPersonalRank(self)
    local rankList = self:GetRankList(0)-- self.rankInfoDic[0] or 
    local rankIndex = 0
    for i = 1 , #rankList do
        local data = rankList[i]
        local uid = data["uid"]
        if uid ~= nil and uid == LuaEntry.Player.uid then
            local score = data and data["score"] or 0
            if score > 0 then
                rankIndex = i
            end
            break
        end
    end
    return rankIndex
end


AllianceCompeteDataManager.__init = __init
AllianceCompeteDataManager.__delete = __delete

AllianceCompeteDataManager.RefreshWeekResultVS = RefreshWeekResultVS
AllianceCompeteDataManager.RefreshRankList = RefreshRankList
AllianceCompeteDataManager.GetVSAllianceList = GetVSAllianceList
AllianceCompeteDataManager.GetFinishTime = GetFinishTime
AllianceCompeteDataManager.GetRankList = GetRankList
AllianceCompeteDataManager.RefreshWeeklySummaryMsg = RefreshWeeklySummaryMsg
AllianceCompeteDataManager.GetWeeklySummaryList = GetWeeklySummaryList
AllianceCompeteDataManager.GetWeeklySummaryStartTime = GetWeeklySummaryStartTime
AllianceCompeteDataManager.CheckIfIsInCompete = CheckIfIsInCompete
AllianceCompeteDataManager.GetFightServerId = GetFightServerId
AllianceCompeteDataManager.GetCrossServerEndTime=GetCrossServerEndTime
AllianceCompeteDataManager.GetFightAllianceId =GetFightAllianceId
AllianceCompeteDataManager.UpdateHeroEventInfo =UpdateHeroEventInfo
AllianceCompeteDataManager.GetAlCompeteteTotalRedCount =GetAlCompeteteTotalRedCount
AllianceCompeteDataManager.GetAlCompeteActivityRedCount =GetAlCompeteActivityRedCount
AllianceCompeteDataManager.CacheOpeningTabIndex =CacheOpeningTabIndex
AllianceCompeteDataManager.GetDefaultOpenTabIndex =GetDefaultOpenTabIndex
AllianceCompeteDataManager.SetFightAlliancePosition = SetFightAlliancePosition
AllianceCompeteDataManager.RequestFightServerAllianceCity = RequestFightServerAllianceCity
AllianceCompeteDataManager.GetPersonalRank = GetPersonalRank
AllianceCompeteDataManager.GetExtraActivityList = GetExtraActivityList
return AllianceCompeteDataManager