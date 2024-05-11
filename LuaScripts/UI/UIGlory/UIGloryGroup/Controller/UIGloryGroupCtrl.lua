---
--- 荣耀之战联赛分组
--- Created by shimin.
--- DateTime: 2023/2/28 18:56
---

local UIGloryGroupCtrl = BaseClass("UIGloryGroupCtrl", UIBaseCtrl)
function UIGloryGroupCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryGroup)
end

return UIGloryGroupCtrl