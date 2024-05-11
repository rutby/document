---
--- 荣耀之战设置休战时间
--- Created by shimin.
--- DateTime: 2023/3/2 15:01
---

local UIGloryAllianceSetTruceCtrl = BaseClass("UIGloryAllianceSetTruceCtrl", UIBaseCtrl)
function UIGloryAllianceSetTruceCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryAllianceSetTruce)
end

return UIGloryAllianceSetTruceCtrl