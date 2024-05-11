---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 15:49:25
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipAttrTemplate
local HeroEquipAttrTemplate = BaseClass("HeroEquipAttrTemplate")

function HeroEquipAttrTemplate:__init()
	self.id = 0
	self.power = 0
	self.effects = {}
end

function HeroEquipAttrTemplate:__delete()
	self.id = 0
	self.power = 0
	self.effects = {}
end

function HeroEquipAttrTemplate:InitData(id)
	self.id = id
	local lineData = LocalController:instance():getLine(TableName.EquipAttribute, id)
	if lineData ~= nil then
		self.power = toInt(lineData:getValue("power"))
		local effects = lineData:getValue("effects")
		if not string.IsNullOrEmpty(effects) then
			local vec = string.split(effects, "|")
			for i, v in ipairs(vec) do
				local effectsVec = string.split(v, ";")
				if table.count(effectsVec) == 2 then
					local effectId = toInt(effectsVec[1])
					local param = {}
					param.id = effectId
					param.value = tonumber(effectsVec[2])
					param.descKey = GetTableData(TableName.EffectNumDesc, effectId, "des")
					param.numType = GetTableData(TableName.EffectNumDesc, effectId, "type")
					table.insert(self.effects, param)
				end
			end
		end
	end
end

return HeroEquipAttrTemplate