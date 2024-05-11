
local UIPVEResult = {
	Name = UIWindowNames.UIPVEResult,
	Layer = UILayer.Background,
	Ctrl = require "UI.UIPVE.UIPVEResult.Controller.UIPVEResultCtrl",
	View = require "UI.UIPVE.UIPVEResult.View.UIPVEResultView",
	PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuidePioneerResult.prefab",
}


return {
    -- 配置
	UIPVEResult = UIPVEResult
}