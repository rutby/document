---
--- Pve 丧尸配置
---

local PveZombieTemplate = BaseClass("PveZombieTemplate")

local function __init(self)
    
end

local function __delete(self)
    
end

local function InitData(self, row)
    if row == nil then
        return
    end
    
    self.id = tonumber(row:getValue("id")) or 0
    self.model = row:getValue("Model")
    self.attackRadius = tonumber(row:getValue("AttackRadius")) or 1
    self.moveSpeed = tonumber(row:getValue("MoveSpeed")) or 1
    self.maxBlood = tonumber(row:getValue("Blood")) or 1
end


PveZombieTemplate.__init = __init
PveZombieTemplate.__delete = __delete
PveZombieTemplate.InitData = InitData


return PveZombieTemplate