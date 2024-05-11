---
--- Created by shimin.
--- DateTime: 2021/8/19 14:34
---

local UIGuideArrowCtrl = BaseClass("UIGuideArrowCtrl", UIBaseCtrl)

function UIGuideArrowCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideArrow,{ anim = false , playEffect = false})
end

return UIGuideArrowCtrl