---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 15:47:39
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipUtil
local HeroEquipUtil = {}
local Localization = CS.GameEntry.Localization

local BG_Icon_Path = {
	"Common_img_quality_white",
	"Common_img_quality_green",
	"Common_img_quality_blue",
	"Common_img_quality_purple",
	"Common_img_quality_orange",
}

local Gem_Bg_Path = {
	"ui_quality_lvbg_white",
	"ui_quality_lvbg_green",
	"ui_quality_lvbg_blue",
	"ui_quality_lvbg_purple",
	"ui_quality_lvbg_orange",
}

function HeroEquipUtil:CheckSwitch()
	return true
	--local isOpen = LuaEntry.DataConfig:CheckSwitch("hero_equip_switch") -- 开关
	--return isOpen
end

function HeroEquipUtil:GetEquipmentIcon(equipmentId)
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(equipmentId)
	if template then
		return string.format(LoadPath.UIHeroEquipIcons, template.icon)
	end
	return ""
end

function HeroEquipUtil:GetEquipmentSlotIcon(slot)
	local icon = string.format("herogear_icon_equip0%s", slot + 1)
	return string.format(LoadPath.UIHeroEquipPath, icon)
end

function HeroEquipUtil:GetEquipmentName(equipmentId)
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(equipmentId)
	if template then
		return Localization:GetString(template.name)
	end
	return ""
end

function HeroEquipUtil:GetEquipmentQualityBG(equipmentId)
	--return string.format(LoadPath.ItemPath, "Common_img_quality_blue")
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(equipmentId)
	if template then
		--return string.format(LoadPath.UIEquipmentIcons, "equipment_bg_"..template.color)
		return string.format(LoadPath.ItemPath, BG_Icon_Path[template.quality])
	end
	return string.format(LoadPath.ItemPath, "Common_img_quality_empty")
end

function HeroEquipUtil:GetEquipmentStarQualityBG(equipmentId)
	--return string.format(LoadPath.ItemPath, "Common_img_quality_blue")
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(equipmentId)
	if template then
		--return string.format(LoadPath.UIEquipmentIcons, "equipment_bg_"..template.color)
		return LoadPath.HeroIconsSmallPath .. Gem_Bg_Path[template.quality]
	end
	return LoadPath.HeroIconsSmallPath .. "ui_quality_lvbg_green"
end

function HeroEquipUtil:GetEquipmentNameColor(color)
	if color > #Name_Color then
		return Name_Color[1]
	end
	return Name_Color[color]
end

return HeroEquipUtil