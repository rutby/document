---
--- 捐兵黑骑士
--- Created by shimin.
--- DateTime: 2023/3/7 10:55
---

local UIALVSDonateSoldierInfoCtrl = BaseClass("UIALVSDonateSoldierInfoCtrl", UIBaseCtrl)
function UIALVSDonateSoldierInfoCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIALVSDonateSoldierInfo)
end

return UIALVSDonateSoldierInfoCtrl