---
--- 黑骑士排行榜
--- Created by shimin.
--- DateTime: 2023/3/7 10:55
---

local UIBlackKnightInfoCtrl = BaseClass("UIBlackKnightInfoCtrl", UIBaseCtrl)
function UIBlackKnightInfoCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackKnightInfo)
end

return UIBlackKnightInfoCtrl