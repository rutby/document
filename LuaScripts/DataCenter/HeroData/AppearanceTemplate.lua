---
--- Pve 丧尸配置
---
---@class DataCenter.HeroData.AppearanceTemplate
local AppearanceTemplate = BaseClass("AppearanceTemplate")

local function __init(self)

end

local function __delete(self)

end

local function InitData(self, row)
	if row == nil then
		return
	end

	self.id = tonumber(row:getValue("id")) or 0
	self.model_path = row:getValue("model_path")
	-- if string.IsNullOrEmpty(self.model_path) then
	-- 	self.model_path = row:getValue("city_model_path")
	-- end
	self.city_model_path = row:getValue("city_model_path")
	self.queue_model_path = row:getValue("queue_model_path")
	self.model_size = tonumber(row:getValue("model_size"))
	self.model_size = self.model_size > 0 and self.model_size or 1
	self.canon_path = row:getValue("canon_path")
	self.fire_path = row:getValue("fire_path")
	self.hero_effect = tonumber(row:getValue("hero_effect"))
	self.angular_speed = tonumber(row:getValue("angular_speed")) or 4
	self.army_type = tonumber(row:getValue("army_type")) or 0
	self.appearance = tonumber(row:getValue("appearance")) or 0
	self.team_location = tonumber(row:getValue("team_location")) or 0
	self.speed_battle = tonumber(row:getValue("speed_battle")) or 0
	self.canon_rotation = row:getValue("canon_rotation")
	self.heroimg_model = row:getValue("Heroimg_model")
	self.half_icon_path = row:getValue("half_icon_path") or ""
	self.walk_sound = row:getValue("walk_sound") or ""
	self.queue_icon_path = row:getValue("queue_icon_path") or ""
	self.world_model_path = row:getValue("world_model_path") or ""
end


AppearanceTemplate.__init = __init
AppearanceTemplate.__delete = __delete
AppearanceTemplate.InitData = InitData


return AppearanceTemplate