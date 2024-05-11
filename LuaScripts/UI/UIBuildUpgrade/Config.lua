--- Created by shimin
--- DateTime: 2024/01/08 12:11
--- slg建筑升级界面
local UIBuildUpgrade = {
    Name = UIWindowNames.UIBuildUpgrade,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIBuildUpgrade.Controller.UIBuildUpgradeCtrl",
    View = require "UI.UIBuildUpgrade.View.UIBuildUpgradeView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildUpgrade.prefab",
}

return {
    -- 配置
    UIBuildUpgrade = UIBuildUpgrade,
}