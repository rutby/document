--- 黑骑士奖励
--- Created by shimin.
--- DateTime: 2024/2/23 17:24
---

local UIBlackKnightRewardCtrl = BaseClass("UIBlackKnightRewardCtrl", UIBaseCtrl)
function UIBlackKnightRewardCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackKnightReward)
end

return UIBlackKnightRewardCtrl