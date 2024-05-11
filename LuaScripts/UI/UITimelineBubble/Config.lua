--- Created by shimin.
--- DateTime: 2024/1/24 17:38
--- timeline气泡界面

-- 窗口配置
local UITimelineBubble = {
	Name = UIWindowNames.UITimelineBubble,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UITimelineBubble.Controller.UITimelineBubbleCtrl",
	View = require "UI.UITimelineBubble.View.UITimelineBubbleView",
	PrefabPath = "Assets/Main/Prefab_Dir/AnimScene/UITimelineBubble.prefab",
}

return {
	-- 配置
	UITimelineBubble = UITimelineBubble,
}

