---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/7/14 11:12
---
local UIHeroBountyMain = {
    Name = UIWindowNames.UIHeroBountyMain,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIHeroBountyMain.Controller.UIHeroBountyMainCtrl",
    View = require "UI.UIHeroBountyMain.View.UIHeroBountyMainView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroOfferRewardFirst.prefab",
}

return {
    -- 配置
    UIHeroBountyMain = UIHeroBountyMain,
}