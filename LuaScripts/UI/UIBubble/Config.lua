--- Created by shimin.
--- DateTime: 2024/1/16 16:25
--- 气泡界面

-- 窗口配置
local UIBubble = {
	Name = UIWindowNames.UIBubble,
	Layer = UILayer.Scene,
	Ctrl = require "UI.UIBubble.Controller.UIBubbleCtrl",
	View = require "UI.UIBubble.View.UIBubbleView",
	PrefabPath = "Assets/Main/Prefab_Dir/UI/UIBubble/UIBubble.prefab",
}

return {
	-- 配置
	UIBubble = UIBubble,
}

