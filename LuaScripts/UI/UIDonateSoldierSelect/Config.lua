
local UIDonateSoldierSelect = {
    Name = UIWindowNames.UIDonateSoldierSelect,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIDonateSoldierSelect.Controller.UIDonateSoldierSelectCtrl",
    View = require "UI.UIDonateSoldierSelect.View.UIDonateSoldierSelectView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDonateSoldier/UIDonateSoldierSelectPanel.prefab",
}

return {
    -- 配置
    UIDonateSoldierSelect = UIDonateSoldierSelect,
}