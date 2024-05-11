---
--- Created by shimin.
--- DateTime: 2021/7/14 15:44
---

local UIResourceCostCtrl = BaseClass("UIResourceCostCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceCost)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Scene)
end


UIResourceCostCtrl.CloseSelf = CloseSelf
UIResourceCostCtrl.Close = Close

return UIResourceCostCtrl