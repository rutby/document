
local pairs = pairs
local ipairs = ipairs
local CollectionData = require"Scene.PVEBattleLevel.CollectionData"
local CollectionObject = require"Scene.PVEBattleLevel.CollectionObject"
local Const = require"Scene.PVEBattleLevel.Const"
local Resource = CS.GameEntry.Resource
local rapidjson = require "rapidjson"
local Time = Time
---
--- 资源点管理，九宫格创建显示
---

local VisibleChunkRange = 1
local MapTileSize = 100
local TileCountPerChunk = 6
local CreateCountPerFrame = 10
local MapChunkSize = MapTileSize / TileCountPerChunk

---@class Scene.PVEBattleLevel.CollectionManager
local CollectionManager = BaseClass("CollectionManager")

function CollectionManager:__init()
    self.battleLevel = nil
    self.lastViewIndex = -1
    self.collectionDataDict = {}
    self.collectionObjDict = {} 
    self.cutUpdateDict = {}
    self.createList = {}
    self.chunks = {}
    self.resConfigAsset = nil
    self.pointIdDic = {}
end

function CollectionManager:__delete()
    self:Destroy()
end

function CollectionManager:Init(battleLevel, collectionConfig)
    self.battleLevel = battleLevel
    self.lastViewIndex = -1
    self.chunks = {}
    self.createList = {}
    self.collectionObjDict = {}
    self.collectionDataDict = {}
    self.cutUpdateDict = {}
    self.pointIdDic = {}
    
    self.slowUpdateTimer = TimerManager:GetInstance():GetTimer(1, function() self:OnSlowUpdate() end, nil, false, false, false)
    self.slowUpdateTimer:Start()

    self.resConfigAsset = Resource:LoadAssetAsync(collectionConfig, typeof(CS.UnityEngine.TextAsset))
    self.resConfigAsset.completed = function(asset)
        local textAsset = self.resConfigAsset.asset
        cast(textAsset, typeof(CS.UnityEngine.TextAsset))
        local resConfig = rapidjson.decode(textAsset.text) or {}

        -- 创建所有资源点数据
        for _, cfg in ipairs(resConfig.res_list) do
            if not battleLevel:IsBeRemove(cfg.id) then
                local cp = CollectionData.New(cfg, self)---@type Scene.PVEBattleLevel.CollectionData
                self.collectionDataDict[cfg.id] = cp
                battleLevel:AddObj(cfg.id, cp)
            end
        end

        -- 表现数据分区
        local chunks = self.chunks
        for _, cfg in ipairs(resConfig.res_list )do
            if not battleLevel:IsBeRemove(cfg.id) and cfg.type ~= Const.CityCutResType.lwWayPoint then
                local tilePos = SceneUtils.WorldToTile(cfg.t)
                local chunkIndex = self:TilePosToChunkIndex(tilePos.x, tilePos.y)
                local list = chunks[chunkIndex]
                if list == nil then
                    list = {}
                    chunks[chunkIndex] = list
                end
                list[#list + 1] = cfg
            end
        end

        self.lastViewIndex = -1
        self.resConfigAsset:Release()
        self.resConfigAsset = nil

        if battleLevel.LoadCollectionFinish ~= nil then
            battleLevel:LoadCollectionFinish()
        end
    end
end

---@param battleLevel DataCenter.ZombieBattle.ZombieBattleManager
function CollectionManager:InitLW(battleLevel)
    self.battleLevel = battleLevel
    self.lastViewIndex = -1
    self.chunks = {}
    self.createList = {}
    self.collectionObjDict = {}
    self.collectionDataDict = {}
    self.cutUpdateDict = {}
    self.pointIdDic = {}
    self.slowUpdateTimer = TimerManager:GetInstance():GetTimer(1, function() self:OnSlowUpdate() end, nil, false, false, false)
    self.slowUpdateTimer:Start()
    self.reqs = {}
    self.idSeed = 1
    self.lastViewIndex = -1
    self.loaderCtx = nil
end

function CollectionManager:AppendConfig(collectionConfig,offset,sceneMeta)

    local context = {}
    context.offset = offset
    context.collectionConfig = collectionConfig
    context.sceneMeta = sceneMeta
    
    
    if(self.resConfigAsset ~= nil) then
        table.insert(self.reqs,context)
        return
    end

    self.resConfigAsset = Resource:LoadAssetAsync(collectionConfig, typeof(CS.UnityEngine.TextAsset))
    self.loaderCtx = context
    
    self.resConfigAsset.completed = function(asset)
        local battleLevel = self.battleLevel
        local textAsset = self.resConfigAsset.asset
        cast(textAsset, typeof(CS.UnityEngine.TextAsset))
        local resConfig = rapidjson.decode(textAsset.text) or {}

        -- 创建所有资源点数据
        for _, cfg in ipairs(resConfig.res_list) do
            cfg.id = self:GetId()
            cfg.t = cfg.t + Vector3.New(0,0,self.loaderCtx.offset)
            if(cfg.type == Const.CityCutResType.lwWayPoint and battleLevel.AddWayPoint ~= nil) then
                battleLevel:AddWayPoint(cfg,self.loaderCtx.sceneMeta)
            elseif cfg.type == Const.CityCutResType.lwMonsterPoint  then
                battleLevel:AddMonsterPoint(cfg,self.loaderCtx.sceneMeta)
            elseif cfg.type == Const.CityCutResType.lwBlockPoint  then
                battleLevel:AddBlockPoint(cfg,self.loaderCtx.sceneMeta)
            elseif not battleLevel:IsBeRemove(cfg.id) then
                local cp = CollectionData.New(cfg, self)---@type Scene.PVEBattleLevel.CollectionData
                self.collectionDataDict[cfg.id] = cp
                battleLevel:AddObj(cfg.id, cp)
            end
        end

        -- 表现数据分区
        local chunks = self.chunks
        for _, cfg in ipairs(resConfig.res_list )do
            if not battleLevel:IsBeRemove(cfg.id) 
                    and cfg.type ~= Const.CityCutResType.lwWayPoint 
                    and cfg.type ~= Const.CityCutResType.lwMonsterPoint
                    and cfg.type ~= Const.CityCutResType.lwBlockPoint then
                local tilePos = SceneUtils.WorldToTile(cfg.t)
                local chunkIndex = self:TilePosToChunkIndex(tilePos.x, tilePos.y)
                local list = chunks[chunkIndex]
                if list == nil then
                    list = {}
                    chunks[chunkIndex] = list
                end
                list[#list + 1] = cfg
            end
        end

        self.resConfigAsset:Release()
        self.resConfigAsset = nil
        self.loaderCtx = nil
        if(#self.reqs > 0) then
            for idx, ctx in ipairs(self.reqs)do
                self.loaderCtx = ctx
                self:AppendConfig(ctx.collectionConfig,ctx.offset,ctx.sceneMeta)
                table.remove(self.reqs,idx)
                return
            end
        end
     
        if battleLevel.LoadCollectionFinish ~= nil then
            battleLevel:LoadCollectionFinish()
        end
    end

    --req.completed = function(asset)
    --    
    --end
end

function CollectionManager:GetId()
    self.idSeed = self.idSeed + 1
    return self.idSeed
end

function CollectionManager:OnUpdate(viewX, viewY)
    self:UpdateCollection()
    self:UpdateView(viewX, viewY)
end

function CollectionManager:OnSlowUpdate()
    local serverSeconds = UITimeManager:GetInstance():GetServerSeconds()
    for _, i in pairs(self.collectionDataDict) do
        i:CheckRecover(serverSeconds)
    end
end

function CollectionManager:UpdateView(viewX, viewY)
    local viewChunkIndex = self:TilePosToChunkIndex(viewX, viewY)
    local createList = self.createList
    local collectionObjDict = self.collectionObjDict
    
    if self.lastViewIndex ~= viewChunkIndex then
        self.lastViewIndex = viewChunkIndex

        local viewChunkX, viewChunkY = self:TilePosToChunkCoord(viewX, viewY)

        local minX = viewChunkX - VisibleChunkRange
        local maxX = viewChunkX + VisibleChunkRange
        local minY = viewChunkY - VisibleChunkRange
        local maxY = viewChunkY + VisibleChunkRange

        -- 销毁超出范围的物体
        for k, o in pairs(collectionObjDict) do
            local objTilePos = o:GetTilePos()
            local chunkX, chunkY = self:TilePosToChunkCoord(objTilePos.x, objTilePos.y)
            if chunkX < minX or chunkX > maxX or chunkY < minY or chunkY > maxY then
                collectionObjDict[k] = nil
                self:RemoveOnePointId(o)
                o:Destroy()
            end
        end
        
        for k, config in pairs(createList) do
            local objTilePos = SceneUtils.WorldToTile(config.t)
            local chunkX, chunkY = self:TilePosToChunkCoord(objTilePos.x, objTilePos.y)
            if chunkX < minX or chunkX > maxX or chunkY < minY or chunkY > maxY then
                createList[k] = nil
            end
        end

        -- 显示进入视野范围的物体
        for y = -VisibleChunkRange, VisibleChunkRange, 1 do
            for x = -VisibleChunkRange, VisibleChunkRange, 1 do
                local chunkX, chunkY = viewChunkX + x, viewChunkY + y
                local list = self:GetChunkObjList(chunkX, chunkY)
                if list then
                    for _, config in ipairs(list) do
                        if collectionObjDict[config.id] == nil and createList[config.id] == nil then
                            createList[config.id] = config
                        end
                    end
                end
            end
        end
    end

    -- 分帧创建
    local count = 0
    for id, config in pairs(createList) do
        createList[id] = nil
        local o = CollectionObject.New(config, self:GetCollectionData(config.id), self.battleLevel)
        if collectionObjDict[id] == nil then
            o:Create()
            collectionObjDict[id] = o
            self:AddOnePointId(o)
            count = count + 1
            if count > CreateCountPerFrame then
                break
            end
        end
    end
end

function CollectionManager:UpdateCollection()
    local now = Time.time
    for k, i in pairs(self.cutUpdateDict) do
        i.obj:OnUpdate()
        if now > i.endUpdateTime then
            self.cutUpdateDict[k] = nil
        end
    end
end

-- 添到的Update列表，用于被砍后更新碎石的旋转
function CollectionManager:AddCutUpdate(configId, obj)
    local update = self.cutUpdateDict[configId]
    if update == nil then
        self.cutUpdateDict[configId] = {
            endUpdateTime = Time.time + 3,
            obj = obj
        }
    else
        update.endUpdateTime = Time.time + 3
    end
end

--销毁后从update列表中移除
function CollectionManager:RemoveCutUpdate(configId)
    self.cutUpdateDict[configId] = nil
end

function CollectionManager:Destroy()
    for _, v in pairs(self.collectionObjDict) do
        v:Destroy()
    end
    for _, i in pairs(self.collectionDataDict) do
        i:Destroy()
    end

    self.reqs = nil
    
    if self.resConfigAsset then
        self.resConfigAsset:Release()
        self.resConfigAsset.completed = nil
        self.resConfigAsset = nil
    end
    self.createList = {}
    self.collectionObjDict = {}
    self.collectionDataDict = {}
    self.chunks = {}
    self.cutUpdateDict = {}
    self.lastViewIndex = -1
    if self.slowUpdateTimer then
        self.slowUpdateTimer:Stop()
        self.slowUpdateTimer = nil
    end
end

function CollectionManager:GetCollectionObject(configId)
    return self.collectionObjDict[configId]
end

function CollectionManager:TilePosToChunkCoord(x, y)
    return math.floor(x / TileCountPerChunk), math.floor(y / TileCountPerChunk)
end

function CollectionManager:TilePosToChunkIndex(x, y)
    local chunkX, chunkY = math.floor(x / TileCountPerChunk), math.floor(y / TileCountPerChunk)
    return chunkY * MapChunkSize + chunkX + 1
end

function CollectionManager:GetChunkObjList(chunkX, chunkY)
    local chunkIndex = chunkY * MapChunkSize + chunkX + 1
    return self.chunks[chunkIndex]
end

function CollectionManager:GetCollectionData(configId)
    return self.collectionDataDict[configId]
end

function CollectionManager:RefreshCameraRotation(rotation)
    for k,v in pairs(self.collectionObjDict) do
        v:RefreshCameraRotation(rotation)
    end
end

function CollectionManager:GetCollectList(pointId)
    local list = self.pointIdDic[pointId]
    if list ~= nil then
        local result = {}
        for k,v in pairs(list) do
            if v:CanCollect() then
                table.insert(result, v)
            end
        end
        if #result > 0 then
            return result
        end
    end
end

function CollectionManager:GetWalkList(pointId)
    local list = self.pointIdDic[pointId]
    if list ~= nil then
        local result = {}
        for k,v in pairs(list) do
            if v:NeedCheckCollider() then
                table.insert(result, v)
            end
        end
        if #result > 0 then
            return result
        end
    end
end
function CollectionManager:AddOnePointId(obj)
    if obj ~= nil then
        local pointId = obj.pointId
        if self.pointIdDic[pointId] == nil then
            self.pointIdDic[pointId] = {}
        end
        self.pointIdDic[pointId][obj:GetObjId()] = obj
    end
end
function CollectionManager:RemoveOnePointId(obj)
    if obj ~= nil then
        local pointId = obj.pointId
        local id = obj:GetObjId()
        if self.pointIdDic[pointId] ~= nil and self.pointIdDic[pointId][id] ~= nil then
            self.pointIdDic[pointId][id] = nil
        end
    end
end

--canChange  是否允许调整位置（只调整一次）
function CollectionManager:CheckWalkPos(pos, forward, speed, canChange)
    local willPos = pos + forward * speed
    if self:CanWalk(willPos) then
        return canChange, forward
    elseif canChange then
        --不能走判断切线
        local newForward = forward * RightQuaternion
        willPos = pos + newForward * speed
        if self:CanWalk(willPos) then
            return false, newForward
        else
            newForward = forward * LeftQuaternion
            willPos = pos + newForward * speed
            if self:CanWalk(willPos) then
                return false, newForward
            end
        end
    end
    return false, nil
end

function CollectionManager:CanWalk(pos)
    local pointId = SceneUtils.WorldToTileIndex(pos)
    --取9个方向格子
    for x = -1, 1, 1 do
        for y = -1, 1, 1 do
            local list = self:GetWalkList(SceneUtils.GetIndexByOffset(pointId,x,y))
            if list ~= nil then
                for k, v in ipairs(list) do
                    local newPos = v:GetPosition()
                    local dis = Vector3.Distance(newPos, pos)
                    local collectRadius = v:GetCollectRadius()
                    if dis <= collectRadius then
                        return false
                    end
                end
            end
        end
    end
    return true
end



return CollectionManager