--- Created by shimin
--- DateTime: 2023/10/31 15:50
--- 德雷克boss使用道具界面

local UIDrakeBossUseItem = {
    Name = UIWindowNames.UIDrakeBossUseItem,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIDrakeBossUseItem.Controller.UIDrakeBossUseItemCtrl",
    View = require "UI.UIDrakeBossUseItem.View.UIDrakeBossUseItemView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIItem/UIDrakeBossUseItem.prefab",
}

return {
    -- 配置
    UIDrakeBossUseItem = UIDrakeBossUseItem,
}