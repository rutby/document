---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 17:34:51
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class Config
local UIHeroEquipPromotion = {
	Name = UIWindowNames.UIHeroEquipPromotion,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIHeroEquipPromotion.Controller.UIHeroEquipPromotionCtrl",
	View = require "UI.UIHeroEquipPromotion.View.UIHeroEquipPromotionView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIHeroEquip/View/UIHeroEquipPromotionView.prefab",
}

return {
	-- 配置
	UIHeroEquipPromotion = UIHeroEquipPromotion,
}