--- Created by shimin.
--- DateTime: 2024/1/19 10:26
--- 加速界面

-- 窗口配置
local UISpeed = {
	Name = UIWindowNames.UISpeed,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UISpeed.Controller.UISpeedCtrl",
	View = require "UI.UISpeed.View.UISpeedView",
	PrefabPath = "Assets/Main/Prefabs/UI/UISpeed/UISpeed.prefab",
}

return {
	-- 配置
	UISpeed = UISpeed,
}

