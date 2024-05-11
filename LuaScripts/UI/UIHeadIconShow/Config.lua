---------------------------------------------------------------------
-- aps (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-08-13 14:19:34
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class Config
local UIHeadIconShow = {
	Name = UIWindowNames.UIHeadIconShow,
	Layer = UILayer.Dialog,
	Ctrl = require "UI.UIHeadIconShow.Controller.UIHeadIconShowCtrl",
	View = require "UI.UIHeadIconShow.View.UIHeadIconShowView",
	PrefabPath = "Assets/Main/Prefab_Dir/ChatNew/UIHeadIconShow.prefab",
}

return {
	-- 配置
	UIHeadIconShow = UIHeadIconShow
}