---
--- Pve 丧尸配置管理
---

local PveZombieTemplateManager = BaseClass("PveZombieTemplateManager")
local PveZombieTemplate = require"DataCenter.PveZombie.PveZombieTemplate"

local function __init(self)
    self.templateDict = {}

    LocalController:instance():visitTable(TableName.PVEZombie, function(_, line)
        local template = PveZombieTemplate.New()
        template:InitData(line)
        self.templateDict[template.id] = template
    end)
end

local function __delete(self)
    
end

local function GetTemplate(self, id)
    return self.templateDict[tonumber(id)]
end

PveZombieTemplateManager.__init = __init
PveZombieTemplateManager.__delete = __delete
PveZombieTemplateManager.GetTemplate = GetTemplate

return PveZombieTemplateManager