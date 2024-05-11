---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 17:34:47
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class Config
local UIHeroEquipInfo = {
	Name = UIWindowNames.UIHeroEquip,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIHeroEquipInfo.Controller.UIHeroEquipInfoCtrl",
	View = require "UI.UIHeroEquipInfo.View.UIHeroEquipInfoView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIHeroEquip/View/UIHeroEquipInfoView.prefab",
}

return {
	-- 配置
	UIHeroEquipInfo = UIHeroEquipInfo,
}