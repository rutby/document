---
--- Created by shimin.
--- DateTime: 2020/9/27 14:59
---

local UISettingRedemptionCodeCtrl = BaseClass("UISettingRedemptionCodeCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingRedemptionCode)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UISettingRedemptionCodeCtrl.CloseSelf = CloseSelf
UISettingRedemptionCodeCtrl.Close = Close

return UISettingRedemptionCodeCtrl