---
--- Created by shimin.
--- DateTime: 2021/7/5 19:21
---
local BuildQueueTemplateManager = BaseClass("BuildQueueTemplateManager")
local BuildQueueTemplate = require "DataCenter.BuildQueueManager.BuildQueueTemplate"

function BuildQueueTemplateManager:__init()
    self.buildQueueTemplateDic = {}
    self.indexList = {}
end
function BuildQueueTemplateManager:__delete()
    self.buildQueueTemplateDic = {}
    self.indexList = {}
end

function BuildQueueTemplateManager:InitAllTemplate()
    self.buildQueueTemplateDic = {}
    self.indexList = {}
    local tableData = LocalController:instance():getTable(self:GetTableName())
    if tableData ~= nil then
        local indexList = tableData.index
        for k, v in pairs(tableData.data) do
            self:AddOneTemplate(indexList, v)
        end
    end
end

function BuildQueueTemplateManager:AddOneTemplate(indexList, row)
    local item = BuildQueueTemplate:New(indexList, row)
    if item.id ~= nil then
        self.buildQueueTemplateDic[item.id] = item
        self.indexList[item.order] = item
    end
end

function BuildQueueTemplateManager:GetTableName()
    return TableName.Robot
end

function BuildQueueTemplateManager:IsSeasonRobot(id)
    return false
end

function BuildQueueTemplateManager:GetBuildQueueTemplate(id)
    local intId = tonumber(id)
    if self.buildQueueTemplateDic[intId] == nil then
        local tableData = LocalController:instance():getTable(self:GetTableName())
        if tableData ~= nil then
            if tableData.data[intId] ~= nil then
                self:AddOneTemplate(tableData.index, tableData.data[intId])
            end
        end
    end
    return self.buildQueueTemplateDic[intId]
end

function BuildQueueTemplateManager:GetBuildQueueTemplateByIndex(index)
    return self.indexList[index]
end

return BuildQueueTemplateManager
