---
--- Created by shimin.
--- DateTime: 2020/9/25 17:56
---

local UISettingSetCtrl = BaseClass("UISettingSetCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingSet)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UISettingSetCtrl.CloseSelf = CloseSelf
UISettingSetCtrl.Close = Close

return UISettingSetCtrl