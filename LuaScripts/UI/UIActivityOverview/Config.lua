---
--- 任务页面
--- Created by zzl.
--- DateTime: 
---
-- 窗口配置
local UIActivityOverview = {
    Name = UIWindowNames.UIActivityOverview,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIActivityOverview.Controller.UIActivityOverviewCtrl",
    View = require "UI.UIActivityOverview.View.UIActivityOverviewView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIActivityOverview/UIActivityOverview.prefab",
}

return {
    -- 配置
    UIActivityOverview = UIActivityOverview,
}