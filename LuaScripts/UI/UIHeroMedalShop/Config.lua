---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/11/15 15:54
---

local UIHeroMedalShop = {
    Name = UIWindowNames.UIHeroMedalShop,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIHeroMedalShop.Controller.UIHeroMedalShopCtrl",
    View = require "UI.UIHeroMedalShop.View.UIHeroMedalShopView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIHeroMedalShop/UIHeroMedalShop.prefab",
}

return {
    -- 配置
    UIHeroMedalShop = UIHeroMedalShop,
}