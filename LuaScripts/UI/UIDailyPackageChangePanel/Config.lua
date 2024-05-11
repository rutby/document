
local UIDailyPackageChangePanel = {
    Name = UIWindowNames.UIDailyPackageChangePanel,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIDailyPackageChangePanel.Controller.UIDailyPackageChangePanelCtrl",
    View = require "UI.UIDailyPackageChangePanel.View.UIDailyPackageChangePanelView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/GiftPackage/DailyPackage/UIDailyPackageChangePanel.prefab",
}

return {
    -- 配置
    UIDailyPackageChangePanel = UIDailyPackageChangePanel,
}