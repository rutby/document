--- Created by shimin
--- DateTime: 2023/6/6 11:36
--- 随机英雄插件消耗表管理器

local RandomPlugCostTemplateManager = BaseClass("RandomPlugCostTemplateManager")
local RandomPlugCostTemplate = require "DataCenter.HeroPluginManager.RandomPlugCostTemplate"

function RandomPlugCostTemplateManager:__init()
    self.templateDic = {}--<等级， template>
    self.useTableName = nil
end

function RandomPlugCostTemplateManager:__delete()
    self.templateDic = {}
    self.useTableName = nil
end

function RandomPlugCostTemplateManager:Startup()
end

function RandomPlugCostTemplateManager:TransAllTemplates()
    self.useTableName = nil
    self.templateDic = {}
    LocalController:instance():visitTable(self:GetTableName(),function(id, lineData)
        local item = RandomPlugCostTemplate.New()
        item:InitData(lineData)
        if item.lv ~=nil then
            self.templateDic[item.lv] = item
        end
    end)
end

function RandomPlugCostTemplateManager:GetTemplate(lv)
    return self.templateDic[lv]
end

function RandomPlugCostTemplateManager:GetTableName()
    if self.useTableName == nil then
        self.useTableName = TableName.RandomPlugCost
    end
    return self.useTableName
end

return RandomPlugCostTemplateManager