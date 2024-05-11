---
--- Pve 丧尸配置管理
---
---@class AppearanceTemplateManager
local AppearanceTemplateManager = BaseClass("AppearanceTemplateManager")
local AppearanceTemplate = require"DataCenter.HeroData.AppearanceTemplate"

local function __init(self)
    self.templateDict = {}
end

local function __delete(self)

end

local function GetTemplate(self, id)
    if not id then
        return nil
    end
    id = tonumber(id)
    if table.containsKey(self.templateDict,id) then
        return self.templateDict[(id)]
    end

    local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance),id)
    if lineData == nil then
        Logger.LogError("AppearanceTemplateManager GetTemplate lineData is nil id:"..id)
        return nil
    end

    local template = AppearanceTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template

    return template
end

AppearanceTemplateManager.__init = __init
AppearanceTemplateManager.__delete = __delete
AppearanceTemplateManager.GetTemplate = GetTemplate

return AppearanceTemplateManager