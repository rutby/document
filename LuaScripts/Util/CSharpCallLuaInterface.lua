---统一使用 CSharpCallLuaInterface 实现c# call lua 功能
local CSharpCallLuaInterface = {}

local function GetLuaStringTable()
    return {}
    --return StringLUT
end

local function IsUseLoadAsync()
    return CommonUtil.GetIsUseLoadAsync()
end

local function IsUseLuaLoading()
    return true
end

local function IsUseLuaWorldPoint()
    CommonUtil.SetIsUseLuaWorldPoint(true)
    return CommonUtil.IsUseLuaWorldPoint()
end


----[[
---读配置表
---]]
local function GetDataTableCount(xmlName)
   return LocalController:instance():GetTableLength(xmlName)
end

local function GetTemplateData(_type, itemId, name)
    --这里是C#读表接口，先判断AB测
    if LuaEntry.Player ~= nil then
        _type = LuaEntry.Player:GetABTestTableName(_type)
    end
   return LocalController:instance():getStrValue(_type, itemId, name)
end

----[[
----世界点信息
---]]
local function GetWorldPointTileSize(pointId)
   return WorldBuildUtil.GetBuildTile(pointId)
end

local function GetAllianceColorList()
   return DataCenter.WorldAllianceCityDataManager:GetAllianceColorList()
end

local function GetAllianceCityList()
   return DataCenter.WorldAllianceCityDataManager:GetAllianceCityList()
end

local function GetAllianceCitySimpleDataByPointInfo(pointInfo)
   return WorldBuildUtil.GetAllianceCitySimpleDataByPointInfo(pointInfo)
end
local function GetWorldPointModelPath(pointInfo)
   return WorldBuildUtil.GetWorldPointModelPath(pointInfo)
end
local function GetDragonBuildLodIcon(pointInfo)
    return WorldBuildUtil.GetDragonBuildLodIcon(pointInfo)
end
local function GetDragonBuildName(pointInfo)
    return WorldBuildUtil.GetDragonBuildName(pointInfo)
end
----[[
----道路信息
---]]

local function GetAllianceCityIdByPointInfo(pointInfo)
   return WorldBuildUtil.GetAllianceCityIdByPointInfo(pointInfo)
end

----[[
----dataConfig
---]]
local function CheckSwitch(key)
   return LuaEntry.DataConfig:CheckSwitch(key)
end

local function GetIsAllianceCityOpen()
   -- 临时：打包版不开启
   --if not CS.CommonUtils.IsDebug() then
   --   return false
   --end
   return true
end
local function GetConfigNum(key1,key2)
   return LuaEntry.DataConfig:TryGetNum(key1,key2)
end
local function GetConfigStr(key1,key2)
   return LuaEntry.DataConfig:TryGetStr(key1,key2)
end

----[[
----建筑
---]]
local function GetTrainingTypeAndBuildingType(buildId)
   return BuildingUtils.GetTrainingTypeAndBuildingType(buildId)
end

local function GetMainPos()
    local pos = BuildingUtils.GetMainPos()
   return CS.UnityEngine.Vector2Int(pos.x, pos.y)
end

local function SetMainPos()
   
end

local function GetBuildTileIndex(buildId,index)
   return BuildingUtils.GetBuildTileIndex(buildId,index)
end

local function GetAllianceBuildTileIndex(buildId,index)
    return WorldAllianceBuildUtil.GetBuildTileIndex(buildId,index)
end
local function IsCanPutDownByBuild(buildId,index,buildUuid,noPutPoint)
    return BuildingUtils.IsCanPutDownByBuild(buildId,index,buildUuid,noPutPoint)
end

local function IsCanPutDownByAllianceBuild(buildId,index)
    return WorldAllianceBuildUtil.IsCanPutDownByAllianceBuild(buildId,index)
end
local function IsCanShowCollectGreenByPoint(index)
    return BuildingUtils.IsCanShowCollectGreenByPoint(index)
end

local function IsInMyBaseInsideRange(point)
    return BuildingUtils.IsInMyBaseInsideRange(point)
end

local function GetOutermostIndexByIndex(index,radius,maxX,maxY)
    return BuildingUtils.GetOutermostIndexByIndex(index,radius,maxX,maxY)
end

local function GetBuildModelCenter(mainIndex,tile)
    return BuildingUtils.GetBuildModelCenter(mainIndex,tile)
end
local function GetBuildModelCenterVec(mainIndex,tile)
    return BuildingUtils.GetBuildModelCenterVec(mainIndex,tile)
end

local function GetBuildMainVecByModelCenter(centerIndex,tile)
    return BuildingUtils.GetBuildMainVecByModelCenter(centerIndex,tile)
end
local function GetCollectMaxEffectByBuildId(buildId)
    return DataCenter.BuildManager:GetCollectMaxEffectByBuildId(buildId)
end

local function GetDirByPos(lastPos,curPos,nextPos)--获取模型显示方向
   local openDir,flowDir = CommonUtil.GetDirByPos(lastPos,curPos,nextPos)
   return openDir
end

local function SendFindMainBuildInitPositionMessage()
   SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
end

local function GetMainLv()
    return DataCenter.BuildManager.MainLv
end

local function CheckReplaceMain()
    DataCenter.BuildManager:CheckReplaceMain()
end

local function UpdateBuildings(message)
    DataCenter.BuildManager:UpdateBuildings(message["building_new"])
end

local function GetAllLuaBuildWithoutFoldUp(list)
    local all = DataCenter.BuildCityBuildManager:GetAllData()
    for k, v in pairs(all) do
        if v.state == BuildCityBuildState.Fake or v.state == BuildCityBuildState.Pre then
            list:Add(CS.LuaBuildData(0, 0, v.pointId, BuildingStateType.Normal, v.buildId, 0, 0))
        elseif v.state == BuildCityBuildState.Own then
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v.buildId)
            if buildData ~= nil then
                list:Add(CS.LuaBuildData(buildData.uuid,buildData.updateTime,buildData.pointId,buildData.state,buildData.itemId,buildData.level,0))
            end
        end
    end
    return list
end

local function GetBuildingDataByUuid(uuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
        return CS.LuaBuildData(buildData.uuid,buildData.updateTime,buildData.pointId,buildData.state,buildData.itemId,buildData.level,0)
    end
end

local function GetBuildingDataParamByUuid(uuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
	if buildData ~= nil then
		return buildData.uuid,buildData.updateTime,buildData.pointId,buildData.state,buildData.itemId,buildData.level,0
	end
end

local function GetBuildingDataByBuildId(buildId)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
    if buildData ~= nil then
        return CS.LuaBuildData(buildData.uuid,buildData.updateTime,buildData.pointId,buildData.state,buildData.itemId,buildData.level,0)
    else
        local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        if template ~= nil then
            return CS.LuaBuildData(0, 0, template:GetPosIndex(), BuildingStateType.Normal, template.id, 0, 0)
        end
    end
end

local function GetBuildingDataByPointId(pointId)
    local info = DataCenter.BuildCityBuildManager:GetCityBuildDataByPoint(pointId)
    if info ~= nil then
        if info.state == BuildCityBuildState.Fake then
            local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.buildId)
            if template ~= nil then
                local buildData = DataCenter.BuildManager:GetFunbuildByItemID(info.buildId)
                if buildData ~= nil then
                    return CS.LuaBuildData(buildData.uuid,buildData.updateTime, template:GetPosIndex(), BuildingStateType.Normal, template.id, 0, 0)
                else
                    return CS.LuaBuildData(0, 0, template:GetPosIndex(), BuildingStateType.Normal, template.id, 0, 0)
                end
                
            end
        elseif info.state == BuildCityBuildState.Own then
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(info.buildId)
            if buildData ~= nil then
                return CS.LuaBuildData(buildData.uuid,buildData.updateTime,buildData.pointId,buildData.state,buildData.itemId,buildData.level,0)
            end
        end
    end
    
end

local function GetBuildingDataParamByBuildId(buildId)
	local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
	if buildData ~= nil then
		return buildData.uuid,buildData.updateTime,buildData.pointId,buildData.state,buildData.itemId,buildData.level,0
	end
end

local function GetAllInBaseTruckShowBuild(list)
    local buildList = DataCenter.BuildManager:GetAllInBaseTruckShowBuild()
    if buildList ~= nil then
        for k,v in ipairs(buildList) do
            list:Add(CS.LuaBuildData(v.uuid,v.updateTime,v.pointId,v.state,v.itemId,v.level,v.connect))
        end
    end
    return list
end

local function IsInNewUserWorld()
    return DataCenter.BuildManager:IsInNewUserWorld()
end

local function GetBuildDataResourcePercent(uuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
        return buildData:GetResourcePercent()
    end
    return 0
end

local function GetBuildStartTimeAndEndTime(uuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
        local result = {}
        result.startTime = buildData.startTime
        result.endTime = buildData.updateTime
        return result
    end
end

local function IsBuildWork(uuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if buildData ~= nil then
        local now = UITimeManager:GetInstance():GetServerTime()
        return buildData.unavailableTime == 0 and now < buildData.produceEndTime
    end
    return false
end

local function GetBuildQueueState(uuid)
    return DataCenter.BuildManager:GetBuildQueueState(uuid)
end

----[[
----资源
---]]
local function GetResourceNameByType(resourceType)
   return CommonUtil.GetResourceNameByType(resourceType)
end

local function SetIsInCity(value)
    SceneUtils.SetIsInCity(value)
end

local function CheckIsInBuildRange(Ax,Ay,Bx,By,tile)
   return BuildingUtils.CheckIsInBuildRange(Ax,Ay,Bx,By,tile)
end

local function IsCollectRangePoint(pointIndex)
    return WorldBuildUtil.IsCollectRangePoint(pointIndex)
end
local function GetCollectRangePoint(pointIndex,resourceType)
    return WorldBuildUtil.GetCollectRangePoint(pointIndex,resourceType)
end

local function OnPointDownMarch(marchUuid)
    UIUtil.OnPointDownMarch(marchUuid)
end

local function OnPointUpMarch(marchUuid)
    UIUtil.OnPointUpMarch(marchUuid)
end

local function OnBeginDragMarch(marchUuid)
    UIUtil.OnMarchDragStart(marchUuid)
end
local function GetResourcePercent(buildId,buildLv,endTime,startTime)
    return BuildingUtils.GetResourcePercent(buildId,buildLv,endTime,startTime)
end
local function GetBuildCollectSpeed(buildId,level)
    local max = 0
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
    if buildLevelTemplate ~= nil then
        max = buildLevelTemplate:GetCollectSpeed()
    end
    return max
end
local function GetBuildCollectMaxSelf(buildId,level)
    local max = 0
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
    if buildLevelTemplate ~= nil then
        max = buildLevelTemplate:GetCollectMax()
    end
    return max
end
local function GetBuildCollectMaxOther(buildId,level)
    local max = 0
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
    if buildLevelTemplate ~= nil then
        max = buildLevelTemplate:GetCollectMaxOthers()
    end
    return max
end

local function GetShowBubblePercent(buildId,level)
    local percent = 0
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
    if buildLevelTemplate ~= nil then
        percent = buildLevelTemplate:GetShowBubblePercent()
    end
    return percent
end

local function GetNextChangeTimeByResourceUuid(uuid, percent)
    local data = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    if data ~= nil then
        return data:GetNextChangeTimeByPercent(percent)
    end
    return 0
end

local function GetAllBuildTileByItemId()
    return DataCenter.BuildTemplateManager:GetAllBuildTileByItemId()
end

local function GetLodArray()
    return LodArray
end

local function GetCityLodArray()
    return CityLodArray
end

--是否可以移动建筑
local function IsCanShowBuildBtn()
    return BuildingUtils.CanMoveBuild()
end
--是否可以移动建筑
local function CanMoveBuild(buildId)
    return BuildingUtils.CanMoveBuild(buildId)
end

local function CheckIsInBasementRange(pointId)
    return WorldBuildUtil.CheckIsInBasementRange(pointId)
end

local function GetConfigMd5()
    return LuaEntry.DataConfig:GetMd5()
end

local function IsShowBuildFlyPath()
    return DataCenter.BuildManager:IsShowBuildFlyPath()
end

local function SetGuideGarbageCollectTime(startTime, endTime)
    DataCenter.PickGarbageDataManager:SetTime(startTime, endTime)
end

local function AddGuideGarbageCollectToQueue(pointId)
    DataCenter.PickGarbageDataManager:AddIndexToGarbageQueue(pointId)
end

local function RemoveFromGarbageQueue(pointId)
    DataCenter.PickGarbageDataManager:RemoveFromGarbageQueue(pointId)
end

local function GetCurrentGarbageQueue()
    return DataCenter.PickGarbageDataManager:GetCurrentPickIndex()
end

-- 获取盟主uid
local function GetAllianceLeaderUid()
    local allianceBaseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    return allianceBaseData and allianceBaseData.leaderUid or ""
end

local function IsShowPrologue()
    local flag = DataCenter.GuideManager:IsShowPrologue()
	return flag
end

-- 加载场景结束之后，做一个遍历处理
local function OnLoadSceneOK(sceneNode, sceneName)
    local list = {}
	local garbageRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Interactive")
	if garbageRoot then
        local nodeNames = {'rock', 'crystal', 'cactus', 'water', 'wood'}
        for _, nodeName in pairs(nodeNames) do
            local nodeRoot = garbageRoot:Find(nodeName)
            if nodeRoot ~= nil then
                local childCount = nodeRoot.childCount
                for i = 0, childCount - 1 do
                    local child = nodeRoot:GetChild(i).gameObject
                    local instanceId = child:GetInstanceID()
                    local build = CS.SceneManager.World:AddObjectByPointId(instanceId, 20)
                    build._luaTable:BindGameObject(instanceId, child)
                end
            end
        end
        table.insert(list,garbageRoot)
	end
    local mountainRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Mountain")
    if mountainRoot then
        table.insert(list,mountainRoot)
    end
    local plantRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Plant")
    if plantRoot then
        table.insert(list,plantRoot)
    end
    local groundRoot = sceneNode.gameObject.transform:Find("Scene_City_Dig(Clone)/Ground")
    if groundRoot then
        table.insert(list,groundRoot)
    end
    DataCenter.GuideCityManager:SetCityRoot(list)
end

local function OnUploadPicStart()
    LuaEntry.Player:UploadPicStart()
end

local function GetPlayerPic()
    return LuaEntry.Player:GetPic()
end
local function GetPlayerPicVer()
    return LuaEntry.Player:GetPicVer()
end

local function GetHeroQuality(rarity,reachMax)
    local isReachMax = reachMax
    if isReachMax~=nil and isReachMax == true then
        if rarity ~= HeroUtils.RarityType.S then
            isReachMax = false
        end
    else
        isReachMax = false
    end
    return HeroUtils.GetCircleQualityIconPath(rarity,isReachMax)
end

local function GetHeroIcon(heroId)
    return HeroUtils.GetHeroIconRoundPath(heroId)
end

local function GetMarchStateIcon(marchInfo)
    return MarchUtil.GetMarchStateIconByType(marchInfo)
end

local function GetBuffPerformanceInfo(buffId)
    return DataCenter.StatusManager:GetBuffPerformanceInfo(buffId)
end

local function CanShowCityLabel()
    return DataCenter.BuildManager.showCityLabel == true
end
--是否显示世界垃圾点
local function IsShowWorldCollectPoint()
    return DataCenter.GuideManager:IsShowWorldCollectPoint()
end
local function SendErrorMessageToServer(errorMsg)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    CommonUtil.SendErrorMessageToServer(now, now, errorMsg)
end

local function GetTargetServerIdAndPort(serverId)
    return CrossServerUtil.GetTargetServerIdAndPort(serverId)
end

local function GetAllProxy()
    return CommonUtil.GetAllProxy()
end

local function GetAllCheckVersionUrl()
    return CommonUtil.GetAllCheckVersionUrl()
end

local function GetAllCDNUrlList()
    return CommonUtil.GetAllCDNUrlList()
end

local function GetDebugCDNUrlList()
    return CommonUtil.GetDebugCDNUrlList()
end
local function GetFightAllianceId()
    return DataCenter.AllianceCompeteDataManager:GetFightAllianceId()
end

local function GetIsUseNetRaw()
    return CommonUtil.GetIsUseNetRaw()
end

local function GetWorldMainPos()
    return LuaEntry.Player:GetMainWorldPos()
end

local function WorldMarchUpdateHandle(message)
    DataCenter.WorldMarchDataManager:WorldMarchUpdateHandle(message)
end

local function HandleViewPointsReply(message)
    DataCenter.WorldPointManager:HandleViewPointsReply(message)
end
local function HandleViewUpdateNotify(message)
    DataCenter.WorldPointManager:HandleViewUpdateNotify(message)
end
local function HandleViewTileUpdateNotify(message)
    DataCenter.WorldPointManager:HandleViewTileUpdateNotify(message)
end
local function WorldMarchGetHandle(message)
    DataCenter.WorldMarchDataManager:WorldMarchGetHandle(message)
end
local function WorldMarchBattleUpdateHandle(message)
    DataCenter.WorldMarchDataManager:WorldMarchBattleUpdateHandle(message)
end

local function WorldMarchBattleUpdateBytesHandle(message)
end

local function WorldMarchBattleFinishHandle(message)
    DataCenter.WorldMarchBattleManager:BattleFinish(message)
end
local function WorldMarchDelHandle(message)
    DataCenter.WorldMarchDataManager:WorldMarchDelHandle(message)
end

local function WorldMarchTargetMineDataUpdate(needRefreshList,needRemoveList)
    DataCenter.WorldMarchDataManager:WorldMarchTargetMineDataUpdate(needRefreshList,needRemoveList)
end

local function WorldMarchGetReq()
    DataCenter.WorldMarchDataManager:SendRequest()
end

local function GetShowObjectModelParam()
end

local function GetResourceTypeByBuildId(buildId)
    return DataCenter.BuildManager:GetResourceTypeByBuildId(buildId)
end

local function GetCollectRangeInfoByIndex(index)
end

local function GetLodTemplates(lodType)
    return DataCenter.WorldLodManager:GetTemplatesByType(lodType)
end

local function GetAllLodTemplates()
    return DataCenter.WorldLodManager:GetAllTemplates()
end

local function GetOnMovingBuildUuid()
    return DataCenter.BuildManager:GetOnMovingBuildUuid()
end

local function MarchErrorLog(message)
    CommonUtil.MarchErrorLog(message)
end

local function GetCityBuildingDecoration()
    return DataCenter.DecorationDataManager:GetCityBuildingDecoration()
end

local function GetCreateBulletMaxCount()
    return 80
end

local function GetCityCameraZoomInit()
    return DataCenter.CityCameraManager:GetCurZoom()
end

local function GetWorldCameraZoomInit()
    return 125
end
local function IsAttackerByUid(uid)
    return DataCenter.WorldNewsDataManager:GetIsAttackerByUid(uid)
end

local function GetBlackDesertDecSpeed()
    return DataCenter.BirthPointTemplateManager:GetBlackLandSpeedByServerId(LuaEntry.Player:GetCurServerId())
end

local function GetCanShowBlackLand()
    return (LuaEntry.Player.serverType == ServerType.NORMAL)
end
local function GetBuildShowLevel(level)
    return level
end

--获取城内建筑模型的名字
local function GetCityBuildingModelName(buildId, buildLevel)
    return BuildingUtils.GetCityBuildingModelName(buildId, buildLevel)
end

--获取称号居中的偏移x
local function GetTitleNameDeltaX(iconName)
    if iconName == "appellation_icon_arena" then
        return 0
    end
    return 0.4
end

local function OnGotoSpecialWorld()
    local worldId = 0
    local serverId = 0
    local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
    if crossBuildData~=nil then
        worldId = crossBuildData.worldId
        serverId = crossBuildData.server
        if  LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            local pointId = crossBuildData.pointId
            local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
            position.x = position.x - 1
            position.z = position.z - 1
            CS.SceneManager.World:Lookat(position)
            CrossServerUtil.OnCrossServer(serverId,worldId)
        end
    end
end
local function GetEdenPassTemplate()
    local temp = DataCenter.EdenPassTemplateManager:GetAllTemplate()
    if temp~=nil then
        return table.values(temp)
    end
    return {}
end

local function GetAlliancePassList()
    local temp = DataCenter.WorldAllianceCityDataManager:GetAlliancePassList()
    return table.values(temp)
end
local function SetReconnect()
    CrossServerUtil.OnDisConnect()
    SFSNetwork.SendMessage(MsgDefines.LoginInitCommand)

    --CrossServerUtil.OnDisConnect()
    --CS.ApplicationLaunch.Instance.Loading:ReConnect()
end

local function IsUseNewAlarmFunction()
    return LuaEntry.DataConfig:CheckSwitch("red_battle_tip_optimized")
end

--通过运兵车皮肤id获取模型（3个特效）名字
local function GetMarchSkinNameBySkinId(skinId)
    --便于以后拓展，把uuid传进来
    local prefabName = MarchPrefabDefaultNameSelf
    local pdName = MarchEffectDefaultPD
    local pkName = MarchEffectDefaultPK
    local hitName = MarchEffectDefaultHit
    local height = MarchEffectDefaultHeight
    local prefabNameAlliance = MarchPrefabDefaultNameAlliance
    local prefabNameCamp = MarchPrefabDefaultNameCamp
    local prefabNameOther = MarchPrefabDefaultNameOther
    if skinId ~= 0 then
        local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
        if template ~= nil then
            prefabName = template:GetMarchPrefabName(MarchPrefabType.Self)
            pdName = template:GetMarchEffectPD()
            pkName = template:GetMarchEffectPK()
            hitName = template:GetMarchEffectHit()
            height = template:GetMarchEffectHeight()
            prefabNameAlliance = template:GetMarchPrefabName(MarchPrefabType.Alliance)
            prefabNameCamp = template:GetMarchPrefabName(MarchPrefabType.Camp)
            prefabNameOther = template:GetMarchPrefabName(MarchPrefabType.Other)
        end
    end

    local result = {}
    result.prefabName = string.format(UIAssets.March, prefabName)
    result.pdName = string.format(UIAssets.March, pdName)
    result.pkName = string.format(UIAssets.March, pkName)
    result.hitName = string.format(UIAssets.March, hitName)
    result.height = height
    result.prefabNameAlliance = string.format(UIAssets.March, prefabNameAlliance)
    result.prefabNameCamp = string.format(UIAssets.March, prefabNameCamp)
    result.prefabNameOther = string.format(UIAssets.March, prefabNameOther)
    return result
end

local function GetBuildPositionByBuildId(buildId)
    local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if template ~= nil then
        return template:GetPosition()
    end
    return Vector3.New(0 ,0 ,0)
end

local function GetMainBuildFireIsOpen()
    return DataCenter.VitaManager:IsFurnaceOpen()
end

local function GetIsDay()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local dayNight = DataCenter.VitaManager:GetDayNight(curTime)
    return dayNight == VitaDefines.DayNight.Day
end

--获取建筑模型是否可以显示盖子
local function IsShowBuildMark()
    return DataCenter.CityLabelManager:IsShowBuildMark()
end

--获取建筑模型是否可以显示白色待建造特效
local function CanShowCreateEffect(buildId)
    if DataCenter.BuildCanCreateManager:CanShowEffect() then
        local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        if desTemplate ~= nil then
            local pointId = desTemplate:GetPosIndex()
            local info = DataCenter.BuildCityBuildManager:GetCityBuildDataByPoint(pointId)
            if info ~= nil then
                if info.state == BuildCityBuildState.Fake then
                    return true
                elseif info.state == BuildCityBuildState.Pre then
                    return false
                elseif info.state == BuildCityBuildState.Own then
                    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(info.buildId)
                    if buildData ~= nil and buildData.level == 0 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

local function PlayMainSceneBGMusic()
    SoundUtil.PlayMainSceneBGMusic()
end

local function GetLightParam()
    local param = {}
    param.k1 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k1")
    param.k2 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k2")
    param.k3 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k3")
    param.k4 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k4")
    param.k5 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k5")
    param.k6 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k6")
    param.k7 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k7")
    param.k8 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k8")
    param.k9 = LuaEntry.DataConfig:TryGetNum("ambient_light", "k9")
    return param
end

local function GetPointLightUseBigRange()
    local k1 = LuaEntry.DataConfig:TryGetNum("cityEscalate","k1")
    if DataCenter.BuildManager.MainLv ~= nil then
        return DataCenter.BuildManager.MainLv >= k1
    end
    return false
end
local function StartUpWorldPoint()
    CS.SceneManager.World:Lookat(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World))
    DataCenter.WorldPointManager:StartUp()
end
local function CloseWorldPoint()
    DataCenter.WorldPointManager:Close()
end
local function StartMarchInit()
    DataCenter.WorldMarchDataManager:StartUp()
    WorldTroopLineManager:GetInstance():StartUp()
    WorldTroopManager:GetInstance():StartUp()
end
local function CloseMarch()
    WorldTroopLineManager:GetInstance():Close()
    WorldTroopManager:GetInstance():Close()
    DataCenter.WorldMarchDataManager:Close()
end

local function StartViewRequest()
    DataCenter.WorldPointManager:StartViewRequest()
    DataCenter.WorldPointManager:UpdateViewRequest(true)
end
local function ForceRequestPoint()
    DataCenter.WorldPointManager:UpdateViewRequest(true)
end
CSharpCallLuaInterface.StartUpWorldPoint = StartUpWorldPoint
CSharpCallLuaInterface.StartMarchInit = StartMarchInit
CSharpCallLuaInterface.CloseMarch = CloseMarch
CSharpCallLuaInterface.ForceRequestPoint = ForceRequestPoint
CSharpCallLuaInterface.CloseWorldPoint = CloseWorldPoint
CSharpCallLuaInterface.StartViewRequest = StartViewRequest
CSharpCallLuaInterface.GetLuaStringTable = GetLuaStringTable
CSharpCallLuaInterface.GetDataTableCount = GetDataTableCount
CSharpCallLuaInterface.GetTemplateData = GetTemplateData
CSharpCallLuaInterface.GetWorldPointTileSize = GetWorldPointTileSize
CSharpCallLuaInterface.GetAllianceColorList = GetAllianceColorList
CSharpCallLuaInterface.GetAllianceCityList = GetAllianceCityList
CSharpCallLuaInterface.GetDirByPos = GetDirByPos
CSharpCallLuaInterface.GetIsAllianceCityOpen= GetIsAllianceCityOpen
CSharpCallLuaInterface.GetWorldPointModelPath =  GetWorldPointModelPath
CSharpCallLuaInterface.SendFindMainBuildInitPositionMessage =  SendFindMainBuildInitPositionMessage
CSharpCallLuaInterface.GetAllianceCitySimpleDataByPointInfo =GetAllianceCitySimpleDataByPointInfo
CSharpCallLuaInterface.GetAllianceCityIdByPointInfo = GetAllianceCityIdByPointInfo
CSharpCallLuaInterface.CheckSwitch = CheckSwitch
CSharpCallLuaInterface.GetConfigNum = GetConfigNum
CSharpCallLuaInterface.GetConfigStr = GetConfigStr
CSharpCallLuaInterface.GetResourceNameByType = GetResourceNameByType
CSharpCallLuaInterface.GetTrainingTypeAndBuildingType = GetTrainingTypeAndBuildingType
CSharpCallLuaInterface.GetMainPos = GetMainPos
CSharpCallLuaInterface.GetBuildTileIndex= GetBuildTileIndex
CSharpCallLuaInterface.IsCanPutDownByBuild = IsCanPutDownByBuild
CSharpCallLuaInterface.IsCanShowCollectGreenByPoint = IsCanShowCollectGreenByPoint
CSharpCallLuaInterface.IsInMyBaseInsideRange = IsInMyBaseInsideRange
CSharpCallLuaInterface.GetOutermostIndexByIndex= GetOutermostIndexByIndex
CSharpCallLuaInterface.GetBuildModelCenter =GetBuildModelCenter
CSharpCallLuaInterface.GetBuildModelCenterVec= GetBuildModelCenterVec
CSharpCallLuaInterface.GetCollectMaxEffectByBuildId =GetCollectMaxEffectByBuildId
CSharpCallLuaInterface.SetIsInCity = SetIsInCity
CSharpCallLuaInterface.CheckIsInBuildRange =CheckIsInBuildRange
CSharpCallLuaInterface.IsCollectRangePoint =IsCollectRangePoint
CSharpCallLuaInterface.GetCollectRangePoint =GetCollectRangePoint
CSharpCallLuaInterface.OnPointDownMarch = OnPointDownMarch
CSharpCallLuaInterface.OnPointUpMarch = OnPointUpMarch
CSharpCallLuaInterface.OnBeginDragMarch =OnBeginDragMarch
CSharpCallLuaInterface.GetMainLv =GetMainLv
CSharpCallLuaInterface.CheckReplaceMain =CheckReplaceMain
CSharpCallLuaInterface.SetMainPos =SetMainPos
CSharpCallLuaInterface.UpdateBuildings =UpdateBuildings
CSharpCallLuaInterface.GetAllLuaBuildWithoutFoldUp =GetAllLuaBuildWithoutFoldUp
CSharpCallLuaInterface.GetBuildingDataByUuid =GetBuildingDataByUuid
CSharpCallLuaInterface.GetResourcePercent = GetResourcePercent
CSharpCallLuaInterface.GetBuildCollectSpeed = GetBuildCollectSpeed
CSharpCallLuaInterface.GetBuildCollectMaxSelf = GetBuildCollectMaxSelf
CSharpCallLuaInterface.GetBuildCollectMaxOther = GetBuildCollectMaxOther
CSharpCallLuaInterface.GetShowBubblePercent =GetShowBubblePercent
CSharpCallLuaInterface.GetBuildingDataByBuildId =GetBuildingDataByBuildId
CSharpCallLuaInterface.IsInNewUserWorld =IsInNewUserWorld
CSharpCallLuaInterface.GetBuildDataResourcePercent =GetBuildDataResourcePercent
CSharpCallLuaInterface.GetBuildStartTimeAndEndTime =GetBuildStartTimeAndEndTime
CSharpCallLuaInterface.IsBuildWork =IsBuildWork
CSharpCallLuaInterface.GetAllBuildTileByItemId =GetAllBuildTileByItemId
CSharpCallLuaInterface.GetAllInBaseTruckShowBuild =GetAllInBaseTruckShowBuild
CSharpCallLuaInterface.GetBuildingDataParamByUuid = GetBuildingDataParamByUuid
CSharpCallLuaInterface.GetBuildingDataParamByBuildId = GetBuildingDataParamByBuildId
CSharpCallLuaInterface.GetLodArray = GetLodArray
CSharpCallLuaInterface.IsCanShowBuildBtn = IsCanShowBuildBtn
CSharpCallLuaInterface.CheckIsInBasementRange = CheckIsInBasementRange
CSharpCallLuaInterface.GetConfigMd5 = GetConfigMd5
CSharpCallLuaInterface.IsShowBuildFlyPath = IsShowBuildFlyPath
CSharpCallLuaInterface.SetGuideGarbageCollectTime = SetGuideGarbageCollectTime
CSharpCallLuaInterface.AddGuideGarbageCollectToQueue = AddGuideGarbageCollectToQueue
CSharpCallLuaInterface.RemoveFromGarbageQueue = RemoveFromGarbageQueue
CSharpCallLuaInterface.GetCurrentGarbageQueue = GetCurrentGarbageQueue
CSharpCallLuaInterface.GetAllianceLeaderUid = GetAllianceLeaderUid
CSharpCallLuaInterface.IsShowPrologue = IsShowPrologue
CSharpCallLuaInterface.OnLoadSceneOK = OnLoadSceneOK
CSharpCallLuaInterface.OnUploadPicStart = OnUploadPicStart
CSharpCallLuaInterface.GetPlayerPic = GetPlayerPic
CSharpCallLuaInterface.GetPlayerPicVer = GetPlayerPicVer
CSharpCallLuaInterface.GetHeroQuality = GetHeroQuality
CSharpCallLuaInterface.GetHeroIcon =GetHeroIcon
CSharpCallLuaInterface.GetMarchStateIcon = GetMarchStateIcon
CSharpCallLuaInterface.GetBuffPerformanceInfo = GetBuffPerformanceInfo
CSharpCallLuaInterface.CanShowCityLabel = CanShowCityLabel
CSharpCallLuaInterface.GetBuildQueueState = GetBuildQueueState
CSharpCallLuaInterface.IsShowWorldCollectPoint = IsShowWorldCollectPoint
CSharpCallLuaInterface.SendErrorMessageToServer = SendErrorMessageToServer
CSharpCallLuaInterface.GetTargetServerIdAndPort = GetTargetServerIdAndPort
CSharpCallLuaInterface.GetAllProxy =GetAllProxy
CSharpCallLuaInterface.GetAllCheckVersionUrl = GetAllCheckVersionUrl
CSharpCallLuaInterface.GetAllCDNUrlList = GetAllCDNUrlList
CSharpCallLuaInterface.GetFightAllianceId = GetFightAllianceId
CSharpCallLuaInterface.GetIsUseNetRaw = GetIsUseNetRaw
CSharpCallLuaInterface.GetWorldMainPos =GetWorldMainPos
CSharpCallLuaInterface.WorldMarchUpdateHandle =WorldMarchUpdateHandle
CSharpCallLuaInterface.WorldMarchDelHandle = WorldMarchDelHandle
CSharpCallLuaInterface.WorldMarchBattleFinishHandle =  WorldMarchBattleFinishHandle
CSharpCallLuaInterface.WorldMarchGetReq = WorldMarchGetReq
CSharpCallLuaInterface.GetShowObjectModelParam = GetShowObjectModelParam
CSharpCallLuaInterface.GetResourceTypeByBuildId = GetResourceTypeByBuildId
CSharpCallLuaInterface.GetCollectRangeInfoByIndex = GetCollectRangeInfoByIndex
CSharpCallLuaInterface.GetLodTemplates = GetLodTemplates
CSharpCallLuaInterface.GetAllLodTemplates = GetAllLodTemplates
CSharpCallLuaInterface.CanMoveBuild = CanMoveBuild
CSharpCallLuaInterface.GetNextChangeTimeByResourceUuid = GetNextChangeTimeByResourceUuid
CSharpCallLuaInterface.GetOnMovingBuildUuid =GetOnMovingBuildUuid
CSharpCallLuaInterface.GetCityLodArray =GetCityLodArray
CSharpCallLuaInterface.MarchErrorLog = MarchErrorLog
CSharpCallLuaInterface.GetAllianceBuildTileIndex = GetAllianceBuildTileIndex
CSharpCallLuaInterface.IsCanPutDownByAllianceBuild = IsCanPutDownByAllianceBuild
CSharpCallLuaInterface.GetCityBuildingDecoration = GetCityBuildingDecoration
CSharpCallLuaInterface.GetCreateBulletMaxCount = GetCreateBulletMaxCount
CSharpCallLuaInterface.GetCityCameraZoomInit = GetCityCameraZoomInit
CSharpCallLuaInterface.GetWorldCameraZoomInit =GetWorldCameraZoomInit
CSharpCallLuaInterface.GetBuildMainVecByModelCenter =GetBuildMainVecByModelCenter
CSharpCallLuaInterface.IsAttackerByUid= IsAttackerByUid
CSharpCallLuaInterface.GetBlackDesertDecSpeed  = GetBlackDesertDecSpeed
CSharpCallLuaInterface.GetCanShowBlackLand = GetCanShowBlackLand
CSharpCallLuaInterface.GetBuildShowLevel = GetBuildShowLevel
CSharpCallLuaInterface.GetMyDirectionIconName = GetMyDirectionIconName
CSharpCallLuaInterface.GetDirectionIconName = GetDirectionIconName
CSharpCallLuaInterface.WorldMarchBattleUpdateHandle = WorldMarchBattleUpdateHandle
CSharpCallLuaInterface.GetCityBuildingModelName = GetCityBuildingModelName
CSharpCallLuaInterface.GetTitleNameDeltaX = GetTitleNameDeltaX
CSharpCallLuaInterface.WorldMarchBattleUpdateBytesHandle = WorldMarchBattleUpdateBytesHandle
CSharpCallLuaInterface.OnGotoSpecialWorld = OnGotoSpecialWorld
CSharpCallLuaInterface.SetReconnect = SetReconnect
CSharpCallLuaInterface.GetDragonBuildLodIcon = GetDragonBuildLodIcon
CSharpCallLuaInterface.GetDragonBuildName = GetDragonBuildName
CSharpCallLuaInterface.GetEdenPassTemplate = GetEdenPassTemplate
CSharpCallLuaInterface.GetAlliancePassList = GetAlliancePassList
CSharpCallLuaInterface.IsUseNewAlarmFunction = IsUseNewAlarmFunction
CSharpCallLuaInterface.WorldMarchTargetMineDataUpdate = WorldMarchTargetMineDataUpdate
CSharpCallLuaInterface.GetMarchSkinNameBySkinId = GetMarchSkinNameBySkinId
CSharpCallLuaInterface.IsUseLoadAsync =IsUseLoadAsync
CSharpCallLuaInterface.GetBuildPositionByBuildId =GetBuildPositionByBuildId
CSharpCallLuaInterface.GetMainBuildFireIsOpen = GetMainBuildFireIsOpen
CSharpCallLuaInterface.GetBuildingDataByPointId = GetBuildingDataByPointId
CSharpCallLuaInterface.GetIsDay =GetIsDay
CSharpCallLuaInterface.IsShowBuildMark =IsShowBuildMark
CSharpCallLuaInterface.CanShowCreateEffect =CanShowCreateEffect
CSharpCallLuaInterface.PlayMainSceneBGMusic =PlayMainSceneBGMusic
CSharpCallLuaInterface.GetLightParam = GetLightParam
CSharpCallLuaInterface.GetPointLightUseBigRange = GetPointLightUseBigRange
CSharpCallLuaInterface.IsUseLuaLoading =IsUseLuaLoading
CSharpCallLuaInterface.IsUseLuaWorldPoint= IsUseLuaWorldPoint
CSharpCallLuaInterface.GetDebugCDNUrlList = GetDebugCDNUrlList
CSharpCallLuaInterface.WorldMarchGetHandle =WorldMarchGetHandle
CSharpCallLuaInterface.HandleViewPointsReply =HandleViewPointsReply
CSharpCallLuaInterface.HandleViewUpdateNotify = HandleViewUpdateNotify
CSharpCallLuaInterface.HandleViewTileUpdateNotify = HandleViewTileUpdateNotify
return ConstClass("CSharpCallLuaInterface", CSharpCallLuaInterface)