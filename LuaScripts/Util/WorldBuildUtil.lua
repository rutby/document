---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/10/26 21:43
---
local WorldBuildUtil = {}
local Localization = CS.GameEntry.Localization
local Const = require"Scene.WorldTroopManager.Const"
local function GetBuildAllianceId(pointId)
    local allianceId = ""
    local info = DataCenter.WorldPointManager:GetPointInfo(pointId)
    if info ~= nil then
        if info~=nil then
            if info.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
                local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
                if allianceCityPointInfo~=nil then
                    allianceId =allianceCityPointInfo["allianceId"]
                end
            end
        end 
    end
    return allianceId
end
local function GetBuildTile(pointId)
    local size = 1
    if CommonUtil.IsUseLuaWorldPoint() then
        local info = DataCenter.WorldPointManager:GetPointInfo(pointId)
        if info~=nil then
            if info.pointType == WorldPointType.PlayerBuilding then
                if info.buildInfo~=nil then
                    local buildId = info.buildInfo.buildId
                    local buildDesTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
                    if buildDesTemplate ~= nil then
                        size = buildDesTemplate.tiles
                    end
                end
            elseif info.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
                local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
                if allianceCityPointInfo~=nil then
                    local cityId = allianceCityPointInfo["cityId"]
                    size = GetTableData(TableName.WorldCity,cityId, "size")
                end
            elseif info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
                local allianceBuildPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
                if allianceBuildPointInfo~=nil then
                    local mineID = allianceBuildPointInfo["buildId"]
                    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(mineID)
                    if template~=nil then
                        size = template.resSize
                    end
                end
            elseif info.PointType == WorldPointType.DRAGON_BUILDING then
                local dragonBuildingPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
                if dragonBuildingPointInfo then
                    local id = dragonBuildingPointInfo["buildId"]
                    local template = DataCenter.DragonBuildTemplateManager:GetTemplate(id)
                    if template then
                        return template.size
                    end
                end
            end
        end
    else
        local info = DataCenter.WorldPointManager:GetPointInfo(pointId)
        if info ~= nil then
            if info~=nil then
                if info.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
                    local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
                    if allianceCityPointInfo~=nil then
                        local cityId = allianceCityPointInfo["cityId"]
                        size = GetTableData(TableName.WorldCity,cityId, "size")
                    end
                elseif info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
                    local allianceBuildPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
                    if allianceBuildPointInfo~=nil then
                        local mineID = allianceBuildPointInfo["buildId"]
                        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(mineID)
                        if template~=nil then
                            size = template.resSize
                        end

                    end
                elseif info.PointType == WorldPointType.DRAGON_BUILDING then
                    local dragonBuildingPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
                    if dragonBuildingPointInfo then
                        local id = dragonBuildingPointInfo["buildId"]
                        local template = DataCenter.DragonBuildTemplateManager:GetTemplate(id)
                        if template then
                            return template.size
                        end
                    end
                end
            end
        end
    end
    
    return size
end

local function GetPlayerType(info)
    local playerType = PlayerType.PlayerNone
    if CommonUtil.IsUseLuaWorldPoint() then
        if info~=nil then
            if info.pointType == WorldPointType.PlayerBuilding then
                if info.buildInfo~=nil then
                    if info.buildInfo.ownerUid == LuaEntry.Player.uid then
                        return PlayerType.PlayerSelf
                    end
                    if not LuaEntry.Player:IsInAlliance() then
                        return PlayerType.PlayerOther
                    end
                    if info.buildInfo.allianceId == LuaEntry.Player.allianceId then
                        local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
                        local leaderUid = allianceBaseData and allianceBaseData.leaderUid or ""
                        if info.buildInfo.ownerUid == leaderUid then
                            return PlayerType.PlayerAllianceLeader
                        else
                            return PlayerType.PlayerAlliance
                        end
                    end
                    return PlayerType.PlayerOther
                end
            elseif info.PointType == WorldPointType.WORLD_ALLIANCE_BUILD then
                if not LuaEntry.Player:IsInAlliance() then
                    return PlayerType.PlayerOther
                end
                local allianceBuildPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
                if allianceBuildPointInfo~=nil then
                    if allianceBuildPointInfo.allianceId == LuaEntry.Player.allianceId then
                        return PlayerType.PlayerAlliance
                    end
                end
                return PlayerType.PlayerOther
            elseif info.PointType == WorldPointType.DRAGON_BUILDING then
                if not LuaEntry.Player:IsInAlliance() then
                    return PlayerType.PlayerOther
                end
                local dragonBuildingPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
                if dragonBuildingPointInfo~=nil then
                    if dragonBuildingPointInfo.allianceId == LuaEntry.Player.allianceId then
                        return PlayerType.PlayerAlliance
                    end
                end
                return PlayerType.PlayerOther
            end
        end
    end
    return playerType
end
local function GetWorldPointModelPath(info)
    local path = ""
    if info~=nil then
        local pointType = info.PointType
        if CommonUtil.IsUseLuaWorldPoint() then
            pointType = info.PointType
        end
        if pointType == WorldPointType.WORLD_ALLIANCE_CITY then
            local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
            if allianceCityPointInfo~=nil then
                local cityId = allianceCityPointInfo["cityId"]
                local model = GetTableData(TableName.WorldCity,cityId, "model")
                local extraStr = ""
                if SeasonUtil.IsInSeasonDesertMode() and (cityId~=THRONE_ID or LuaEntry.Player.serverType ~= ServerType.NORMAL) then
                    local cityAllianceId = allianceCityPointInfo["allianceId"]
                    local allianceUid = LuaEntry.Player.allianceId
                    if allianceUid~=nil and allianceUid~="" then
                        if cityAllianceId == allianceUid then
                            extraStr = "_alliance"
                        else
                            if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
                                if cityAllianceId~=nil and cityAllianceId~="" then
                                    if DataCenter.GloryManager:IsSameCampByAllianceId(cityAllianceId) ==true then
                                        extraStr = "_yellow"
                                    else
                                        extraStr = "_other"
                                    end
                                else
                                    extraStr = "_white"
                                end

                            elseif cityAllianceId~=nil and cityAllianceId~="" then
                                if LuaEntry.Player:GetSelfServerId() ~=info.srcServerId then
                                    extraStr = "_other"
                                elseif DataCenter.GloryManager:GetIsFightServer(info.srcServerId) == true then
                                    extraStr = "_other"
                                else
                                    local fightAllianceId = DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
                                    if fightAllianceId~=nil and fightAllianceId~="" and fightAllianceId == cityAllianceId then
                                        extraStr = "_other"
                                    else
                                        extraStr = "_white"
                                    end
                                end
                            end
                        end
                    end
                end
                path = "Assets/Main/Prefab_Dir/AllianceCity/"..model..extraStr..".prefab"
            end
        elseif pointType == WorldPointType.WORLD_ALLIANCE_BUILD then
            local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
            if detailInfo then
                local buildId = detailInfo.buildId
                local model = ""
                local extraStr = ""
                local state = detailInfo.state

                local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(detailInfo.buildId)
                if template~=nil then
                    if state == AllianceMineStatus.Ruin and WorldAllianceBuildUtil.IsAllianceActMineGroup(buildId) ==false then
                        model = "Assets/Main/Prefabs/AllianceBuilding/allianceBuilding_ruin"
                    else
                        model = template:GetModelPath()
                    end

                    if buildId == BuildingTypes.ALLIANCE_FLAG_BUILD or WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) or WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId) then
                        local cityAllianceId = detailInfo["allianceId"]
                        local allianceUid = LuaEntry.Player.allianceId
                        if allianceUid~=nil and allianceUid~="" then
                            if cityAllianceId == allianceUid then
                                extraStr = "_alliance"
                            else
                                if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
                                    if DataCenter.GloryManager:IsSameCampByAllianceId(cityAllianceId) ==true then
                                        extraStr = "_yellow"
                                    else
                                        extraStr = "_other"
                                    end
                                elseif cityAllianceId~=nil and cityAllianceId~="" then
                                    if LuaEntry.Player:GetSelfServerId() ~=info.srcServerId then
                                        extraStr = "_other"
                                    elseif DataCenter.GloryManager:GetIsFightServer(info.srcServerId) == true then
                                        extraStr = "_other"
                                    else
                                        local fightAllianceId = DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
                                        if fightAllianceId~=nil and fightAllianceId~="" and fightAllianceId == cityAllianceId then
                                            extraStr = "_other"
                                        else
                                            extraStr = "_white"
                                        end
                                    end
                                end
                            end
                        else
                            if LuaEntry.Player:GetSelfServerId() ~=info.srcServerId then
                                extraStr = "_other"
                            else
                                extraStr = "_white"
                            end
                        end
                    end
                end
                path = model..extraStr..".prefab"

            end
        elseif pointType == WorldPointType.MONSTER_REWARD then
            path = "Assets/Main/Prefabs/World/MonsterReward.prefab"
        elseif pointType == WorldPointType.SECRET_KEY then
            path = "Assets/Main/Prefab_Dir/DragonBuilding/SecretKey.prefab"
        elseif pointType == WorldPointType.WorldRuinPoint then
            path = "Assets/Main/Prefabs/World/RuinFireEffect.prefab"
        elseif pointType == WorldPointType.DRAGON_BUILDING then
            local dragonBuildingPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
            if dragonBuildingPointInfo then
                local id = dragonBuildingPointInfo["buildId"]
                local template = DataCenter.DragonBuildTemplateManager:GetTemplate(id)
                if template then
                    return template:GetModelPath()
                end
            end
        elseif pointType == WorldPointType.WorldMonster then
            local monsterPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.WorldPointMonster")
            if monsterPointInfo then
                local type = monsterPointInfo.type
                if type == NewMarchType.MONSTER
                        or type == NewMarchType.BOSS
                        or type == NewMarchType.CHALLENGE_BOSS
                        or type == NewMarchType.MONSTER_SIEGE then
                    local model_name = DataCenter.MonsterTemplateManager:GetTableValue(monsterPointInfo.monsterId, "model_name")
                    return "Assets/Main/Prefabs/Monsters/"..model_name..".prefab"
                elseif type == NewMarchType.ACT_BOSS then
                    return Const.MonsterActBoss
                elseif type == NewMarchType.PUZZLE_BOSS then
                    return Const.MonsterActBoss
                elseif type == NewMarchType.ALLIANCE_BOSS then
                    return Const.AllianceBossModel
                end
            end
        end
    end
    
    return path
end

local function GetDragonBuildLodIcon(info)
    local path = ""
    local extraStr = ""
    local scale = 1
    if info~=nil then
        local pointType = info.PointType
        if CommonUtil.IsUseLuaWorldPoint() then
            pointType = info.PointType
        end
        if pointType == WorldPointType.DRAGON_BUILDING then
            local dragonBuildingPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
            if dragonBuildingPointInfo then
                local id = dragonBuildingPointInfo["buildId"]
                local cityAllianceId = dragonBuildingPointInfo["allianceId"]
                local allianceUid = LuaEntry.Player.allianceId
                if id == DragonBuildingTypes.DragonCenterBuild then
                    path = "Assets/Main/Sprites/LodIcon/UIbattlefield_img_10020"
                    extraStr = ""
                    scale = 2
                else
                    local side = DataCenter.ActDragonManager:GetSelfSide()
                    if (id == DragonBuildingTypes.DragonAllianceFlagSelf and side ==0) or (id == DragonBuildingTypes.DragonAllianceFlagOther and side ==1) then
                        path = "Assets/Main/Sprites/LodIcon/UIbattlefield_img_self"
                        scale = 1.5
                    elseif (id == DragonBuildingTypes.DragonAllianceFlagSelf and side ==1) or (id == DragonBuildingTypes.DragonAllianceFlagOther and side ==0) then
                        path = "Assets/Main/Sprites/LodIcon/UIbattlefield_img_other"
                        scale = 1.5
                    else
                        if allianceUid~=nil and allianceUid~="" then
                            if cityAllianceId == allianceUid then
                                extraStr = "_self"
                            elseif cityAllianceId~=nil and cityAllianceId~="" then
                                extraStr = "_other"
                            else
                                extraStr = "_none"
                            end
                        end
                        if id == DragonBuildingTypes.DragonWarBuild then
                            scale = 1.5
                        else
                            scale = 1
                        end
                        path = "Assets/Main/Sprites/LodIcon/UIbattlefield_img_"..id
                    end
                end
                
            end
        elseif pointType == WorldPointType.SECRET_KEY then
            path = "Assets/Main/Sprites/LodIcon/UIbattlefield_img_white01"
        end
    end
    return (path..extraStr) ,scale
end

local function GetDragonBuildName(info)
    local name = ""
    if info~=nil then
        local pointType = info.PointType
        if CommonUtil.IsUseLuaWorldPoint() then
            pointType = info.PointType
        end
        if pointType == WorldPointType.DRAGON_BUILDING then
            local dragonBuildingPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.DragonBuildingPointInfo")
            if dragonBuildingPointInfo then
                local id = dragonBuildingPointInfo["buildId"]
                local abbr = dragonBuildingPointInfo["alAbbr"]
                local template = DataCenter.DragonBuildTemplateManager:GetTemplate(id)
                if template then
                    name = Localization:GetString(template.name)
                end
                if abbr~=nil and abbr~="" then
                    name = "["..abbr.."]"..name
                end
            end
        elseif pointType == WorldPointType.SECRET_KEY then
            name = Localization:GetString("376090")
        end
    end
    return name
end
local function GetAllianceCitySimpleDataByPointInfo(info)
    if info~=nil then
        local pointType = info.PointType
        if CommonUtil.IsUseLuaWorldPoint() then
            pointType = info.PointType
        end
        if pointType == WorldPointType.WORLD_ALLIANCE_CITY then
            local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
            if allianceCityPointInfo~=nil then
                local cityId = allianceCityPointInfo["cityId"]
                return DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId)
            end
        end
    end
end
local function GetAllianceCityIdByPointInfo(info)
    if info~=nil then
        local pointType = info.PointType
        if CommonUtil.IsUseLuaWorldPoint() then
            pointType = info.PointType
        end
        if info.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
            local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
            if allianceCityPointInfo~=nil then
                local cityId = allianceCityPointInfo["cityId"]
                return cityId
            end
        end
    end
end


local function IsCollectRangePoint(pointIndex)
    return false
end
local function GetCollectRangePoint(pointIndex,resourceType)
end

local function GetBornPointXY(param)
    local diff = LuaEntry.DataConfig:TryGetNum("gen_born_point_param","k1")
    local space = LuaEntry.DataConfig:TryGetNum("gen_born_point_param","k3")
    local bornAreaBornParam1 = (space/2)+diff
    local bornAreaBornParam2 =  space
    local bornAreaBornParam3 = diff
    --local temA = math.floor(param/500)
    --local temB = math.ceil((param%500-bornAreaBornParam1)/bornAreaBornParam2)
    --local realParam = temA*500+(bornAreaBornParam2*temB)+bornAreaBornParam3
    --return realParam
    if param-bornAreaBornParam1<=0 then
        return bornAreaBornParam3
    else
        local pos = math.ceil((param-bornAreaBornParam1)/bornAreaBornParam2)*bornAreaBornParam2+bornAreaBornParam3
        return math.floor(pos)
    end
end

local function GetBornPointByRealPoint(pointId)
    local xy = SceneUtils.IndexToTilePos(pointId)
    local bornX = WorldBuildUtil.GetBornPointXY(xy.x)
    local bornY = WorldBuildUtil.GetBornPointXY(xy.y)
    local item = {}
    item.x = bornX
    item.y = bornY
    local realPointId = SceneUtils.TilePosToIndex(item)
    return realPointId
end

local function CheckIsInBasementRange(pointId)
    local isIn = false
    local cityPoint = WorldBuildUtil.GetBornPointByRealPoint(pointId)
    local city = DataCenter.WorldPointManager:GetBuildDataByPointIndex(cityPoint)
    if city~=nil and city.itemId == BuildingTypes.FUN_BUILD_MAIN then
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(city.itemId,city.level)
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(city.itemId)
        if levelTemplate~=nil and template~=nil then
            if BuildingUtils.IsInRangeByCircle(cityPoint,pointId,levelTemplate.offer_range, template.tiles)== true then
                isIn = true
            end
        end
    end
    if isIn==true then
        return cityPoint
    else
        return 0
    end
end

local function SetFightAllianceId()
    local allianceId = DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
    if CS.GameEntry.Data.Player.SetFightAllianceId~=nil then
        CS.GameEntry.Data.Player:SetFightAllianceId(allianceId)
    end
end
local function SetFightServerList()
    local list = {}
    local opponentData = DataCenter.GloryManager:GetOpponentData()
    if opponentData~=nil then
        local serverId = opponentData.serverId
        if serverId~=nil and serverId>0 then
            table.insert(list,serverId)
        end
    end
    if CS.GameEntry.Data.Player.SetFightServerList~=nil then
        CS.GameEntry.Data.Player:SetFightServerList(list)
    end
end

local function SetAttackInfoList()
    local list = {}
    local dic = DataCenter.WorldNewsDataManager:GetAllAttackerData()
    if dic~=nil then
        for k,v in pairs(dic) do
            if v.uid~=nil and v.uid~="" and v.expireTime~=nil and v.expireTime>0 then
                local oneData = {}
                oneData.uid = v.uid
                oneData.endTime = v.expireTime
                table.insert(list,oneData)
            end
        end
    end
    if CS.GameEntry.Data.Player.SetAttackInfoList~=nil then
        CS.GameEntry.Data.Player:SetAttackInfoList(list)
    end
end

WorldBuildUtil.GetBuildAllianceId =GetBuildAllianceId
WorldBuildUtil.GetBuildTile = GetBuildTile
WorldBuildUtil.GetWorldPointModelPath = GetWorldPointModelPath
WorldBuildUtil.GetAllianceCitySimpleDataByPointInfo = GetAllianceCitySimpleDataByPointInfo
WorldBuildUtil.GetAllianceCityIdByPointInfo = GetAllianceCityIdByPointInfo
WorldBuildUtil.IsCollectRangePoint= IsCollectRangePoint
WorldBuildUtil.GetCollectRangePoint =GetCollectRangePoint
WorldBuildUtil.GetBornPointXY =GetBornPointXY
WorldBuildUtil.GetBornPointByRealPoint =GetBornPointByRealPoint
WorldBuildUtil.CheckIsInBasementRange =CheckIsInBasementRange
WorldBuildUtil.SetAttackInfoList = SetAttackInfoList
WorldBuildUtil.SetFightServerList =SetFightServerList
WorldBuildUtil.SetFightAllianceId = SetFightAllianceId
WorldBuildUtil.GetDragonBuildLodIcon =GetDragonBuildLodIcon
WorldBuildUtil.GetDragonBuildName = GetDragonBuildName
WorldBuildUtil.GetPlayerType =GetPlayerType
return ConstClass("WorldBuildUtil", WorldBuildUtil)