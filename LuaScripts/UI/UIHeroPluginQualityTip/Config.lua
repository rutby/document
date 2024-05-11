--- Created by shimin
--- DateTime: 2023/7/17 20:38
--- 英雄插件品质详情界面

local UIHeroPluginQualityTip = {
    Name = UIWindowNames.UIHeroPluginQualityTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginQualityTip.Controller.UIHeroPluginQualityTipCtrl",
    View = require "UI.UIHeroPluginQualityTip.View.UIHeroPluginQualityTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginQualityTip.prefab",
}

return {
    -- 配置
    UIHeroPluginQualityTip = UIHeroPluginQualityTip,
}