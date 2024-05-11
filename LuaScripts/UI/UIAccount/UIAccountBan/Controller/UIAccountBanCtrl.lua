---
--- Created by shimin.
--- DateTime: 2020/10/23 17:22
---

local UIAccountBanCtrl = BaseClass("UIAccountBanCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAccountBan)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAccountBanCtrl.CloseSelf = CloseSelf
UIAccountBanCtrl.Close = Close

return UIAccountBanCtrl