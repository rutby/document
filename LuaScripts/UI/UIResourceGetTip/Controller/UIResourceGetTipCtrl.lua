---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---

local UIResourceGetTipCtrl = BaseClass("UIResourceGetTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceGetTip,{ anim = false, playEffect = false})
end

UIResourceGetTipCtrl.CloseSelf = CloseSelf

return UIResourceGetTipCtrl