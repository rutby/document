---
--- Pve 丧尸配置
---
---@class DataCenter.PveMonster.PveMonsterTemplate
local PveMonsterTemplate = BaseClass("PveMonsterTemplate")

local function __init(self)
    
end

local function __delete(self)
    self.skill=nil
    self.collide_damage = nil
end

local function InitData(self, row)
    if row == nil then
        return
    end
    
    self.id = tonumber(row:getValue("id")) or 0
    self.name = row:getValue("name")
    self.asset = row:getValue("asset")
    self.asset_low = row:getValue("asset_low")
    self.avatar = row:getValue("avatar")
    self.icon = row:getValue("icon")
    self.type = tonumber(row:getValue("type")) or 0
    self.monster_type = tonumber(row:getValue("monster_type")) or 0
    self.is_attack = tonumber(row:getValue("is_attack")) or 0
    self.is_move = tonumber(row:getValue("is_move")) or 0
    self.move_speed = tonumber(row:getValue("move_speed")) or 0
    self.alert_range = tonumber(row:getValue("alert_range")) or 0
    self.hp_bar_num = tonumber(row:getValue("hp_bar_num")) or 1
    self.attack = tonumber(row:getValue("attack")) or 0
    self.attack_interval = tonumber(row:getValue("attack_interval")) or 0
    self.attack_radius = tonumber(row:getValue("attack_radius")) or 0
    self.hp = tonumber(row:getValue("hp")) or 1
    self.hp_bar_height = tonumber(row:getValue("hp_bar_height")) or 2
    self.collide_radius = tonumber(row:getValue("collide_radius")) or 1
    self.death_trigger_item = tonumber(row:getValue("death_trigger_item"))
    self.model_size = tonumber(row:getValue("model_size")) or 1
    self.crash_kill = tonumber(row:getValue("crash_kill")) or 0
    self.is_boss = tonumber(row:getValue("is_boss")) or 0
    
    self.hp = tonumber(row:getValue("hp")) or 1
    self.physics_defence = tonumber(row:getValue("physics_defence")) or 0
    self.magic_defence = tonumber(row:getValue("magic_defence")) or 0
    local skillStr=row:getValue("skill")
    if skillStr==nil or skillStr=="" then
        self.skill=nil
    else
        self.skill= {}
        skillStr = string.split(skillStr,"|")
        for _,skill in pairs(skillStr) do
            table.insert(self.skill,tonumber(skill))
        end
    end

    self.ignore_hit_stiff = tonumber(row:getValue("ignore_hit_stiff")) or 0
    self.ignore_hit_back = tonumber(row:getValue("ignore_hit_back")) or 0
    self.property=row:getValue("property")
    self.monster_effect = tonumber(row:getValue("monster_effect")) or 0

    self.collide_count = tonumber(row:getValue("collide_count")) or -1
    self.collide_damage = nil
    local spl = string.split(row:getValue("collide_damage"),'|')
    if #spl == 3 then
        self.collide_damage = {}
        for i,v in ipairs(spl) do
            self.collide_damage[i] = tonumber(v)
        end
    end

end


PveMonsterTemplate.__init = __init
PveMonsterTemplate.__delete = __delete
PveMonsterTemplate.InitData = InitData


return PveMonsterTemplate