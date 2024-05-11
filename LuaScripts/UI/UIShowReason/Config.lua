--- Created by shimin.
--- DateTime: 2023/12/25 17:41
--- 点击原始时间界面

-- 窗口配置
local UIShowReason = {
	Name = UIWindowNames.UIShowReason,
	Layer = UILayer.Background,
	Ctrl = require "UI.UIShowReason.Controller.UIShowReasonCtrl",
	View = require "UI.UIShowReason.View.UIShowReasonView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIShowReason/UIShowReason.prefab",
}

return {
	-- 配置
	UIShowReason = UIShowReason,
}

