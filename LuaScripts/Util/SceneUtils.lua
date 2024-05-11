---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/11/22 16:09
---
local SceneUtils = {}
local isInCityScene = false
local needDestroyScene = nil
local function SetIsInCity(value)
    isInCityScene = value
end

local function TileToWorld(tilePos)
    local v3 = {}
    v3.x = (tilePos.x+0.5)*TileSize
    v3.y = 0
    v3.z = (tilePos.y+0.5)*TileSize
    return v3
end

local function WorldToTileFloat(worldPos)
    local v2 = {}
    v2.x = (worldPos.x / TileSize) - 0.5
    v2.y = (worldPos.z / TileSize) - 0.5
    return v2
end

--最大两位小数
local function WorldToTileFloatXY(worldPos)
    local x = math.floor(((worldPos.x / TileSize) - 0.5) * 100 ) / 100
    local y = math.floor(((worldPos.z / TileSize) - 0.5) * 100 ) / 100
    return x, y
end

local function WorldToTile(worldPos)
    local v2 = {}
    v2.x = math.floor(worldPos.x/TileSize)
    v2.y = math.floor(worldPos.z/TileSize)
    return v2
end

local function WorldToTileXZ(x, z)
	local x = math.floor(x/TileSize)
	local y = math.floor(z/TileSize)
	return x, y
end

local function TileDistance(v2a,v2b)
    local  num1 = (v2a.x - v2b.x);
    local  num2 = (v2a.y - v2b.y);
    return  Mathf.Sqrt( num1 *  num1 + num2 *  num2);
end

local function IndexToTilePos(index,forceType)
    local tileCount = WorldTileCount
    if forceType~=nil then --传入值后，强制使用转换城内或世界转换规则；不传默认使用当前场景转换规则
        if forceType == ForceChangeScene.World then
            tileCount = WorldTileCount
        else
            tileCount = CityTileCount
        end
    else
        if isInCityScene== true then
            tileCount = CityTileCount
        end
    end
    
    if index<1 or index>tileCount*tileCount then
        local v2 = {}
        v2.x = 0
        v2.y = 0
        return v2
    end
    index = index-1
    local v2 = {}
    v2.x = index%tileCount
    v2.y = math.floor(index/tileCount)
    return  v2
end


local function ClampTilePos(tilePos,forceType)
    local tileCount = WorldTileCount
    if forceType~=nil then --传入值后，强制使用转换城内或世界转换规则；不传默认使用当前场景转换规则
        if forceType == ForceChangeScene.World then
            tileCount = WorldTileCount
        else
            tileCount = CityTileCount
        end
    else
        if isInCityScene== true then
            tileCount = CityTileCount
        end
    end
    if tilePos.x<0 then
        tilePos.x = 0
    end
    if tilePos.x> tileCount-1 then
        tilePos.x = tileCount-1
    end
    if tilePos.y<0 then
        tilePos.y = 0
    end
    if tilePos.y> tileCount-1 then
        tilePos.y = tileCount-1
    end
    return tilePos
end

local function TilePosToIndex(tilePos,forceType)
    --local tileCount = WorldTileCount
    --if isInCityScene == true then
        --tileCount = CityTileCount
    --end
    --if tilePos.x<0 or tilePos.y<0 or tilePos.x>tileCount-1 or tilePos.y>tileCount-1 then
        --return 0
    --end
    --return tilePos.x+tilePos.y*tileCount+1
	return SceneUtils.TileXYToIndex(tilePos.x, tilePos.y,forceType)
end

local function TileXYToIndex(x, y,forceType)
    local tileCount = WorldTileCount
    if forceType~=nil then
        if forceType == ForceChangeScene.World then
            tileCount = WorldTileCount
        else
            tileCount = CityTileCount
        end
    else
        if isInCityScene== true then
            tileCount = CityTileCount
        end
    end
	if x<0 or y<0 or x>tileCount-1 or y>tileCount-1 then
		return 0
	end
	return x+y*tileCount+1
end

local function TileIndexToWorld(index,forceType)
    return SceneUtils.TileToWorld(SceneUtils.IndexToTilePos(index,forceType))
end

local function WorldToTileIndex(pos,forceType)
    return SceneUtils.TilePosToIndex(SceneUtils.WorldToTile(pos),forceType)
end

local function GetIndexByOffset(index,x,y,forceType)
    local temp = SceneUtils.GetIndexByOffsetX(index,x,forceType)
    if temp>0 then
        return SceneUtils.GetIndexByOffsetY(temp, y,forceType)
    end
    return 0
end

local function GetIndexByOffsetX(index,offset,forceType)
    local temp = index-1
    local tileCount = WorldTileCount
    if forceType~=nil then
        if forceType == ForceChangeScene.World then
            tileCount = WorldTileCount
        else
            tileCount = CityTileCount
        end
    else
        if isInCityScene== true then
            tileCount = CityTileCount
        end
    end
    temp = temp%tileCount
    temp = temp+offset
    if temp>=0 and temp<tileCount then
        return index+offset
    end
    return 0
end
local function GetIndexByOffsetY(index,offset,forceType)
    local temp = index-1
    local tileCount = WorldTileCount
    if forceType~=nil then
        if forceType == ForceChangeScene.World then
            tileCount = WorldTileCount
        else
            tileCount = CityTileCount
        end
    else
        if isInCityScene== true then
            tileCount = CityTileCount
        end
    end
    temp = math.floor(temp/tileCount)
    temp = temp+offset
    if temp>=0 and temp<tileCount then
        return index+offset*tileCount
    end
    return 0
end

--{{{Lua 计算march当前位置
local function GetMarchCurPos(march)
    local position
    local status = march.status
    local path = string.split(march.path,";")
    local pathIndex = -1
    local pathSegment =nil
    if status == MarchStatus.MOVING or status == MarchStatus.BACK_HOME or status == MarchStatus.CHASING or status == MarchStatus.IN_WORM_HOLE then
        if #path > 1 then
            local serverNow = UITimeManager:GetInstance():GetServerTime()
            local pathLen = 0
            local dec = DataCenter.BirthPointTemplateManager:GetBlackLandSpeedByServerId(LuaEntry.Player:GetCurServerId())
            local blackEndTime = march.blackEndTime
            local blackStartTime = march.blackStartTime
            if blackEndTime~=nil and blackStartTime~=nil and blackStartTime>0 and blackEndTime>0 then
                if serverNow<=blackEndTime then
                    pathLen = march.speed * (serverNow - march.startTime) * 0.001*TileSize
                elseif serverNow<= blackEndTime then
                    pathLen = march.speed * (blackStartTime - march.startTime) * 0.001*TileSize
                    pathLen = pathLen + march.speed * (serverNow - blackStartTime) * 0.001*TileSize*dec
                else
                    pathLen = march.speed * (blackStartTime - march.startTime) * 0.001*TileSize
                    pathLen = pathLen + march.speed * (blackEndTime - blackStartTime) * 0.001*TileSize*dec
                    pathLen = pathLen + march.speed * (serverNow - blackEndTime) * 0.001*TileSize
                end
            else
                pathLen = march.speed * (serverNow - march.startTime) * 0.001*TileSize
            end
            pathSegment = SceneUtils.CreatePathSegment(march)
            position,pathIndex = SceneUtils.CalcMoveOnPath(pathSegment, 1, pathLen)
        else
            position = SceneUtils.TileIndexToWorld(march.targetPos,ForceChangeScene.World)
        end
    elseif status == MarchStatus.TRANSPORT_BACK_HOME or status == MarchStatus.WAIT_RALLY then
        position = SceneUtils.TileIndexToWorld(march.startPos,ForceChangeScene.World)
    else
        position = SceneUtils.TileIndexToWorld(march.targetPos,ForceChangeScene.World)
    end
    return position,pathSegment,pathIndex
end

local function CreatePathSegment(march)
    local path = string.split(march.path,";")
    if #path < 2 then
        return nil
    end
    for i = 1 ,#path do
        path[i] = tonumber(path[i])
    end
    local pathList = {}
    for i = 1 ,#path do
        pathList[i] = {}
        if i < #path then
            local curPos = SceneUtils.TileIndexToWorld(path[i],ForceChangeScene.World)
            local nextPos = SceneUtils.TileIndexToWorld(path[i + 1],ForceChangeScene.World)
            local pathVec = Vector3.New(nextPos.x - curPos.x, nextPos.y - curPos.y, nextPos.z - curPos.z)
            pathList[i].pos = curPos
            pathList[i].dir = Vector3.Normalize(pathVec)
            pathList[i].dist = Vector3.Magnitude(pathVec)
        else
            pathList[i].pos = SceneUtils.TileIndexToWorld(path[i],ForceChangeScene.World)
            pathList[i].dir = pathList[i - 1].dir
            pathList[i].dist = LongMaxValue
        end
    end

    return pathList
end

local function CalcMoveOnPath(path,startIndex,startPathLen)
    local pathIdx = startIndex
    local pathLen = startPathLen
    local pos
    while pathIdx < #path and pathLen > path[pathIdx].dist do
        pathLen = path[pathIdx].dist - 1
        pathIdx = pathIdx + 1
    end
    if pathIdx < #path then
        pos = path[pathIdx].pos + path[pathIdx].dir * pathLen
    else
        pos = path[#path].pos
    end
    return pos,pathIdx
end


local function GetIsInCity()
    local curScene = CS.SceneManager.CurrSceneID
    return curScene == SceneManagerSceneID.City
end

local function GetIsInWorld()
    local curScene = CS.SceneManager.CurrSceneID
    return curScene == SceneManagerSceneID.World
end

local function GetIsInPve()
    local curScene = CS.SceneManager.CurrSceneID
    return curScene == SceneManagerSceneID.PVE
end

--}}}


local function ChangeToCity(createAction, notCloseWindow)
    if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        UIUtil.ShowTipsId(376135)
        return
    end
    local action = createAction
    if SceneUtils.GetIsInCity() then
        if action~=nil then
            action()
        end
    elseif SceneUtils.GetIsInWorld() then
        if needDestroyScene~=nil then
            CS.SceneManager.DestroyScene(needDestroyScene)
            needDestroyScene = nil
        end
        needDestroyScene = CS.SceneManager.World
        if notCloseWindow ~= true then
            GoToUtil.CloseAllWindows()
        end
        DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.BackCitySceneFinish, true)
        DataCenter.BuildBubbleManager:ClearAll()
        DataCenter.WorldBuildBubbleManager:ClearAll()
        DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
        AllianceBuildBloodManager:GetInstance():RemoveAllEffect()
        WorldCityTipManager:GetInstance():RemoveAllTip()
        EventManager:GetInstance():Broadcast(EventId.OnBeforeEnterCity)
        DataCenter.WorldFavoDataManager:ClearAllianceMarks()
        SceneUtils.SetIsInCity(true)
        SFSNetwork.SendMessage(MsgDefines.LeaveWorld) --向服务器发送离开当前世界
        if needDestroyScene~=nil then
            CS.SceneManager.DestroyScene(needDestroyScene)
            needDestroyScene = nil
        end
        CS.SceneManager.CreateCity()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_ChangeScene)
        CS.SceneManager.World:CreateScene(function()
            EventManager:GetInstance():Broadcast(EventId.OnEnterCity)
            CommonUtil.PlayGameBgMusic()
            EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllShow)
            DataCenter.CityNpcManager:SetNpcVisible(true)
            if not UIManager:GetInstance():HasWindow() then
                EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
            end
            DataCenter.GuideManager:DoWaitTriggerAfterBack()
            if action~=nil then
                action()
            end
            DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.BackCitySceneFinish, nil)
            EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
        end)
    elseif SceneUtils.GetIsInPve() then
        if DataCenter.BattleLevel.entered then
            DataCenter.BattleLevel:Exit(function()
                if action~=nil then
                    action()
                end
            end, nil, ForceChangeScene.City)
        else
            DataCenter.LWBattleManager:Exit(function()
                if action~=nil then
                    action()
                end
            end)
        end
    end
end

local function ChangeToWorld(createAction, noSendReq)
    local action = createAction
    if SceneUtils.GetIsInWorld() then
        if action~=nil then
            action()
        end
    elseif SceneUtils.GetIsInCity() then
        if needDestroyScene~=nil then
            CS.SceneManager.DestroyScene(needDestroyScene)
            needDestroyScene = nil
        end
        needDestroyScene = CS.SceneManager.World
        GoToUtil.CloseAllWindows()
        DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.BackWorldSceneFinish, true)
        DataCenter.BuildBubbleManager:ClearAll()
        DataCenter.WorldBuildBubbleManager:ClearAll()
        DataCenter.AllianceCityTipManager:RemoveAllAllianceCityTip()
        EventManager:GetInstance():Broadcast(EventId.OnBeforeEnterWorld)
        AllianceBuildBloodManager:GetInstance():RemoveAllEffect()
        WorldCityTipManager:GetInstance():RemoveAllTip()
        DataCenter.WorldFavoDataManager:ClearAllianceMarks()
        EventManager:GetInstance():Broadcast(EventId.SetCityPeopleAndCarVisible, CityPeopleAndCarVisibleType.AllHide)
        DataCenter.CityNpcManager:SetNpcVisible(false)
        needDestroyScene:UninitSubModulesAndCameraUpdate()
        CS.SceneManager:CreateWorld()
        SceneUtils.SetIsInCity(false)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_ChangeScene)
        CS.SceneManager.World:CreateScene(function()
            if needDestroyScene~=nil then
                CS.SceneManager.DestroyScene(needDestroyScene)
                needDestroyScene = nil
            end
            EventManager:GetInstance():Broadcast(EventId.OnEnterWorld)
            --if not noSendReq then
            CommonUtil.PlayGameBgMusic()
            if CommonUtil.IsUseLuaWorldPoint()==false then
                CS.SceneManager.World:UpdateViewRequest(true)
            end
            --end
            EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
            if action~=nil then
                action()
            end
            DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.BackWorldSceneFinish, nil)
            EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
        end)
    elseif SceneUtils.GetIsInPve() then
        if DataCenter.BattleLevel.entered then
            DataCenter.BattleLevel:Exit(function()
                if action~=nil then
                    action()
                end
            end, nil, ForceChangeScene.World)
        else
            DataCenter.LWBattleManager:Exit(function()
                if action~=nil then
                    action()
                end
            end)
        end
    end
end

local function CheckCanGotoWorld()
    local canShow = false
    local needStr = LuaEntry.DataConfig:TryGetStr("canopyvault", "k4")
    local arr = string.split(needStr,";")
    if #arr>=2 then
        local buildId = tonumber(arr[1])
        local buildLv = tonumber(arr[2])
        local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if mainBuild~=nil then
            if buildLv<=mainBuild.level then
                canShow = true
            end
        end
    end
    return canShow
end


local function IsInBlackRange(pointId)
    if LuaEntry.Player.serverType == ServerType.NORMAL then
        local v2 = SceneUtils.IndexToTilePos(pointId,ForceChangeScene.World)
        local a,b,c,d  = DataCenter.BirthPointTemplateManager:GetBlackLandRange()
        if v2.x>=a.x and v2.x<=b.x and v2.y<=a.y and v2.y>=d.y then
            return true
        end
        return false
    end
    
end

local function GetCrossPointByTroopLineAndBlackRange(startPoint,endPoint)
    local point1 = nil
    local point2 = nil
    if startPoint == endPoint then
        return point1,point2
    end
    local sV2 = SceneUtils.IndexToTilePos(startPoint,ForceChangeScene.World)
    local dV2 = SceneUtils.IndexToTilePos(endPoint,ForceChangeScene.World)
    local a,b,c,d  = DataCenter.BirthPointTemplateManager:GetBlackLandRange()
    local retPoint = UIUtil.GetPosOfTowLine(sV2,dV2,a,c)
    if retPoint~=nil and retPoint>0 then
        point1 = retPoint
    end
    retPoint = UIUtil.GetPosOfTowLine(sV2,dV2,a,b)
    if retPoint~=nil and retPoint>0 then
        if point1 ==nil then
            point1 = retPoint
        else
            point2 = retPoint
        end
    end
    retPoint = UIUtil.GetPosOfTowLine(sV2,dV2,b,d)
    if retPoint~=nil and retPoint>0 then
        if point1 ==nil then
            point1 = retPoint
        else
            point2 = retPoint
        end
    end
    retPoint = UIUtil.GetPosOfTowLine(sV2,dV2,c,d)
    if retPoint~=nil and retPoint>0 then
        if point1 ==nil then
            point1 = retPoint
        else
            point2 = retPoint
        end
    end
    if point1~=nil and point2~=nil then
        local distanceA = math.ceil(SceneUtils.TileDistance(sV2,SceneUtils.IndexToTilePos(point1, ForceChangeScene.World)))
        local distanceB = math.ceil(SceneUtils.TileDistance(sV2,SceneUtils.IndexToTilePos(point2, ForceChangeScene.World)))
        if distanceA<=distanceB then
            return point1,point2
        else
            return point2,point1
        end
    end
    return point1,point2
    
end

local function GetPathFormAToB(startPos,endPos)
    local path = ""
    if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
        if SceneUtils.GetIsInWorld() and CS.SceneManager.World~=nil and CS.SceneManager.World.FindingPathForEden~=nil then
            path = CS.SceneManager.World:FindingPathForEden(startPos,endPos)
            return path
        end
    end
    path = startPos..";"..endPos
    return path
end

local function CalculateDistanceV3(path)
    local distance = 0
    if path~=nil and path~="" then
        local arr = string.split(path,";")
        if #arr>1 then
            for i=1,#arr-1 do
                local p1 = toInt(arr[i])
                local p2 = toInt(arr[i+1])
                local dis = Vector3.Distance(SceneUtils.TileIndexToWorld(p1,ForceChangeScene.World),SceneUtils.TileIndexToWorld(p2,ForceChangeScene.World))
                distance = distance+dis
            end
        end
    end
    return distance
end

local function IsTargetPosWalkable(endPos,startPos)
    if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
        if CS.SceneManager.World:IsTileWalkable(CS.SceneManager.World:IndexToTilePos(endPos))==false then
            return false
        end
        local path = SceneUtils.GetPathFormAToB(startPos,endPos)
        if path == nil or path =="" then
            return false
        end
    end
    return true
end

local function CreateWorld()
    CS.SceneManager.CreateWorld()
end

local function CreateCity()
    CS.SceneManager.CreateCity()
end

local function IsInMap(tilePos,forceType)
    local tileCount = WorldTileCount
    if forceType~=nil then --传入值后，强制使用转换城内或世界转换规则；不传默认使用当前场景转换规则
        if forceType == ForceChangeScene.World then
            tileCount = WorldTileCount
        else
            tileCount = CityTileCount
        end
    else
        if isInCityScene== true then
            tileCount = CityTileCount
        end
    end
    if tilePos.x<0 then
        return false
    end
    if tilePos.x > tileCount-1 then
        return false
    end
    if tilePos.y<0 then
        return false
    end
    if tilePos.y> tileCount-1 then
        return false
    end
    return true
end

local function CheckIsWorldUnlock()
    if SceneUtils.GetIsInPve() then
        return false
    end
    if SceneUtils.GetIsInCity() then
        local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.World)
        if unlockBtnLockType ~= UnlockBtnLockType.Show then
            local lock_tips = LocalController:instance():getValue(DataCenter.UnlockBtnManager:GetTableName(), UnlockBtnType.World, "lock_tips", 0)
            return false,lock_tips
        end
    end
    return true
end
SceneUtils.CheckIsWorldUnlock = CheckIsWorldUnlock
SceneUtils.SetIsInCity =SetIsInCity
SceneUtils.TileToWorld =TileToWorld
SceneUtils.TileDistance = TileDistance
SceneUtils.WorldToTile =WorldToTile
SceneUtils.WorldToTileXZ = WorldToTileXZ
SceneUtils.IndexToTilePos =IndexToTilePos
SceneUtils.TilePosToIndex =TilePosToIndex
SceneUtils.TileXYToIndex =TileXYToIndex
SceneUtils.TileIndexToWorld =TileIndexToWorld
SceneUtils.WorldToTileIndex =WorldToTileIndex
SceneUtils.GetIndexByOffset =GetIndexByOffset
SceneUtils.GetIndexByOffsetX =GetIndexByOffsetX
SceneUtils.GetIndexByOffsetY= GetIndexByOffsetY
SceneUtils.GetMarchCurPos = GetMarchCurPos
SceneUtils.CreatePathSegment = CreatePathSegment
SceneUtils.CalcMoveOnPath = CalcMoveOnPath
SceneUtils.WorldToTileFloat = WorldToTileFloat
SceneUtils.WorldToTileFloatXY = WorldToTileFloatXY
SceneUtils.GetIsInCity = GetIsInCity
SceneUtils.GetIsInWorld = GetIsInWorld
SceneUtils.GetIsInPve = GetIsInPve
SceneUtils.ChangeToWorld =ChangeToWorld
SceneUtils.ChangeToCity =ChangeToCity
SceneUtils.CheckCanGotoWorld =CheckCanGotoWorld
SceneUtils.GetCrossPointByTroopLineAndBlackRange = GetCrossPointByTroopLineAndBlackRange
SceneUtils.IsInBlackRange = IsInBlackRange
SceneUtils.IsTargetPosWalkable = IsTargetPosWalkable
SceneUtils.CalculateDistanceV3 = CalculateDistanceV3
SceneUtils.GetPathFormAToB = GetPathFormAToB
SceneUtils.CreateWorld = CreateWorld
SceneUtils.CreateCity = CreateCity
SceneUtils.ClampTilePos = ClampTilePos
SceneUtils.IsInMap =IsInMap
return ConstClass("SceneUtils", SceneUtils)