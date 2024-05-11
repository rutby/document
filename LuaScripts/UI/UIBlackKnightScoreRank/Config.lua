--- 黑骑士分数排行榜
--- Created by shimin.
--- DateTime: 2024/2/22 21:01
---

local UIBlackKnightScoreRank =
{
    Name = UIWindowNames.UIBlackKnightScoreRank,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIBlackKnightScoreRank.Controller.UIBlackKnightScoreRankCtrl",
    View = require "UI.UIBlackKnightScoreRank.View.UIBlackKnightScoreRankView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIBlackKnight/UIBlackKnightScoreRank.prefab",
}

return
{
    UIBlackKnightScoreRank = UIBlackKnightScoreRank,
}