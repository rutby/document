--- Created by shimin.
--- DateTime: 2024/1/22 21:11
--- 运兵车升级属性提示界面

-- 窗口配置
local UIGarageRefitUpgradeTip = {
	Name = UIWindowNames.UIGarageRefitUpgradeTip,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIGarageRefitUpgradeTip.Controller.UIGarageRefitUpgradeTipCtrl",
	View = require "UI.UIGarageRefitUpgradeTip.View.UIGarageRefitUpgradeTipView",
	PrefabPath = "Assets/Main/Prefabs/UI/UIGarageRefit/UIGarageRefitUpgradeTip.prefab",
}

return {
	-- 配置
	UIGarageRefitUpgradeTip = UIGarageRefitUpgradeTip,
}

