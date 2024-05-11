--- Created by shimin.
--- DateTime: 2024/3/7 17:29
--- 引导红色警告

local UIGuideRedScreenEffect = {
    Name = UIWindowNames.UIGuideRedScreenEffect,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideRedScreenEffect.Controller.UIGuideRedScreenEffectCtrl",
    View = require "UI.UIGuideRedScreenEffect.View.UIGuideRedScreenEffectView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideRedScreenEffect.prefab",
}

return {
    -- 配置
    UIGuideRedScreenEffect = UIGuideRedScreenEffect,
}
