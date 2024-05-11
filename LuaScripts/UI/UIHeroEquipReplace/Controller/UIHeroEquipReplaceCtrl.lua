---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 14:49:30
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipReplaceCtrl
local UIHeroEquipReplaceCtrl = BaseClass("UIHeroEquipReplaceCtrl", UIBaseCtrl)

function UIHeroEquipReplaceCtrl:CloseSelf()
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquipReplace)
end

function UIHeroEquipReplaceCtrl:GetAllEquipList()
	local result = {}
	local equips = DataCenter.HeroEquipManager:GetAllEquip()
	for k, v in pairs(equips) do
		table.insert(result, v)
	end
	return result
end

return UIHeroEquipReplaceCtrl