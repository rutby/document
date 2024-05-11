
-- 窗口配置
local UIHeroPosterExchangePop = {
    Name = UIWindowNames.UIHeroPosterExchangePop,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIHero2.UIHeroPosterExchangePop.Controller.UIHeroPosterExchangePopCtrl",
    View = require "UI.UIHero2.UIHeroPosterExchangePop.View.UIHeroPosterExchangePopView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPosterExchangePop.prefab",
}

return {
    -- 配置
    UIHeroPosterExchangePop = UIHeroPosterExchangePop,
}