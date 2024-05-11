---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 15:39:13
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipModel
local HeroEquipModel = BaseClass("HeroEquipModel")
local Localization = CS.GameEntry.Localization

function HeroEquipModel:__init()
	self.uuid = 0
	self.equipId = 0
	self.level = 0
	self.promote = 0
	self.heroId = 0
end

function HeroEquipModel:__delete()
	self.uuid = 0
	self.equipId = 0
	self.level = 0
	self.promote = 0
	self.heroId = 0
end

function HeroEquipModel:ParseData(param)
	if param["uuid"] then
		self.uuid = param["uuid"]
	end
	if param["equipId"] then
		self.equipId = param["equipId"]
	end
	if param["level"] then
		self.level = param["level"]
	end
	if param["equipLv"] then
		self.level = param["equipLv"]
	end
	if param["promote"] then
		self.promote = param["promote"]
	end
	if param["heroId"] then
		self.heroId = param["heroId"]
	else
		self.heroId = 0
	end
end

function HeroEquipModel:GetLvText()
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(self.equipId)
	if template ~= nil then
		if template.quality == HeroEquipConst.EquipColor.EquipColor_Green then
			return ''
		else
			return Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.level)
		end
	end
end

function HeroEquipModel:IsMaxLevel()
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(self.equipId)
	if template ~= nil then
		return template:IsMaxLevel(self.level)
	end
end

function HeroEquipModel:HasPromote()
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(self.equipId)
	if template ~= nil then
		return #template.basicAttributesPromote > 0
	end
end

function HeroEquipModel:IsMaxPromote()
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(self.equipId)
	if template ~= nil then
		local isMaxPromote = DataCenter.HeroEquipPromoteTemplateManager:IsMaxPromote(self.promote);
		return isMaxPromote
	end
end

function HeroEquipModel:GetPromoteLevel()
	return math.floor(self.promote / HeroEquipConst.EquipPromoteStage)
end

function HeroEquipModel:GetPromoteStage()
	return self.promote % HeroEquipConst.EquipPromoteStage
end

function HeroEquipModel:GetPromoteStageRate()
	return self.promote % HeroEquipConst.EquipPromoteStage / (HeroEquipConst.EquipPromoteStage - 1)
end

function HeroEquipModel:GetEquipPower()
	return DataCenter.HeroEquipTemplateManager:GetEquipmentPower(self.equipId, self.level, self.promote)
end


return HeroEquipModel