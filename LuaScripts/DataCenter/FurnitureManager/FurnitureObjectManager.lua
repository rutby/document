--- Created by shimin.
--- DateTime: 2023/11/9 10:29
--- 家具预制体管理器

local FurnitureObjectManager = BaseClass("FurnitureObjectManager")
local FurnitureObject = require "Scene.FurnitureObject.FurnitureObject"
local FurnitureFakeObject = require "Scene.FurnitureObject.FurnitureFakeObject"

function FurnitureObjectManager:__init()
    self.allObject = {}--所有家具<uuid, object>
    self.furnitureTransformDic = {}--<bUuid, dic<int, Transform>>
    self.selectMeshList = {}--选择高亮的家具
    self.waitSelectUuid = 0--等待加载中的模型
    self.wallTransformDic = {}--<bUuid, dic<string, Transform>>
    self.fakeObj = nil--0级假的家具
    self:AddListener()
end

function FurnitureObjectManager:__delete()
    self.allObject = {}--所有家具<uuid, object>
    self.furnitureTransformDic = {}--<bUuid, dic<int, Transform>>
    self.selectMeshList = {}--选择高亮的家具
    self.waitSelectUuid = 0--等待加载中的模型
    self.wallTransformDic = {}--<bUuid, dic<string, Transform>>·
    self.fakeObj = nil--0级假的家具
    self:RemoveListener()
end

function FurnitureObjectManager:Startup()
end


function FurnitureObjectManager:AddListener()
    --if self.showFurnitureSignal == nil then
    --    self.showFurnitureSignal = function(bUuid)
    --        self:ShowFurnitureSignal(bUuid)
    --    end
    --    EventManager:GetInstance():AddListener(EventId.ShowFurniture, self.showFurnitureSignal)
    --end
    --if self.hideFurnitureSignal == nil then
    --    self.hideFurnitureSignal = function(bUuid)
    --        self:HideFurnitureSignal(bUuid)
    --    end
    --    EventManager:GetInstance():AddListener(EventId.HideFurniture, self.hideFurnitureSignal)
    --end
    if self.refreshFurnitureSignal == nil then
        self.refreshFurnitureSignal = function(uuid)
            self:RefreshFurnitureSignal(uuid)
        end
        EventManager:GetInstance():AddListener(EventId.RefreshFurniture, self.refreshFurnitureSignal)
    end
end


function FurnitureObjectManager:RemoveListener()
    --if self.showFurnitureSignal ~= nil then
    --    EventManager:GetInstance():RemoveListener(EventId.ShowFurniture, self.showFurnitureSignal)
    --    self.showFurnitureSignal = nil
    --end
    --if self.hideFurnitureSignal ~= nil then
    --    EventManager:GetInstance():RemoveListener(EventId.HideFurniture, self.hideFurnitureSignal)
    --    self.hideFurnitureSignal = nil
    --end
    if self.refreshFurnitureSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.RefreshFurniture, self.refreshFurnitureSignal)
        self.refreshFurnitureSignal = nil
    end
end

--显示家具
function FurnitureObjectManager:ShowFurnitureSignal(bUuid)
    self:ShowOneBuildFurniture(bUuid)
end

--隐藏家具
function FurnitureObjectManager:HideFurnitureSignal(bUuid)
    self:HideOneBuildFurniture(bUuid)
end

--显示一个建筑的家具
function FurnitureObjectManager:ShowOneBuildFurniture(bUuid)
    self:HideOneBuildFurniture(bUuid)--这里必须删掉，更新建筑预制体旧的删除没消息，不删就是野指针
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData then
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
        if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
            local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
            if city ~= nil then
                local parentDic = city:GetFurnitureDic()
                self.furnitureTransformDic[bUuid] = parentDic
                if city.GetWallDic ~= nil then
                    --这里为了效率，不保存原始数据
                    self.wallTransformDic[bUuid] = {}
                    local tran = city:GetWallDic()
                    if tran ~= nil then
                        for k, v in pairs(tran) do
                            local renders = v.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
                            self.wallTransformDic[bUuid][k] = {}
                            if renders ~= nil and renders.Length > 0 then
                                for i = 0, renders.Length -1, 1 do
                                    table.insert(self.wallTransformDic[bUuid][k], renders[i])
                                end
                            end
                        end
                    end
                    DataCenter.BuildWallEffectManager:RefreshOneWallEffect(bUuid)
                end
                local showSundry = {}
                local sundry = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildData.itemId + buildData.level,"sundry", {})
                --不填默认全部隐藏
                for k, v in ipairs(sundry) do
                    showSundry[v] = true
                end
                if city.GetSundryDic ~= nil then
                    local tran = city:GetSundryDic()
                    for k, v in pairs(tran) do
                        if showSundry[k] then
                            v:SetActive(true)
                        else
                            v:SetActive(false)
                        end
                    end
                end
                
                local list = DataCenter.FurnitureManager:GetFurnitureListByBUuid(bUuid)
                if list ~= nil then
                    for k, v in ipairs(list) do
                        local obj = self.allObject[v.uuid]
                        if obj == nil then
                            local modelIndex = levelTemplate:GetFurnitureModelIndex(v.fId, v.index)
                            if parentDic:ContainsKey(modelIndex) then
                                local param = {}
                                param.visible = true
                                param.uuid = v.uuid
                                param.parent = parentDic[modelIndex]
                                local script = FurnitureObject.New(param)
                                self.allObject[v.uuid] = script
                            end
                        else
                            obj:SetVisible(true)
                        end
                    end
                end
            end
        end
    end
end

--隐藏一个建筑的家具
function FurnitureObjectManager:HideOneBuildFurniture(bUuid)
    local list = DataCenter.FurnitureManager:GetFurnitureListByBUuid(bUuid)
    if list ~= nil then
        DataCenter.BuildWallEffectManager:RemoveOneWallEffect(bUuid)
        for k, v in ipairs(list) do
            local obj = self.allObject[v.uuid]
            if obj ~= nil then
                obj:Destroy()
            end
            self.allObject[v.uuid] = nil
        end
        self.furnitureTransformDic[bUuid] = nil
        self.wallTransformDic[bUuid] = nil
    end
end

function FurnitureObjectManager:GetWorldPositionByFurnitureUuid(fUuid)
    local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(fUuid)
    if furnitureInfo ~= nil then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(furnitureInfo.bUuid)
        if buildData ~= nil then
            local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
            local modelIndex = levelTemplate:GetFurnitureModelIndex(furnitureInfo.fId, furnitureInfo.index)
            return self:GetWorldPositionByBuildUuidAndIndex(furnitureInfo.bUuid, modelIndex)
        end
    end
    return Vector3.zero
end

function FurnitureObjectManager:GetTransformByFurnitureUuid(fUuid)
    local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByUuid(fUuid)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(furnitureInfo.bUuid)
    if buildData ~= nil then
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
        if levelTemplate ~= nil then
            local modelIndex = levelTemplate:GetFurnitureModelIndex(furnitureInfo.fId, furnitureInfo.index)
            return self:GetTransformByBuildUuidAndIndex(furnitureInfo.bUuid, modelIndex)
        end
    end
    return nil
end

--通过主建筑uuid和家具index来获得家具集体位置
function FurnitureObjectManager:GetWorldPositionByBuildUuidAndIndex(bUuid, modelIndex)
    local dic = self.furnitureTransformDic[bUuid]
    if dic ~= nil and dic:ContainsKey(modelIndex) then
        local trans = dic[modelIndex]
        if trans ~= nil then
            return trans.position
        end
    end
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil then
        return buildData:GetCenterVec()
    end
    return nil
end

--通过主建筑uuid和家具index来获得家具Transform
function FurnitureObjectManager:GetTransformByBuildUuidAndIndex(bUuid, modelIndex)
    local dic = self.furnitureTransformDic[bUuid]
    if dic ~= nil and dic:ContainsKey(modelIndex) then
        return dic[modelIndex]
    end
    return nil
end

--更新一个家具信息
function FurnitureObjectManager:RefreshFurnitureSignal(uuid)
    local obj = self.allObject[uuid]
    if obj == nil then
        local furnitureData = DataCenter.FurnitureManager:GetFurnitureByUuid(uuid)
        if furnitureData ~= nil then
            local parentDic = self.furnitureTransformDic[furnitureData.bUuid]
            if parentDic ~= nil then
                local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(furnitureData.bUuid)
                if buildData ~= nil then
                    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
                    if levelTemplate ~= nil then
                        local modelIndex = levelTemplate:GetFurnitureModelIndex(furnitureData.fId, furnitureData.index)
                        if parentDic:ContainsKey(modelIndex) then
                            local param = {}
                            param.visible = true
                            param.uuid = uuid
                            param.parent = parentDic[modelIndex]
                            local script = FurnitureObject.New(param)
                            self.allObject[uuid] = script
                        end
                    end
                end
            end
        end
    else
        --更新
        obj:Refresh()
    end
end

--高亮家具
function FurnitureObjectManager:SelectObject(uuid)
    self:CancelSelectObject()
    self.waitSelectUuid = uuid
    local obj = self:GetObjectByUuid(uuid)
    if obj ~= nil then
        if obj.gameObject ~= nil then
            self.selectMeshList = {}
            local renders = obj.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
            if renders ~= nil and renders.Length > 0 then
                for i = 0, renders.Length -1, 1 do
                    table.insert(self.selectMeshList, renders[i])
                end
            end
            DataCenter.ShaderEffectManager:AddOneFurnitureFlashEffect(self.selectMeshList)
        end
    end
end
--取消高亮家具
function FurnitureObjectManager:CancelSelectObject()
    if self.selectMeshList[1] ~= nil then
        DataCenter.ShaderEffectManager:RemoveOneFurnitureFlashEffect(self.selectMeshList)
        self.selectMeshList = {}
    end
    self.waitSelectUuid = 0
end

function FurnitureObjectManager:GetObjectByUuid(uuid)
    return self.allObject[uuid]
end

function FurnitureObjectManager:CheckSelectObj(uuid)
    if self.waitSelectUuid == uuid then
        self:SelectObject(uuid)
    end
end

function FurnitureObjectManager:GetBuildWall(uuid)
    return self.wallTransformDic[uuid]
end

function FurnitureObjectManager:AddOneFakeObj(bUuid, fId, index)
    self:DestroyOneFakeObj()
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
    if buildData ~= nil then
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
        if levelTemplate ~= nil then
            local param = {}
            param.visible = true
            param.fId = fId
            local modelIndex = levelTemplate:GetFurnitureModelIndex(fId, index)
            param.parent = self:GetTransformByBuildUuidAndIndex(bUuid, modelIndex)
            local script = FurnitureFakeObject.New(param)
            self.fakeObj = script
        end
    end
end

function FurnitureObjectManager:DestroyOneFakeObj()
    if self.fakeObj ~= nil then
        self.fakeObj:Destroy()
        self.fakeObj = nil
    end
end

function FurnitureObjectManager:SetFurnitureVisible(bUuid, visible)
    local dic = self.furnitureTransformDic[bUuid]
    if dic ~= nil then
        for k,v in pairs(dic) do
            v.gameObject:SetActive(visible)
        end
    end
end

return FurnitureObjectManager
