---
--- Created by shimin.
--- DateTime: 2020/9/27 18:40
---

local UISettingBlockCtrl = BaseClass("UISettingBlockCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingBlock)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UISettingBlockCtrl.CloseSelf = CloseSelf
UISettingBlockCtrl.Close = Close

return UISettingBlockCtrl