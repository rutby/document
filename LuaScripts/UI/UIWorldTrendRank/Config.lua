---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
--- 天下大势
local UIWorldTrendRank = {
    Name = UIWindowNames.UIWorldTrendRank,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIWorldTrendRank.Controller.UIWorldTrendRankCtrl",
    View = require "UI.UIWorldTrendRank.View.UIWorldTrendRankView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/WorldTrend/UIWorldTrendRank.prefab",
}

return {
    UIWorldTrendRank = UIWorldTrendRank,
}