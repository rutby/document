---
--- Created by shimin.
--- DateTime: 2021/10/20 17:43
---

local UIShowBlackCtrl = BaseClass("UIShowBlackCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIShowBlack,{ anim = true , playEffect = false})
end

UIShowBlackCtrl.CloseSelf = CloseSelf

return UIShowBlackCtrl