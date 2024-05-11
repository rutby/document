---
--- 黑骑士排行榜
--- Created by shimin.
--- DateTime: 2023/3/7 10:55
---

local UIDonateSoldierRankCtrl = BaseClass("UIDonateSoldierRankCtrl", UIBaseCtrl)
function UIDonateSoldierRankCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDonateSoldierRank)
end

return UIDonateSoldierRankCtrl