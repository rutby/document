--- Created by shimin.
--- DateTime: 2023/12/19 22:04
--- 科技属性详情界面

-- 窗口配置
local UIScienceDetail = {
	Name = UIWindowNames.UIScienceDetail,
	Layer = UILayer.Background,
	Ctrl = require "UI.UIScienceDetail.Controller.UIScienceDetailCtrl",
	View = require "UI.UIScienceDetail.View.UIScienceDetailView",
	PrefabPath = "Assets/Main/Prefabs/UI/UIScience/UIScienceDetail.prefab",
}

return {
	-- 配置
	UIScienceDetail = UIScienceDetail,
}

