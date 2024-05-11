--- Created by shimin
--- DateTime: 2023/7/21 17:46
--- 英雄勋章/海报兑换最终确认界面

local UIHeroMetalRedemptionConfirmCtrl = BaseClass("UIHeroMetalRedemptionConfirmCtrl", UIBaseCtrl)

function UIHeroMetalRedemptionConfirmCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMetalRedemptionConfirm)
end

return UIHeroMetalRedemptionConfirmCtrl