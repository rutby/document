---
--- Created by shimin.
--- DateTime: 2021/10/20 18:07
---

local UIGuideTipCtrl = BaseClass("UIGuideTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideTip,{ anim = true , playEffect = false})
end

UIGuideTipCtrl.CloseSelf = CloseSelf

return UIGuideTipCtrl