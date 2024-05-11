--- Created by shimin
--- DateTime: 2023/6/6 21:12
--- 英雄插件交换界面

local UIHeroPluginChange = {
    Name = UIWindowNames.UIHeroPluginChange,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginChange.Controller.UIHeroPluginChangeCtrl",
    View = require "UI.UIHeroPluginChange.View.UIHeroPluginChangeView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginChange.prefab",
}

return {
    -- 配置
    UIHeroPluginChange = UIHeroPluginChange,
}