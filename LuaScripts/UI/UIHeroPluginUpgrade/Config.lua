--- Created by shimin
--- DateTime: 2023/6/5 18:36
--- 英雄插件升级界面

local UIHeroPluginUpgrade = {
    Name = UIWindowNames.UIHeroPluginUpgrade,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginUpgrade.Controller.UIHeroPluginUpgradeCtrl",
    View = require "UI.UIHeroPluginUpgrade.View.UIHeroPluginUpgradeView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgrade.prefab",
}

return {
    -- 配置
    UIHeroPluginUpgrade = UIHeroPluginUpgrade,
}