---
--- Created by zzl.
--- DateTime: 
---
local WorldTrendTemplateManager = BaseClass("WorldTrendTemplateManager", Singleton);
local WorldTrendTemplate = require "DataCenter.WorldTrendManager.WorldTrendTemplate"
local WorldTrendFuncTemplate = require "DataCenter.WorldTrendManager.WorldTrendFuncTemplate"
local function __init(self)
    self.tempDict ={}
    self.funcDict = {}
end

local function __delete(self)
    self.tempDict =nil
    self.funcDict =nil
end

local function InitAllTemplate(self)
    LocalController:instance():visitTable(TableName.Trends,function(id,lineData)
        local item = WorldTrendTemplate.New()
        item:InitData(lineData)
        if self.tempDict[item.id] == nil then
            self.tempDict[item.id] = item
        end
    end)
end

local function GetTemplateById(self, id)
    if #self.tempDict == 0 then
        self:InitAllTemplate()
    end
    return self.tempDict[tonumber(id)]
end

local function InitFuncTemplate(self)
    LocalController:instance():visitTable(TableName.TrendsFunction,function(id,lineData)
        local item = WorldTrendFuncTemplate.New()
        item:InitData(lineData)
        if self.funcDict[item.id] == nil then
            self.funcDict[item.id] = item
        end
    end)
end

local function GetFuncInfoById(self, id)
    if #self.funcDict == 0 then
        self:InitFuncTemplate()
    end
    return self.funcDict[tonumber(id)]
end


WorldTrendTemplateManager.__init = __init
WorldTrendTemplateManager.__delete = __delete
WorldTrendTemplateManager.InitAllTemplate = InitAllTemplate
WorldTrendTemplateManager.GetTemplateById = GetTemplateById
WorldTrendTemplateManager.InitFuncTemplate = InitFuncTemplate
WorldTrendTemplateManager.GetFuncInfoById = GetFuncInfoById

return WorldTrendTemplateManager
