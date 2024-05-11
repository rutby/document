--- Created by shimin
--- DateTime: 2023/6/2 14:58
--- 英雄界面点击插件按钮弹出界面

local UIHeroPluginTip = {
    Name = UIWindowNames.UIHeroPluginTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginTip.Controller.UIHeroPluginTipCtrl",
    View = require "UI.UIHeroPluginTip.View.UIHeroPluginTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginTip.prefab",
}

return {
    -- 配置
    UIHeroPluginTip = UIHeroPluginTip,
}