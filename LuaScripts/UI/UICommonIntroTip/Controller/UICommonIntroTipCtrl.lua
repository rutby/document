---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2021/11/4 21:02
---

local UICommonIntroTipCtrl = BaseClass("UICommonIntroTipCtrl", UIBaseCtrl)
function UICommonIntroTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonIntroTip)
end

return UICommonIntroTipCtrl