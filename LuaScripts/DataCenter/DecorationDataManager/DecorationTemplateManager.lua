---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/12/5 10:38
---


local DecorationTemplateManager = BaseClass("DecorationTemplateManager")
local DecorationTemplate = require "DataCenter.DecorationDataManager.DecorationTemplate"

function DecorationTemplateManager:__init()
    self.templateDic = nil
    self.decorationItems = {}
    self.useTableName = nil
end

function DecorationTemplateManager:__delete()
    self.templateDic = nil
    self.decorationItems = {}
    self.useTableName = nil
end

function DecorationTemplateManager:InitAllTemplate()
    self.templateDic = {}
    LocalController:instance():visitTable(self:GetTableName(), function(id, lineData)
        self:AddOneTemplate(lineData)
    end)
end

function DecorationTemplateManager:GetTableName()
    if self.useTableName == nil then
        self.useTableName = TableName.Decoration
    end
    return self.useTableName
end

function DecorationTemplateManager:GetAllTemplate()
    if self.templateDic == nil then
        self:InitAllTemplate()
    end
    return self.templateDic
end

function DecorationTemplateManager:GetTemplate(id)
    if self.templateDic == nil then
        self:InitAllTemplate()
    end
    return self.templateDic[tonumber(id)]
end

function DecorationTemplateManager:GetAllTypes() 
    local result = {}
    local all = self:GetAllTemplate()
    local tmp = {}
    for _, v in pairs(all) do
        tmp[v.type] = 1
    end
    result = table.keys(tmp)
    table.sort(result, function (k, v)
        return k < v
    end)
    return result
end

function DecorationTemplateManager:GetTypeDecorations(type)
    local result = {}
    local all = self:GetAllTemplate()
    for k, v in pairs(all) do
        if v.type == type then
            table.insert(result, v)
        end
    end
    return result
end

function DecorationTemplateManager:GetDecorationItem()
    local all = self:GetAllTemplate()
    for _, template in pairs(all) do
        local methods = template.gainMethod
        for _, v in pairs(methods) do
            self.decorationItems[v.id] = 1
        end
    end
    return self.decorationItems
end

function DecorationTemplateManager:AddOneTemplate(oneTemplate)
    if oneTemplate ~= nil then
        local item = DecorationTemplate.New()
        item:InitData(oneTemplate)
        self.templateDic[item.id] = item
    end
end


return DecorationTemplateManager