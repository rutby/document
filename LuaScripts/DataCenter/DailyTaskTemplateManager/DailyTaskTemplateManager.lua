---
--- Created by shimin.
--- DateTime: 2022/2/23 15:12
---
local DailyTaskTemplateManager = BaseClass("DailyTaskTemplateManager");
local DailyTaskTemplate = require "DataCenter.DailyTaskTemplateManager.DailyTaskTemplate"

local function __init(self)
    self.questTemplateDic ={}
end

local function __delete(self)
    self.questTemplateDic =nil
end

local function GetQuestTemplate(self,id)
    if self.questTemplateDic[tonumber(id)]== nil then
        local oneTemplate = LocalController:instance():getLine(TableName.DailyQuest,tostring(id))
        if oneTemplate~=nil then
            local item = DailyTaskTemplate.New()
            item:InitData(oneTemplate)
            if item.id ~=nil then
                self.questTemplateDic[item.id] = item
            end
        end
    end
    return self.questTemplateDic[tonumber(id)]
end

DailyTaskTemplateManager.__init = __init
DailyTaskTemplateManager.__delete = __delete
DailyTaskTemplateManager.GetQuestTemplate = GetQuestTemplate

return DailyTaskTemplateManager
