---
--- Created by shimin.
--- DateTime: 2020/9/22 12:107
---

local UISettingNoticeCtrl = BaseClass("UISettingNoticeCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingNotice)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UISettingNoticeCtrl.CloseSelf = CloseSelf
UISettingNoticeCtrl.Close = Close

return UISettingNoticeCtrl