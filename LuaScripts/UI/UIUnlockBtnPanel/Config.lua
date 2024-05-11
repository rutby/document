
local UIUnlockBtnPanel = {
    Name = UIWindowNames.UIUnlockBtnPanel,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIUnlockBtnPanel.Ctrl.UIUnlockBtnPanelCtrl",
    View = require "UI.UIUnlockBtnPanel.View.UIUnlockBtnPanelView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIUnlockBtnPanel/UIUnlockBtnPanel.prefab",
}

return {
    -- 配置
    UIUnlockBtnPanel = UIUnlockBtnPanel,
}