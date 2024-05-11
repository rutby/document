---
--- Pve trigger配置管理
---
---@class DataCenter.LWTriggerItem.LWTriggerItemTemplateManager
local LWTriggerItemTemplateManager = BaseClass("LWTriggerItemTemplateManager")
local LWTriggerItemTemplate = require"DataCenter.LWTriggerItem.LWTriggerItemTemplate"

local function __init(self)
    self.templateDict = {}
end

local function __delete(self)
end

---@return DataCenter.LWTriggerItem.LWTriggerItemTemplate
local function GetTemplate(self, id)
    id = tonumber(id)
    if table.containsKey(self.templateDict,id) then
        return self.templateDict[id]
    end

    local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Trigger_Item),id)
    if lineData == nil then
        Logger.LogError("lw_trigger_item GetTemplate lineData is nil id:"..id)
        return nil
    end

    local template = LWTriggerItemTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template

    return template
end

LWTriggerItemTemplateManager.__init = __init
LWTriggerItemTemplateManager.__delete = __delete
LWTriggerItemTemplateManager.GetTemplate = GetTemplate

return LWTriggerItemTemplateManager