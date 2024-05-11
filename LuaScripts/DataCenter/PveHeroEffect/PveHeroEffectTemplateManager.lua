---
--- Pve 丧尸配置管理
---

---@class PveHeroEffectTemplateManager
local PveHeroEffectTemplateManager = BaseClass("PveHeroEffectTemplateManager")
local PveHeroEffectTemplate = require"DataCenter.PveHeroEffect.PveHeroEffectTemplate"

local function __init(self)
    self.templateDict = {}
end

local function __delete(self)
end

---@return DataCenter.PveSkill.PveHeroEffectTemplate
local function GetTemplate(self, id)
    id = tonumber(id)
    if table.containsKey(self.templateDict,id) then
        return self.templateDict[id]
    end

    local lineData = LocalController:instance():getLine(TableName.LW_Hero_Effect,id)
    if lineData == nil then
        Logger.LogError("PveHeroEffectTemplate GetTemplate lineData is nil id:"..id)
        return nil
    end

    local template = PveHeroEffectTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template

    return template
end

PveHeroEffectTemplateManager.__init = __init
PveHeroEffectTemplateManager.__delete = __delete
PveHeroEffectTemplateManager.GetTemplate = GetTemplate

return PveHeroEffectTemplateManager