---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/10/28 12:05
---
local WorldAllianceCityDataManager = BaseClass("WorldAllianceCityDataManager");
local AllianceCityOccupyInfo = require "DataCenter.WorldAllianceCityData.AllianceCityOccupyInfo"
local MyAlCityInfo = require "DataCenter.WorldAllianceCityData.MyAlCityInfo"

local function Startup(self)

end
local function __init(self)
    self.allAllianceCityList = {}
    self.allianceCityList = {}--key联盟，value 城点id
    self.myAlCityList = {}--我的全部联盟城池(cityID：{giveUpEndTime, durability, lastDurabilityTime}）
    self.allianceColorList = {} -- key联盟,value 颜色
    self.isFirst = false
    self.allianceCityEffectDic = {}
    self.trendsUnLockLv = {}
    self.alliancePassList = {}
    self.strongHoldList = {}
end

local function __delete(self)
    self.isFirst = nil
    self.allAllianceCityList = nil
    self.allianceCityList = nil
    self.allianceColorList = nil
    self.allianceCityEffectDic = nil
    self.trendsUnLockLv = nil
    self.alliancePassList = nil
    self.strongHoldList = nil
end


local function InitAllCityDataRequest(self)
    if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        return
    end
    self.isFirst = true
    SFSNetwork.SendMessage(MsgDefines.GetWorldCityInfo,LuaEntry.Player:GetCurServerId())
    SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityEffect)
end

local function UpdateAllCityDataRequest(self)
    self.isFirst = false
    if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        return
    end
    SFSNetwork.SendMessage(MsgDefines.GetWorldCityInfo,LuaEntry.Player:GetCurServerId())
    SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityEffect)
end
local function UpdateAllCityData(self,message)
    local serverId = message["serverId"]
    DataCenter.AllianceCompeteDataManager:SetFightAlliancePosition(message)
    if serverId~=nil then
        local curServerId = LuaEntry.Player:GetCurServerId()
        if curServerId~=serverId then
            return
        end
    end
    --local serverType = 
    if message["content"]~=nil then
        local obj =  PBController.ParsePb1(message["content"], "protobuf.WorldAllAllianceCityInfo")
        if obj~=nil then
            local list = obj["infoes"]
            if list~=nil then
                local cacheMyAlCities = {}
                if LuaEntry.Player:IsInAlliance() then
                    cacheMyAlCities = self.allianceCityList[LuaEntry.Player.allianceId] or {}
                end
                local serverType = LuaEntry.Player.serverType
                self.allAllianceCityList = {}
                self.allianceCityList = {}--key联盟，value 城点id
                self.allianceColorList = {} -- key联盟,value 颜色
                self.strongHoldList = {}
                self.alliancePassList = {}
                table.walk(list,function(k,v)
                    local oneData = AllianceCityOccupyInfo.New()
                    oneData:ParseData(v)
                    if oneData.cityId ~= 0 and oneData.allianceId~="" and oneData.color~=0 then
                        local template = DataCenter.AllianceCityTemplateManager:GetTemplate(oneData.cityId)
                        if template ~= nil then
                            if template.server_type == serverType then
                                if template.eden_city_type == WorldCityType.AllianceCity then
                                    self.allAllianceCityList[oneData.cityId] = oneData
                                    if oneData.cityId~=THRONE_ID or LuaEntry.Player.serverType ~= ServerType.NORMAL then
                                        if self.allianceCityList[oneData.allianceId]==nil then
                                            self.allianceCityList[oneData.allianceId] = {}
                                        end
                                        table.insert(self.allianceCityList[oneData.allianceId],oneData.cityId)
                                    end
                                    self.allianceColorList[oneData.allianceId] = oneData.color
                                elseif template.eden_city_type == WorldCityType.AlliancePass then
                                    self.alliancePassList[oneData.cityId] = oneData
                                    if self.allianceCityList[oneData.allianceId]==nil then
                                        self.allianceCityList[oneData.allianceId] = {}
                                    end
                                    table.insert(self.allianceCityList[oneData.allianceId],oneData.cityId)
                                elseif template.eden_city_type == WorldCityType.StrongHold then
                                    self.strongHoldList[oneData.cityId] = oneData
                                end
                                
                            end
                        end

                    end
                end)

                --检查我的联盟城池是否有变化
                local tempCities = {}
                if LuaEntry.Player:IsInAlliance() then
                    tempCities = self.allianceCityList[LuaEntry.Player.allianceId] or {}
                end
                if #tempCities ~= #cacheMyAlCities then
                    EventManager:GetInstance():Broadcast(EventId.MyAlCityListChanged)
                end

                if self.isFirst == true then
                    EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoReceived)
                else
                    EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoChanged)
                end

                if self.isFirst == true then
                    EventManager:GetInstance():Broadcast(EventId.StrongHoldOwnerInfoReceived)
                else
                    EventManager:GetInstance():Broadcast(EventId.StrongHoldOwnerInfoChanged)
                end

                if self.isFirst == true then
                    EventManager:GetInstance():Broadcast(EventId.WorldPassOwnerInfoReceived)
                else
                    EventManager:GetInstance():Broadcast(EventId.WorldPassOwnerInfoChanged)
                end
            end
        else
            if self.isFirst == true then
                EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoReceived)
                EventManager:GetInstance():Broadcast(EventId.WorldPassOwnerInfoReceived)
                EventManager:GetInstance():Broadcast(EventId.StrongHoldOwnerInfoReceived)
            end
        end
    else
        if self.isFirst == true then
            EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoReceived)
            EventManager:GetInstance():Broadcast(EventId.WorldPassOwnerInfoReceived)
            EventManager:GetInstance():Broadcast(EventId.StrongHoldOwnerInfoReceived)
        end
    end
    if message["trendsUnLockData"] then
        self.trendsUnLockLv = message["trendsUnLockData"]
    end
    DataCenter.AllianceCityTipManager:RefreshAllianceCityName()
end

local function UpdateMyAlCities(self, t)
    if not t or not t["cityInfos"] then
        return
    end
    local tempInfo = t["cityInfos"]
    self.myAlCityList = {}
    for i, v in pairs(tempInfo) do
        local oneData = MyAlCityInfo.New()
        oneData:ParseData(v)
        self.myAlCityList[oneData.cityId] = oneData
    end

    EventManager:GetInstance():Broadcast(EventId.UpdateMyAlCities)
end

local function UpdateOneGivingUpCity(self, t)
    local cityId = t["cityId"]
    if self.myAlCityList~=nil and self.myAlCityList[cityId]~=nil then
        self.myAlCityList[cityId]:SetGiveUpTime(t["giveUpTime"])
        EventManager:GetInstance():Broadcast(EventId.UpdateMyAlCities)
    end
end

local function UpdateCityName(self, t)
    local cityId = t["cityId"]
    self.myAlCityList[cityId]:SetChangeName(t["cityName"])
    self.myAlCityList[cityId]:SetChangeNameTime(t["changeNameTime"])
    EventManager:GetInstance():Broadcast(EventId.AllianceCityNameChange,cityId)
end

local function OnAlCityGiveUpFail(self, t)
    local cityId = t["cityId"]
    self.myAlCityList[cityId]:SetGiveUpTime(0)
    local name =""
    if self.myAlCityList[cityId]~=nil then
        name = self.myAlCityList[cityId].cityName
    end
    if name==nil or name== "" then
        name = GetTableData(TableName.WorldCity, cityId, 'name')
    end
    UIUtil.ShowTips(Localization:GetString("300721", name))
    EventManager:GetInstance():Broadcast(EventId.UpdateMyAlCities)
end

local function GetMyAlCityInfo(self, cityId)
    return self.myAlCityList[cityId]
end

local function GetAllianceAlreadyHaveCity(self,allianceId)
    local have = false
    table.walk(self.allAllianceCityList,function(k,v)
        if have ==false and v.allianceId == allianceId then
            have = true
        end
    end)
    if have ==false and LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
        for k,v in pairs(self.alliancePassList) do
            if have ==false and v.allianceId == allianceId then
                have = true
            end
        end
    end
    return have
end

local function GetCityIsNearBySelfAlliance(self,allianceId,curCityId)
    local canAttack = false
    local nearStr = GetTableData(TableName.WorldCity,curCityId, "nearBy")
    if nearStr~=nil and nearStr~="" then
        local nearList = string.split(nearStr,"|")
        if #nearList>0 then
            table.walk(nearList,function(k,v)
                local cityId = tonumber(v)
                if canAttack == false and  self.allAllianceCityList[cityId]~=nil then
                    local checkAllianceId =self.allAllianceCityList[cityId].allianceId
                    if checkAllianceId == allianceId then
                        canAttack = true
                    end
                    if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
                        if DataCenter.GloryManager:IsSameCampByAllianceId(checkAllianceId) ==true then
                            canAttack = true
                        end
                    end
                elseif canAttack == false and LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
                    local cityData = self.alliancePassList[cityId]
                    if cityData==nil then
                        cityData = self.strongHoldList[cityId]
                    end
                    if cityData~=nil then
                        local checkAllianceId =cityData.allianceId
                        if checkAllianceId == allianceId or DataCenter.GloryManager:IsSameCampByAllianceId(checkAllianceId) ==true then
                            canAttack = true
                        end
                    end
                end
            end)
        end
    end
    return canAttack
end


local function GetCityIsNearByAllianceDesert(self,alId,curCityId)
    local alreadyExitOccupy = true
    if SeasonUtil.IsInSeasonDesertMode() and CrossServerUtil:GetIsCrossServer()==false then
        alreadyExitOccupy = false
        local strPos = GetTableData(TableName.WorldCity, curCityId, 'location')
        local size = GetTableData(TableName.WorldCity,curCityId, "size")
        local tabPos = string.split(strPos, '|')
        if (table.count(tabPos) ~= 2) then
            return false
        end
        local vec2 = CS.UnityEngine.Vector2Int(tonumber(tabPos[1]), tonumber(tabPos[2]))
        local rangeList = BuildingUtils.GetBuildRoundPos(vec2,size)
        for i=1,#rangeList do
            if alreadyExitOccupy == false then
                local v2 = rangeList[i]
                alreadyExitOccupy = SeasonUtil.IsDesertOccupy(SceneUtils.TilePosToIndex(v2,ForceChangeScene.World))
            end
        end
    end

    return alreadyExitOccupy
end

local function GetCitiesByAlId(self, alId)
    return self.allianceCityList[alId]
end

local function GetAllianceColorList(self)
    return self.allianceColorList
end

local function GetAllianceCityList(self)
    return self.allAllianceCityList
end
local function GetAlliancePassList(self)
    return self.alliancePassList
end
local function GetAllianceCityDataByCityId(self,cityId)
    return self.allAllianceCityList[cityId]
end

local function GetAlliancePassDataByCityId(self,cityId)
    return self.alliancePassList[cityId]
end
local function GetStrongHoldDataByCityId(self,cityId)
    return self.strongHoldList[cityId]
end

local function UpdateAllianceCityEffect(self,message)
    self.allianceCityEffectDic ={}
    if message~=nil and message["effect"]~=nil then
        for k, v in pairs(message["effect"]) do
            local effectId = tonumber(k)
            local effectValue = tonumber(v)
            self.allianceCityEffectDic[effectId] = effectValue
        end
    end
end

local function GetAllianceCityEffectById(self,id)
    local effectId = id
    local num = 0
    if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        if self.allianceCityEffectDic~=nil and self.allianceCityEffectDic[effectId]~=nil then
            num = self.allianceCityEffectDic[effectId]
        end
    end

    return num
end

local function CheckIfHasAlCity(self)
    if not LuaEntry.Player:IsInAlliance() then
        return false
    end

    local myAlId = LuaEntry.Player.allianceId
    local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
    return (myAlCities~=nil and #myAlCities > 0)
end

local function CheckIfIsAlTerritory(self, pointId)
    local myAlId = LuaEntry.Player.allianceId
    local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
    if myAlCities then
        if SceneUtils.GetIsInWorld() then
            local zoneId = CS.SceneManager.World:GetZoneIdByPosId(pointId-1)
            for i, v in ipairs(myAlCities) do
                if v == zoneId then
                    return true
                end
            end
        end
    end
    return false
end

local function GetMyAllianceCityLevelNum(self,level)
    local num = 0
    local myAlId = LuaEntry.Player.allianceId
    local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
    if myAlCities then
        for k,v in pairs(myAlCities) do
            local template =  DataCenter.AllianceCityTemplateManager:GetTemplate(v)
            if template ~= nil and template.level == level then
                num = num+1
            end
        end
    end
    return num
end

--获取联盟占领的城市数量
function WorldAllianceCityDataManager:GetAlCityCount()
    local result = 0
    local myAlId = LuaEntry.Player.allianceId
    local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
    if myAlCities ~= nil then
        result = #myAlCities
    end
    return result
end

--获取联盟占领大于等于level等级的城市数量
function WorldAllianceCityDataManager:GetMyAllianceCityNumByOutLevel(level)
    local num = 0
    local myAlId = LuaEntry.Player.allianceId
    local myAlCities = self:GetCitiesByAlId(myAlId)
    if myAlCities ~= nil then
        for k,v in pairs(myAlCities) do
            local template =  DataCenter.AllianceCityTemplateManager:GetTemplate(v)
            if template.level >= level then
                num = num+1
            end
        end
    end
    return num
end

WorldAllianceCityDataManager.__init = __init
WorldAllianceCityDataManager.__delete = __delete
WorldAllianceCityDataManager.GetCityIsNearBySelfAlliance = GetCityIsNearBySelfAlliance
WorldAllianceCityDataManager.GetAllianceAlreadyHaveCity =GetAllianceAlreadyHaveCity
WorldAllianceCityDataManager.UpdateAllCityData =UpdateAllCityData
WorldAllianceCityDataManager.Startup = Startup
WorldAllianceCityDataManager.GetAllianceCityList = GetAllianceCityList
WorldAllianceCityDataManager.GetAllianceColorList= GetAllianceColorList
WorldAllianceCityDataManager.InitAllCityDataRequest = InitAllCityDataRequest
WorldAllianceCityDataManager.UpdateAllCityDataRequest =UpdateAllCityDataRequest
WorldAllianceCityDataManager.GetAllianceCityDataByCityId = GetAllianceCityDataByCityId
WorldAllianceCityDataManager.UpdateMyAlCities = UpdateMyAlCities
WorldAllianceCityDataManager.GetMyAlCityInfo = GetMyAlCityInfo
WorldAllianceCityDataManager.GetCitiesByAlId = GetCitiesByAlId
WorldAllianceCityDataManager.UpdateOneGivingUpCity = UpdateOneGivingUpCity
WorldAllianceCityDataManager.OnAlCityGiveUpFail = OnAlCityGiveUpFail
WorldAllianceCityDataManager.UpdateAllianceCityEffect =UpdateAllianceCityEffect
WorldAllianceCityDataManager.GetAllianceCityEffectById =GetAllianceCityEffectById
WorldAllianceCityDataManager.UpdateCityName = UpdateCityName
WorldAllianceCityDataManager.CheckIfHasAlCity = CheckIfHasAlCity
WorldAllianceCityDataManager.CheckIfIsAlTerritory = CheckIfIsAlTerritory
WorldAllianceCityDataManager.GetCityIsNearByAllianceDesert = GetCityIsNearByAllianceDesert
WorldAllianceCityDataManager.GetMyAllianceCityLevelNum = GetMyAllianceCityLevelNum
WorldAllianceCityDataManager.GetAlliancePassDataByCityId =GetAlliancePassDataByCityId
WorldAllianceCityDataManager.GetStrongHoldDataByCityId = GetStrongHoldDataByCityId
WorldAllianceCityDataManager.GetAlliancePassList = GetAlliancePassList
return WorldAllianceCityDataManager