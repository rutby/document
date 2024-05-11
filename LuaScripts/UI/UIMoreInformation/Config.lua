
local UIMoreInformation = {
	Name = UIWindowNames.UIMoreInformation,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UIMoreInformation.Controller.UIMoreInformationCtrl",
	View = require "UI.UIMoreInformation.View.UIMoreInformationView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIMoreInformation/UIMoreInformation.prefab",
}

return {
	-- 配置
	UIMoreInformation = UIMoreInformation,
}

