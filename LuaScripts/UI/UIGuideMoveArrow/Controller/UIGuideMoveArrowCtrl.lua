---
--- Created by shimin.
--- DateTime: 2021/8/25 21:23
---

local UIGuideMoveArrowCtrl = BaseClass("UIGuideMoveArrowCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideMoveArrow,{ anim = false , playEffect = false})
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Guide)
end


UIGuideMoveArrowCtrl.CloseSelf = CloseSelf
UIGuideMoveArrowCtrl.Close = Close

return UIGuideMoveArrowCtrl