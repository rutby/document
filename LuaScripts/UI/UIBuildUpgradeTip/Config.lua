---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/9/23 18:35
---
local UIBuildUpgradeTip = {
    Name = UIWindowNames.UIBuildUpgradeTip,
    Layer = UILayer.Info,
    Ctrl = require "UI.UIBuildUpgradeTip.Controller.UIBuildUpgradeTipCtrl",
    View = require "UI.UIBuildUpgradeTip.View.UIBuildUpgradeTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UIUpgradeSuccess.prefab",
}

return {
    -- 配置
    UIBuildUpgradeTip = UIBuildUpgradeTip,
}