--- 黑骑士分数排行榜
--- Created by shimin.
--- DateTime: 2024/2/22 21:01
---

local UIBlackKnightScoreRankCtrl = BaseClass("UIBlackKnightScoreRankCtrl", UIBaseCtrl)
function UIBlackKnightScoreRankCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBlackKnightScoreRank)
end

return UIBlackKnightScoreRankCtrl