---
--- Pve 丧尸配置管理
---
---@class DataCenter.LWBuff.LWBuffTemplateManager
local LWBuffTemplateManager = BaseClass("LWBuffTemplateManager")
local LWBuffTemplate = require"DataCenter.LWBuff.LWBuffTemplate"

local function __init(self)
    self.templateDict = {}
end

local function __delete(self)
end

---@return DataCenter.LWBuff.LWBuffTemplate
local function GetTemplate(self, id)
    id = tonumber(id)
    if table.containsKey(self.templateDict,id) then
        return self.templateDict[id]
    end

    local lineData = LocalController:instance():getLine(TableName.LW_Buff,id)
    if lineData == nil then
        Logger.LogError("LWBuffTemplate GetTemplate lineData is nil id:"..id)
        return nil
    end

    local template = LWBuffTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template

    return template
end

LWBuffTemplateManager.__init = __init
LWBuffTemplateManager.__delete = __delete
LWBuffTemplateManager.GetTemplate = GetTemplate

return LWBuffTemplateManager