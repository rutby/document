---
--- Created by shimin.
--- DateTime: 2021/6/18 16:35
---

local UIArrowCtrl = BaseClass("UIArrowCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrow)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Guide)
end


UIArrowCtrl.CloseSelf = CloseSelf
UIArrowCtrl.Close = Close

return UIArrowCtrl