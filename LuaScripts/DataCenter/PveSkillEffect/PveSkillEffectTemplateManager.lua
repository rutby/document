---
--- Pve 丧尸配置管理
---

local PveSkillEffectTemplateManager = BaseClass("PveSkillEffectTemplateManager")
local PveSkillEffectTemplate = require"DataCenter.PveSkillEffect.PveSkillEffectTemplate"

local function __init(self)
    self.templateDict = {}
end

local function __delete(self)

end

local function GetTemplate(self, id)
    id = tonumber(id)
    if table.containsKey(self.templateDict,id) then
        return self.templateDict[id]
    end

    local lineData = LocalController:instance():getLine(TableName.LW_Skill_Effect,id)
    if lineData == nil then
        Logger.LogError("lw_hero_skill_effect GetTemplate is nil id:"..id)
        return PveSkillEffectTemplate.New()
    end

    local template = PveSkillEffectTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template

    return template
end

PveSkillEffectTemplateManager.__init = __init
PveSkillEffectTemplateManager.__delete = __delete
PveSkillEffectTemplateManager.GetTemplate = GetTemplate

return PveSkillEffectTemplateManager