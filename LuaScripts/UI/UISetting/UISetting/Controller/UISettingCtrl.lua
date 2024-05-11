---
--- Created by shimin.
--- DateTime: 2020/9/21 17:16
---

local UISettingCtrl = BaseClass("UISettingCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting,{ anim = true ,isBlur = true})
end

local function CloseAll(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UISetting,{ anim = true ,isBlur = true})
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerInfo)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UISettingCtrl.CloseSelf = CloseSelf
UISettingCtrl.Close = Close
UISettingCtrl.CloseAll = CloseAll
return UISettingCtrl