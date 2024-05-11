--- Created by shimin
--- DateTime: 2023/6/9 19:29
--- 英雄插件解锁界面

local UIHeroPluginUnlock = {
    Name = UIWindowNames.UIHeroPluginUnlock,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginUnlock.Controller.UIHeroPluginUnlockCtrl",
    View = require "UI.UIHeroPluginUnlock.View.UIHeroPluginUnlockView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginUnlock.prefab",
}

return {
    -- 配置
    UIHeroPluginUnlock = UIHeroPluginUnlock,
}