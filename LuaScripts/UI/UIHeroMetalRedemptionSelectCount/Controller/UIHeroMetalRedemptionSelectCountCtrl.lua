--- Created by shimin
--- DateTime: 2023/7/20 21:46
--- 英雄勋章/海报兑换选择数量界面

local UIHeroMetalRedemptionSelectCountCtrl = BaseClass("UIHeroMetalRedemptionSelectCountCtrl", UIBaseCtrl)

function UIHeroMetalRedemptionSelectCountCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMetalRedemptionSelectCount)
end

return UIHeroMetalRedemptionSelectCountCtrl