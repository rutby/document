---
--- Pve 丧尸配置管理
---

local PveMonsterTemplateManager = BaseClass("PveMonsterTemplateManager")
local PveMonsterTemplate = require"DataCenter.PveMonster.PveMonsterTemplate"

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

    local lineData = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Monster),id)
    if lineData == nil then
        Logger.LogError("PveMonsterTemplate GetTemplate lineData is nil id:"..id)
        return nil
    end

    local template = PveMonsterTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template

    return template
end

PveMonsterTemplateManager.__init = __init
PveMonsterTemplateManager.__delete = __delete
PveMonsterTemplateManager.GetTemplate = GetTemplate

return PveMonsterTemplateManager