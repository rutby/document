---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 17:34:56
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class Config
local UIHeroEquipReplace = {
	Name = UIWindowNames.UIHeroEquipReplace,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIHeroEquipReplace.Controller.UIHeroEquipReplaceCtrl",
	View = require "UI.UIHeroEquipReplace.View.UIHeroEquipReplaceView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIHeroEquip/View/UIHeroEquipReplaceView.prefab",
}

return {
	-- 配置
	UIHeroEquipReplace = UIHeroEquipReplace,
}