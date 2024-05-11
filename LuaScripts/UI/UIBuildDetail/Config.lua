--- Created by shimin.
--- DateTime: 2024/1/8 18:05
--- 建筑属性详情界面

-- 窗口配置
local UIBuildDetail = {
	Name = UIWindowNames.UIBuildDetail,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIBuildDetail.Controller.UIBuildDetailCtrl",
	View = require "UI.UIBuildDetail.View.UIBuildDetailView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIBuildDetail/UIBuildDetail.prefab",
}

return {
	-- 配置
	UIBuildDetail = UIBuildDetail,
}

