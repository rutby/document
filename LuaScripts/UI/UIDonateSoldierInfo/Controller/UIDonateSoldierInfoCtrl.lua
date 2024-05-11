---
--- 捐兵黑骑士
--- Created by shimin.
--- DateTime: 2023/3/7 10:55
---

local UIDonateSoldierInfo = BaseClass("UIDonateSoldierInfo", UIBaseCtrl)
function UIDonateSoldierInfo:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDonateSoldierInfo)
end

return UIDonateSoldierInfo