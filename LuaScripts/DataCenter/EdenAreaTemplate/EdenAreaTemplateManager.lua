---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/7/25 11:46
---
local EdenAreaTemplateManager = BaseClass("EdenAreaTemplateManager");
local EdenAreaTemplate = require "DataCenter.EdenAreaTemplate.EdenAreaTemplate"

local function __init(self)
    self.templateDict = nil
end

local function __delete(self)
    self.templateDict = nil
end

local function Startup(self)

end

local function InitTemplateDict(self)
    self.templateDict = {}
    local tableData = LocalController:instance():getTable(TableName.EdenArea)
    if tableData~=nil then
        local indexList = tableData.index
        for k, v in pairs(tableData.data) do
            local item = EdenAreaTemplate:New(indexList, v)
            if item.id ~= nil then
                self.templateDict[item.id] = item
            end
        end
    end
end

local function GetTemplate(self, id)
    return self.templateDict[id]
end

local function GetAllTemplate(self)
    return self.templateDict
end


EdenAreaTemplateManager.__init = __init
EdenAreaTemplateManager.__delete = __delete
EdenAreaTemplateManager.Startup = Startup
EdenAreaTemplateManager.InitTemplateDict = InitTemplateDict
EdenAreaTemplateManager.GetTemplate = GetTemplate
EdenAreaTemplateManager.GetAllTemplate = GetAllTemplate

return EdenAreaTemplateManager