--- Created by shimin.
--- DateTime: 2024/3/7 17:27
--- 引导风沙

local UIGuideWindScreenEffect = {
    Name = UIWindowNames.UIGuideWindScreenEffect,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideWindScreenEffect.Controller.UIGuideWindScreenEffectCtrl",
    View = require "UI.UIGuideWindScreenEffect.View.UIGuideWindScreenEffectView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideWindScreenEffect.prefab",
}

return {
    -- 配置
    UIGuideWindScreenEffect = UIGuideWindScreenEffect,
}
