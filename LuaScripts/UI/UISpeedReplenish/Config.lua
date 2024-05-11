--- Created by shimin.
--- DateTime: 2024/1/19 17:04
--- 一键补充加速界面

-- 窗口配置
local UISpeedReplenish = {
	Name = UIWindowNames.UISpeedReplenish,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UISpeedReplenish.Controller.UISpeedReplenishCtrl",
	View = require "UI.UISpeedReplenish.View.UISpeedReplenishView",
	PrefabPath = "Assets/Main/Prefabs/UI/UISpeed/UISpeedReplenish.prefab",
}

return {
	-- 配置
	UISpeedReplenish = UISpeedReplenish,
}

