--- Created by shimin
--- DateTime: 2023/6/2 14:58
--- 英雄界面点击插件按钮弹出界面

local UIHeroPluginInfo = {
    Name = UIWindowNames.UIHeroPluginInfo,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginInfo.Controller.UIHeroPluginInfoCtrl",
    View = require "UI.UIHeroPluginInfo.View.UIHeroPluginInfoView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginInfo.prefab",
}

return {
    -- 配置
    UIHeroPluginInfo = UIHeroPluginInfo,
}