---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/2 20:20
---
local UIRankDetailList = {
    Name = UIWindowNames.UIRankDetailList,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIRank.UIRankDetailList.Controller.UIRankDetailListCtrl",
    View = require "UI.UIRank.UIRankDetailList.View.UIRankDetailListView",
    PrefabPath = "Assets/Main/Prefabs/UI/Set/UIRankDetailList.prefab",
}

return {
    -- 配置
    UIRankDetailList = UIRankDetailList
}