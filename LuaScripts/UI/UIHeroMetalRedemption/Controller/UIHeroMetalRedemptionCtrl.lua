--- Created by shimin
--- DateTime: 2023/7/20 11:10
--- 英雄兑换勋章/海报/商店界面

local UIHeroMetalRedemptionCtrl = BaseClass("UIHeroMetalRedemptionCtrl", UIBaseCtrl)

function UIHeroMetalRedemptionCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMetalRedemption)
end

return UIHeroMetalRedemptionCtrl