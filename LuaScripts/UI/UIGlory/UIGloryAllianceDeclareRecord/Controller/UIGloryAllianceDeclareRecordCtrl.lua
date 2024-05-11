---
--- 荣耀之战宣战记录
--- Created by shimin.
--- DateTime: 2023/3/2 17:33
---

local UIGloryAllianceDeclareRecordCtrl = BaseClass("UIGloryAllianceDeclareRecordCtrl", UIBaseCtrl)
function UIGloryAllianceDeclareRecordCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryAllianceDeclareRecord)
end

return UIGloryAllianceDeclareRecordCtrl