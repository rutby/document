---
--- Created by shimin.
--- DateTime: 2021/7/1 16:19
---
local ArmyTemplateManager = BaseClass("ArmyTemplateManager")
local ArmyTemplate = require "DataCenter.ArmyManager.ArmyTemplate"

function ArmyTemplateManager:__init()
    self.armyTemplateDic ={}
    self.armyToMercenaryIdDict = {}
    self.initedAll = false
end

function ArmyTemplateManager:__delete()
    self.armyTemplateDic ={}
    self.armyToMercenaryIdDict = {}
    self.initedAll = false
end

function ArmyTemplateManager:InitAllTemplates()
    self.initedAll = true
    self.armyTemplateDic = {}
    local tableData = LocalController:instance():getTable(self:GetTableName())
    if tableData ~= nil then
        local indexList = tableData.index
        for k, v in pairs(tableData.data) do
            local item = ArmyTemplate:New(indexList, v)
            if item.id ~= nil then
                self.armyTemplateDic[item.id] = item
            end
        end
    end
end

function ArmyTemplateManager:GetArmyTemplate(id)
    local intId = tonumber(id)
    if self.armyTemplateDic[intId] == nil then
        local tableData = LocalController:instance():getTable(self:GetTableName())
        if tableData ~= nil then
            if tableData.data[intId] ~= nil then
                local item = ArmyTemplate:New(tableData.index, tableData.data[intId])
                if item.id ~= nil then
                    self.armyTemplateDic[item.id] = item
                end
            end
        end
    end
    return self.armyTemplateDic[intId]
end

-- 士兵id => 雇佣兵id
function ArmyTemplateManager:ArmyToMercenaryId(id)
    id = tonumber(id)
    if not self.initedAll then
        self:InitAllTemplates()
    end
    if self.armyToMercenaryIdDict[id] == nil then
        local template = self:GetArmyTemplate(id)
        if template then
            for _, t in pairs(self.armyTemplateDic) do
                if t:IsMercenary() and t.arm == template.arm and t.level == template.level and t.direction == template.direction then
                    self.armyToMercenaryIdDict[id] = t.id
                    break
                end
            end
        end
    end
    return self.armyToMercenaryIdDict[id]
end

function ArmyTemplateManager:GetTableName()
    return TableName.ArmsTab
end

return ArmyTemplateManager
