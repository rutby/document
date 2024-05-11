--- Created by shimin
--- DateTime: 2024/01/08 17:06
--- 建筑信息界面
local UIBuildInfo = {
    Name = UIWindowNames.UIBuildInfo,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIBuildInfo.Controller.UIBuildInfoCtrl",
    View = require "UI.UIBuildInfo.View.UIBuildInfoView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildInfo.prefab",
}

return {
    -- 配置
    UIBuildInfo = UIBuildInfo,
}