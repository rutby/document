---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 13:13:02
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeroEquipCtrl
local UIHeroEquipCtrl = BaseClass("UIHeroEquipCtrl", UIBaseCtrl)

function UIHeroEquipCtrl:__init()
	self.takePartMultiSelectList = {}
end

function UIHeroEquipCtrl:__delete()
	self.takePartMultiSelectList = nil
end

function UIHeroEquipCtrl:CloseSelf()
	UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroEquip)
end

return UIHeroEquipCtrl