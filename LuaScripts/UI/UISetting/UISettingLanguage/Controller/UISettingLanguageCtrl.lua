---
--- Created by shimin.
--- DateTime: 2020/9/23 19:03
---

local UISettingLanguageCtrl = BaseClass("UISettingLanguageCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingLanguage)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UISettingLanguageCtrl.CloseSelf = CloseSelf
UISettingLanguageCtrl.Close = Close

return UISettingLanguageCtrl