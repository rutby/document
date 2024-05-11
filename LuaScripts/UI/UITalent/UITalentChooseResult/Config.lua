

-- 窗口配置
local UITalentChooseResult = {
	Name = UIWindowNames.UITalentChooseResult,
	Layer = UILayer.Normal,
	Ctrl = require "UI.UITalent.UITalentChooseResult.Controller.UITalentChooseResultCtrl",
	View = require "UI.UITalent.UITalentChooseResult.View.UITalentChooseResultView",
	PrefabPath = "Assets/Main/Prefabs/UI/UITalent/UITalentChooseResult.prefab",
}

return {
	-- 配置
	UITalentChooseResult = UITalentChooseResult,
}