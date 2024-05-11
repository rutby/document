--- Created by shimin
--- DateTime: 2023/7/21 17:46
--- 英雄勋章/海报兑换最终确认界面

local UIHeroMetalRedemptionConfirm = {
    Name = UIWindowNames.UIHeroMetalRedemptionConfirm,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroMetalRedemptionConfirm.Controller.UIHeroMetalRedemptionConfirmCtrl",
    View = require "UI.UIHeroMetalRedemptionConfirm.View.UIHeroMetalRedemptionConfirmView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroMetalRedemptionConfirm.prefab",
}

return {
    -- 配置
    UIHeroMetalRedemptionConfirm = UIHeroMetalRedemptionConfirm,
}