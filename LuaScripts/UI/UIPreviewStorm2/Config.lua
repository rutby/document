--- Created by shimin
--- DateTime: 2023/11/10 14:39
--- 暴风雪预览界面

local UIPreviewStorm2 = {
    Name = UIWindowNames.UIPreviewStorm2,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPreviewStorm2.Controller.UIPreviewStorm2Ctrl",
    View = require "UI.UIPreviewStorm2.View.UIPreviewStorm2View",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIStorm/UIPreviewStorm2.prefab",
}

return {
    -- 配置
    UIPreviewStorm2 = UIPreviewStorm2,
}