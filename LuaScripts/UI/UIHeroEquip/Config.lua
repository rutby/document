---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: zhangjiabin
-- 英雄装备
-- Date: 2024-03-22 13:10:04
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class Config
local UIHeroEquip = {
	Name = UIWindowNames.UIHeroEquip,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIHeroEquip.Controller.UIHeroEquipCtrl",
	View = require "UI.UIHeroEquip.View.UIHeroEquipView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIHeroEquip/View/UIHeroEquipView.prefab",
}

return {
	-- 配置
	UIHeroEquip = UIHeroEquip,
}