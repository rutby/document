
local UIALVSDonateSoldierSelect = {
    Name = UIWindowNames.UIALVSDonateSoldierSelect,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIALVSDonateSoldier.UIALVSDonateSoldierSelect.Controller.UIALVSDonateSoldierSelectCtrl",
    View = require "UI.UIALVSDonateSoldier.UIALVSDonateSoldierSelect.View.UIALVSDonateSoldierSelectView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIALVSDonateSoldier/UIALVSDonateSoldierSelectPanel.prefab",
}

return {
    -- 配置
    UIALVSDonateSoldierSelect = UIALVSDonateSoldierSelect,
}