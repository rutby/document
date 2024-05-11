--- Created by shimin
--- DateTime: 2023/7/20 11:10
--- 英雄兑换勋章/海报/商店界面

local UIHeroMetalRedemption = {
    Name = UIWindowNames.UIHeroMetalRedemption,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroMetalRedemption.Controller.UIHeroMetalRedemptionCtrl",
    View = require "UI.UIHeroMetalRedemption.View.UIHeroMetalRedemptionView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroMetalRedemption.prefab",
}

return {
    -- 配置
    UIHeroMetalRedemption = UIHeroMetalRedemption,
}