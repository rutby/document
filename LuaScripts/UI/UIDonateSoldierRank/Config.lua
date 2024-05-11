---
--- 捐兵活动战斗排行榜
--- Created by shimin.
--- DateTime: 2023/3/7 10:55
---

local UIDonateSoldierRank =
{
    Name = UIWindowNames.UIDonateSoldierRank,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIDonateSoldierRank.Controller.UIDonateSoldierRankCtrl",
    View = require "UI.UIDonateSoldierRank.View.UIDonateSoldierRankView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDonateSoldier/UIDonateSoldierRank.prefab",
}

return
{
    UIDonateSoldierRank = UIDonateSoldierRank,
}