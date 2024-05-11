
-- 窗口配置
local UIBuildUpgradeSuccess = {
    Name = UIWindowNames.UIBuildUpgradeSuccess,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIBuildUpgradeSuccess.Controller.UIBuildUpgradeSuccessCtrl",
    View = require "UI.UIBuildUpgradeSuccess.View.UIBuildUpgradeSuccessView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIBuildUpgradeSuccess/UIBuildUpgradeSuccess.prefab",
}

return {
    -- 配置
    UIBuildUpgradeSuccess = UIBuildUpgradeSuccess
}