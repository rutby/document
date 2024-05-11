---
--- Created by shimin
--- DateTime: 2023/4/10 20:23
--- buff状态表管理器
---
local StatusTemplateManager = BaseClass("StatusTemplateManager")
local StatusTemplate = require "DataCenter.StatusTemplateManager.StatusTemplate"

function StatusTemplateManager:__init()
    self.templateDic = {}
end

function StatusTemplateManager:__delete()
    self.templateDic = {}
end

function StatusTemplateManager:GetTemplate(id)
    local numId = tonumber(id)
    if self.templateDic[numId]== nil then
        local oneTemplate = LocalController:instance():getLine(TableName.StatusTab, tostring(id))
        if oneTemplate~=nil then
            local item = StatusTemplate.New()
            item:InitData(oneTemplate)
            if item.id ~=nil then
                self.templateDic[item.id] = item
            end
        end
    end
    return self.templateDic[numId]
end

return StatusTemplateManager