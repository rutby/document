--- Created by shimin
--- DateTime: 2023/6/9 11:00
--- 英雄插件属性详情界面

local UIHeroPluginUpgradeInfo = {
    Name = UIWindowNames.UIHeroPluginUpgradeInfo,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginUpgradeInfo.Controller.UIHeroPluginUpgradeInfoCtrl",
    View = require "UI.UIHeroPluginUpgradeInfo.View.UIHeroPluginUpgradeInfoView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUpgradeInfo.prefab",
}

return {
    -- 配置
    UIHeroPluginUpgradeInfo = UIHeroPluginUpgradeInfo,
}