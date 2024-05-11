---
--- Created by shimin.
--- DateTime: 2020/9/25 19:05
---

local UISettingFlagCtrl = BaseClass("UISettingFlagCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingFlag)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UISettingFlagCtrl.CloseSelf = CloseSelf
UISettingFlagCtrl.Close = Close

return UISettingFlagCtrl