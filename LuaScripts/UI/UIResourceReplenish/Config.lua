--- Created by shimin.
--- DateTime: 2024/1/18 10:13
--- 一键补充资源界面

-- 窗口配置
local UIResourceReplenish = {
	Name = UIWindowNames.UIResourceReplenish,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIResourceReplenish.Controller.UIResourceReplenishCtrl",
	View = require "UI.UIResourceReplenish.View.UIResourceReplenishView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIResource/UIResourceReplenish.prefab",
}

return {
	-- 配置
	UIResourceReplenish = UIResourceReplenish,
}

