---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/6 11:10
---
-- 窗口配置
local UISearch = {
    Name = UIWindowNames.UISearch,
    Layer = UILayer.Background,
    Ctrl = require "UI.UISearch.Controller.UISearchCtrl",
    View = require "UI.UISearch.View.UISearchView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UISearch/UISearch.prefab",
}

return {
    -- 配置
    UISearch = UISearch,
}