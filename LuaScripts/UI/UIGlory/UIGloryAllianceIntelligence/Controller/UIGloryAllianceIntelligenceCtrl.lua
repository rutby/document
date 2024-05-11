---
--- 荣耀之战联盟情报
--- Created by shimin.
--- DateTime: 2023/3/1 15:30
---

local UIGloryAllianceIntelligenceCtrl = BaseClass("UIGloryAllianceIntelligenceCtrl", UIBaseCtrl)
function UIGloryAllianceIntelligenceCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryAllianceIntelligence)
end

return UIGloryAllianceIntelligenceCtrl