---
--- Created by shimin.
--- DateTime: 2021/8/18 12:12
---
local GuideTemplateManager = BaseClass("GuideTemplateManager")
local GuideTemplate = require "DataCenter.GuideManager.GuideTemplate"

local function __init(self)
    self.guideTemplateDic ={}
    self.useTabName = nil
end

local function __delete(self)
    self.guideTemplateDic =nil
    self.useTabName = nil
end

local function InitAllTemplate(self,triggerTable)
    if triggerTable == nil then
        triggerTable = {}
    end
    
    LocalController:instance():visitTable(self:GetTableName(),function(id,lineData)
        local item = GuideTemplate.New()
        item:InitData(lineData)
        if item.id ~=nil then
            self.guideTemplateDic[item.id] = item
            if triggerTable[item.triggertype] == nil then
                triggerTable[item.triggertype] = {}
            end
            if item.triggerpara ~= nil and item.triggerpara ~= "" then
                triggerTable[item.triggertype][item.triggerpara] = item.id
            end
        end
    end)
end

local function GetGuideTemplate(self,id)
    if self.guideTemplateDic[tonumber(id)] == nil then
        local oneTemplate = LocalController:instance():getLine(self:GetTableName(),tostring(id))
        if oneTemplate ~= nil then
            local item = GuideTemplate.New()
            item:InitData(oneTemplate)
            if item.id ~=nil then
                self.guideTemplateDic[item.id] = item
            end
        end
    end
    return self.guideTemplateDic[tonumber(id)]
end

local function GetTableName(self)
    if self.useTabName == nil then
        self.useTabName = LuaEntry.Player:GetABTestTableName(TableName.Guide)
    end
    return self.useTabName
end

GuideTemplateManager.__init = __init
GuideTemplateManager.__delete = __delete
GuideTemplateManager.InitAllTemplate = InitAllTemplate
GuideTemplateManager.GetGuideTemplate = GetGuideTemplate
GuideTemplateManager.GetTableName = GetTableName

return GuideTemplateManager
