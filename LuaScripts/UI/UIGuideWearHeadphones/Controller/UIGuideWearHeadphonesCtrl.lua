---
--- Created by GaoFei.
--- DateTime: 2024/04/24 10:51
--- 引导 佩戴耳机提醒
---

local UIGuideWearHeadphonesCtrl = BaseClass("UIGuideWearHeadphonesCtrl", UIBaseCtrl)

function UIGuideWearHeadphonesCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideWearHeadphones,{ anim = true , playEffect = false})
end

return UIGuideWearHeadphonesCtrl