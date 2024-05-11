---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2021/12/1 12:49
---

local AllianceCityTemplate = BaseClass("AllianceCityTemplate")

local function __init(self)
    self.id = 0
    self.pos = { x = 0, y = 0 }
    self.level = 0
    self.size = 0
    self.monster_id = ""
    self.monster_num = 0
    self.buff = ""
    self.first_reward = ""
    self.show_reward = ""
    self.kill_reward = ""
    self.destroy_reward = ""
    self.wall = 0
    self.wall_recover = 0
    self.force = 0
    self.name = 0
    self.guard_num = 0
    self.army_recover_time = 0
    self.protect_time = 0
    self.open_time = 0
    self.nearBy = ""
    self.putRange = 0
    self.actScore = 0
    self.icon = ""
    self.eden_city_type = WorldCityType.AllianceCity
    self.server_type = ServerType.NORMAL
end

local function __delete(self)
    self.id = nil
    self.pos = nil
    self.level = nil
    self.size = nil
    self.monster_id = nil
    self.monster_num = nil
    self.buff = nil
    self.first_reward = nil
    self.show_reward = nil
    self.kill_reward = nil
    self.destroy_reward = nil
    self.wall = nil
    self.wall_recover = nil
    self.force = nil
    self.name = nil
    self.guard_num = nil
    self.army_recover_time = nil
    self.protect_time = nil
    self.open_time = nil
    self.nearBy = nil
    self.putRange = 0
    self.actScore = 0
    self.icon = ""
end

local function InitData(self, row)
    if row == nil then
        return
    end


    self.id = row:getValue("id")
    self.icon = row:getValue("icon") or ""
    local location = string.split(row:getValue("location"), "|")
    self.pos =
    {
        x = tonumber(location[1]),
        y = tonumber(location[2]),
    }
    self.level = tonumber(row:getValue("level"))
    self.size = tonumber(row:getValue("size"))
    local server_type = tonumber(row:getValue("server_type"))
    local eden_city_type = tonumber(row:getValue("eden_city_type"))
    if server_type~=nil then
        self.server_type = server_type
    end
    if eden_city_type~=nil then
        self.eden_city_type = eden_city_type
    end
    local half = math.floor(self.size / 2)
    self.center = {}
    self.center.x = self.pos.x - half
    self.center.y = self.pos.y - half
    self.monster_id = row:getValue("monster_id")
    self.monster_num = tonumber(row:getValue("monster_num"))
    self.buff = row:getValue("buff")
    self.first_reward = row:getValue("first_reward")
    self.show_reward = row:getValue("show_reward")
    self.kill_reward = row:getValue("kill_reward")
    self.destroy_reward = row:getValue("destroy_reward")
    self.wall = tonumber(row:getValue("wall"))
    self.wall_recover = tonumber(row:getValue("wall_recover"))
    self.force = tonumber(row:getValue("force"))
    self.name = tonumber(row:getValue("name"))
    self.guard_num = tonumber(row:getValue("guard_num"))
    self.army_recover_time = tonumber(row:getValue("army_recover_time"))
    self.protect_time = tonumber(row:getValue("protect_time"))
    self.open_time = tonumber(row:getValue("open_time"))
    self.nearBy = string.split(row:getValue("nearBy"), "|")
    self.actScore = tonumber(row:getValue("act_add_score"))
end

function AllianceCityTemplate:GetAllianceCityRange()
    if self.putRange == 0 then
        if self.level == 7 then
            self.putRange = LuaEntry.DataConfig:TryGetNum("NPC_city_range", "k1")
        else
            self.putRange = LuaEntry.DataConfig:TryGetNum("NPC_city_range", "k3")
        end
    end
    return self.putRange
end

AllianceCityTemplate.__init = __init
AllianceCityTemplate.__delete = __delete
AllianceCityTemplate.InitData = InitData

return AllianceCityTemplate