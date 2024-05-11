---
--- Created by shimin.
--- DateTime: 2021/7/22 21:42
---
local ResourceTemplateManager = BaseClass("ResourceTemplateManager");

local function __init(self)
    self.resourceTemplateDic ={}
end

local function __delete(self)
    self.resourceTemplateDic =nil
end

local function GetResourceTemplate(self,id)
    if self.resourceTemplateDic[tonumber(id)]== nil then
        local oneTemplate = LocalController:instance():getLine(TableName.Resource,tostring(id))
        if oneTemplate~=nil then
            local item = ResourceTemplate.New()
            item:InitData(oneTemplate)
            if item.id ~=nil then
                self.resourceTemplateDic[item.id] = item
            end
        end
    end
    return self.resourceTemplateDic[tonumber(id)]
end

ResourceTemplateManager.__init = __init
ResourceTemplateManager.__delete = __delete
ResourceTemplateManager.GetResourceTemplate = GetResourceTemplate

return ResourceTemplateManager
