---
--- Created by shimin.
--- DateTime: 2022/2/28 18:03
---
local AllianceCareerTemplateManager = BaseClass("AllianceCareerTemplateManager");
local AllianceEffectTemplate = require "DataCenter.AllianceCareerManager.AllianceEffectTemplate"

local function __init(self)
    self.alEffectTemplateList = nil
end

local function __delete(self)
    self.alEffectTemplateList = nil
end

local function GetAlEffectList(self)
    if self.alEffectTemplateList == nil  then
        self:TransAllAlEffectTemplate()
        table.sort(self.alEffectTemplateList,function (a,b)
            return a.order > b.order
        end)
    end
    return self.alEffectTemplateList
end


local function TransAllAlEffectTemplate(self)
    self.alEffectTemplateList = {}
    LocalController:instance():visitTable(TableName.AlEffect,function(id,lineData)
        local item = AllianceEffectTemplate.New()
        item:InitData(lineData)
        table.insert(self.alEffectTemplateList,item)
    end)
end

AllianceCareerTemplateManager.__init = __init
AllianceCareerTemplateManager.__delete = __delete
AllianceCareerTemplateManager.GetAlEffectList = GetAlEffectList
AllianceCareerTemplateManager.TransAllAlEffectTemplate = TransAllAlEffectTemplate

return AllianceCareerTemplateManager
