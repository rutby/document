--- Created by shimin
--- DateTime: 2023/7/18 20:30
--- --- 英雄插件品质升级成功界面

local UIHeroPluginUpgradeQualitySuccess = {
    Name = UIWindowNames.UIHeroPluginUpgradeQualitySuccess,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginUpgradeQualitySuccess.Controller.UIHeroPluginUpgradeQualitySuccessCtrl",
    View = require "UI.UIHeroPluginUpgradeQualitySuccess.View.UIHeroPluginUpgradeQualitySuccessView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeQualitySuccess.prefab",
}

return {
    -- 配置
    UIHeroPluginUpgradeQualitySuccess = UIHeroPluginUpgradeQualitySuccess,
}