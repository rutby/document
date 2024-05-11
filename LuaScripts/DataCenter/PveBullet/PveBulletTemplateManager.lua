---
--- Pve 丧尸配置管理
---

---@class DataCenter.PveBullet.PveBulletTemplateManager
local PveBulletTemplateManager = BaseClass("PveBulletTemplateManager")
local PveBulletTemplate = require"DataCenter.PveBullet.PveBulletTemplate"

local function __init(self)
    self.templateDict = {}
end

local function __delete(self)
end

---@return DataCenter.PveBullet.PveBulletTemplate
local function GetTemplate(self, id)
    id = tonumber(id)
    if table.containsKey(self.templateDict,id) then
        return self.templateDict[id]
    end

    local lineData = LocalController:instance():getLine(TableName.LW_Bullet,id)
    if lineData == nil then
        Logger.LogError("PveBulletTemplate GetTemplate lineData is nil id:"..id)
        return nil
    end

    local template = PveBulletTemplate.New()
    template:InitData(lineData)
    self.templateDict[id] = template

    return template
end

PveBulletTemplateManager.__init = __init
PveBulletTemplateManager.__delete = __delete
PveBulletTemplateManager.GetTemplate = GetTemplate

return PveBulletTemplateManager