---
--- Created by shimin.
--- DateTime: 2021/6/18 16:35
---

local UINoInputCtrl = BaseClass("UINoInputCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UINoInput,{ anim = false , playEffect = false})
end

UINoInputCtrl.CloseSelf = CloseSelf

return UINoInputCtrl