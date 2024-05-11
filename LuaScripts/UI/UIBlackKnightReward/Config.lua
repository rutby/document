--- 黑骑士奖励
--- Created by shimin.
--- DateTime: 2024/2/23 17:24
---

local UIBlackKnightReward =
{
    Name = UIWindowNames.UIBlackKnightReward,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIBlackKnightReward.Controller.UIBlackKnightRewardCtrl",
    View = require "UI.UIBlackKnightReward.View.UIBlackKnightRewardView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIBlackKnight/UIBlackKnightReward.prefab",
}

return
{
    UIBlackKnightReward = UIBlackKnightReward,
}