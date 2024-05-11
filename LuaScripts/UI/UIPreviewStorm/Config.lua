--- Created by shimin
--- DateTime: 2023/11/10 14:39
--- 暴风雪预览界面

local UIPreviewStorm = {
    Name = UIWindowNames.UIPreviewStorm,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPreviewStorm.Controller.UIPreviewStormCtrl",
    View = require "UI.UIPreviewStorm.View.UIPreviewStormView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIStorm/UIPreviewStorm.prefab",
}

return {
    -- 配置
    UIPreviewStorm = UIPreviewStorm,
}