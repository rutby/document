--- Created by shimin
--- DateTime: 2023/7/20 21:46
--- 英雄勋章/海报兑换选择数量界面

local UIHeroMetalRedemptionSelectCount = {
    Name = UIWindowNames.UIHeroMetalRedemptionSelectCount,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroMetalRedemptionSelectCount.Controller.UIHeroMetalRedemptionSelectCountCtrl",
    View = require "UI.UIHeroMetalRedemptionSelectCount.View.UIHeroMetalRedemptionSelectCountView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroMetalRedemptionSelectCount.prefab",
}

return {
    -- 配置
    UIHeroMetalRedemptionSelectCount = UIHeroMetalRedemptionSelectCount,
}