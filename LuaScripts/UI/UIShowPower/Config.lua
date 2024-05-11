--- Created by shimin.
--- DateTime: 2023/12/20 19:08
--- 提升战力界面界面

-- 窗口配置
local UIShowPower = {
	Name = UIWindowNames.UIShowPower,
	Layer = UILayer.Info,
	Ctrl = require "UI.UIShowPower.Controller.UIShowPowerCtrl",
	View = require "UI.UIShowPower.View.UIShowPowerView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIShowPower/UIShowPower.prefab",
}

return {
	-- 配置
	UIShowPower = UIShowPower,
}

