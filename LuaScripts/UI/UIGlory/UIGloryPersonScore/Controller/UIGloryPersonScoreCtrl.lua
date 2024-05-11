---
--- 荣耀之战个人积分详情
--- Created by shimin.
--- DateTime: 2023/3/2 10:51
---

local UIGloryPersonScoreCtrl = BaseClass("UIGloryPersonScoreCtrl", UIBaseCtrl)
function UIGloryPersonScoreCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryPersonScore)
end

return UIGloryPersonScoreCtrl