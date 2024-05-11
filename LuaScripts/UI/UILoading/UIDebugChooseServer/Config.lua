
local UIDebugChooseServer = {
	Name = UIWindowNames.UIDebugChooseServer,
	Layer = UILayer.Info,
	Ctrl = require "UI.UILoading.UIDebugChooseServer.Controller.UIDebugChooseServerCtrl",
	View = require "UI.UILoading.UIDebugChooseServer.View.UIDebugChooseServerView",
	PrefabPath = "Assets/Main/Prefab_Dir/Debug/UIDebugChooseServer.prefab",
}

return {
	-- 配置
	UIDebugChooseServer = UIDebugChooseServer,
}