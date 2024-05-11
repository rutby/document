--- Created by shimin.
--- DateTime: 2023/12/19 22:04
--- 科技属性详情界面

-- 窗口配置
local UIAllianceScienceDetail = {
	Name = UIWindowNames.UIAllianceScienceDetail,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIAlliance.UIAllianceScienceDetail.Controller.UIAllianceScienceDetailCtrl",
	View = require "UI.UIAlliance.UIAllianceScienceDetail.View.UIAllianceScienceDetailView",
	PrefabPath = "Assets/Main/Prefabs/UI/UIScience/UIScienceDetail.prefab",
}

return {
	-- 配置
	UIAllianceScienceDetail = UIAllianceScienceDetail,
}

