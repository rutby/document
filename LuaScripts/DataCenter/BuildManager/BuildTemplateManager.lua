--- Created by shimin.
--- DateTime: 2021/5/10 19:04
--- 建筑表管理器
local BuildTemplateManager = BaseClass("BuildTemplateManager")
local BuildingDesTemplate = require "DataCenter.BuildManager.BuildingDesTemplate"
local BuildingLevelTemplate = require "DataCenter.BuildManager.BuildingLevelTemplate"
local LevelUpTemplate = require "DataCenter.BuildManager.LevelUpTemplate"

function BuildTemplateManager:__init()
    self.buildDesTemplateDic = {}--建筑基本信息
    self.buildLevelTemplateDic = {}--建筑等级
    self.levelUpDic = {}--升级解锁表
    self.useDesTableName = nil
    self.useTableName = nil
    self.isAllTrans = false
    self.isAllDesTrans = false
end

function BuildTemplateManager:__delete()
    self.buildDesTemplateDic = {}--建筑基本信息
    self.buildLevelTemplateDic = {}--建筑等级
    self.levelUpDic = {}--升级解锁表
    self.useDesTableName = nil
    self.useTableName = nil
    self.isAllTrans = false
    self.isAllDesTrans = false
end

--获得建筑种类信息  id:建筑类型
function BuildTemplateManager:GetBuildingDesTemplate(id)
    if id == nil then
        Logger.LogError("shimin --------------------- GetBuildingDesTemplate stringId == 0")
    end
    local intId = tonumber(id)
    if self.buildDesTemplateDic[intId] == nil then
        local tableData = LocalController:instance():getTable(self:GetDesTableName())
        if tableData ~= nil then
            if tableData.data[intId] ~= nil then
                local item = BuildingDesTemplate:New(tableData.index, tableData.data[intId])
                if item.id ~= nil then
                    self.buildDesTemplateDic[item.id] = item
                end
            end
        end
    end
    return self.buildDesTemplateDic[intId]
end

--获得建筑对应等级信息 buildId:建筑种类 level:建筑等级（等级 > 0）
function BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if buildId == nil then
        Logger.LogError("shimin --------------------- GetBuildingLevelTemplate stringId == 0")
    end
    local intId = tonumber(buildId)
    local id = intId + level
    if self.buildLevelTemplateDic[id] == nil then
        local tableData = LocalController:instance():getTable(self:GetTableName())
        if tableData ~= nil then
            if tableData.data[id] ~= nil then
                local item = BuildingLevelTemplate:New(tableData.index, tableData.data[id])
                if item.id ~= nil then
                    self.buildLevelTemplateDic[item.id] = item
                end
            end
        end
    end
    return self.buildLevelTemplateDic[id]
end

function BuildTemplateManager:TransAllBuildingDesTemplate()
    self.isAllDesTrans = true
    self.buildDesTemplateDic = {}
    local tableData = LocalController:instance():getTable(self:GetDesTableName())
    if tableData ~= nil then
        local indexList = tableData.index
        for k, v in pairs(tableData.data) do
            local item = BuildingDesTemplate:New(indexList, v)
            if item.id ~= nil then
                self.buildDesTemplateDic[item.id] = item
            end
        end
    end
end

function BuildTemplateManager:GetAllBuildTileByItemId()
    if not self.isAllDesTrans then
        self:TransAllBuildingDesTemplate()
    end
    local list ={}
    for k,v in pairs(self.buildDesTemplateDic) do
        local item = {}
        item.itemId = v.id
        item.tiles = v.tiles
        table.insert(list,item)
    end
    return list
end

--获得建筑解锁信息
function BuildTemplateManager:GetLevelUpTemplate(id)
    if self.levelUpDic[tonumber(id)]== nil then
        local oneTemplate = LocalController:instance():getLine(TableName.LevelUp,tostring(id))
        if oneTemplate~=nil then
            local item  = LevelUpTemplate.New()
            item:InitData(oneTemplate)
            if item.id ~=nil then
                self.levelUpDic[item.id] = item
            end
        end
    end
    return self.levelUpDic[tonumber(id)]
end

function BuildTemplateManager:GetTableName()
    if self.useTableName == nil then
        if LuaEntry.Player ~= nil then
            self.useTableName = LuaEntry.Player:GetABTestTableName(TableName.Building)
        else
            self.useTableName = TableName.Building
        end
    end
    return self.useTableName
end

function BuildTemplateManager:GetDesTableName()
    if self.useDesTableName == nil then
        if LuaEntry.Player ~= nil then
            self.useDesTableName = LuaEntry.Player:GetABTestTableName(TableName.BuildingDes)
        else
            self.useDesTableName = TableName.BuildingDes
        end
    end
    return self.useDesTableName
end

function BuildTemplateManager:GetAllBuildingDesTemplate()
    if not self.isAllDesTrans then
        self:TransAllBuildingDesTemplate()
    end
    return self.buildDesTemplateDic
end

function BuildTemplateManager:GetBuildMaxLevel(buildDesTemplate)
    if buildDesTemplate and buildDesTemplate.GetBuildMaxLevel then
        return buildDesTemplate:GetBuildMaxLevel()
    else
        return 0
    end
end

return BuildTemplateManager
