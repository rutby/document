---
--- Created by shimin.
--- DateTime: 2021/11/10 20:35
---
local UnlockBtnTemplateManager = BaseClass("UnlockBtnTemplateManager")
local UnlockBtnTemplate = require "DataCenter.UnlockBtnManager.UnlockBtnTemplate"

local function __init(self)
    self.templateDic ={}
end

local function __delete(self)
    self.templateDic ={}
end

local function GetUnlockBtnTemplate(self,id)
    if self.templateDic[tonumber(id)]== nil then
        local oneTemplate = LocalController:instance():getLine(TableName.UnlockBtn,tostring(id))
        if oneTemplate~=nil then
            local item = UnlockBtnTemplate.New()
            item:InitData(oneTemplate)
            if item.id ~=nil then
                self.templateDic[item.id] = item
            end
        end
    end
    return self.templateDic[tonumber(id)]
end

UnlockBtnTemplateManager.__init = __init
UnlockBtnTemplateManager.__delete = __delete
UnlockBtnTemplateManager.GetUnlockBtnTemplate = GetUnlockBtnTemplate

return UnlockBtnTemplateManager
