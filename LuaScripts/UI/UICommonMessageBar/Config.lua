---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/9 17:29
---
local UICommonMessageBar = {
    Name = UIWindowNames.UICommonMessageBar,
    Layer = UILayer.Info,
    Ctrl = require "UI.UICommonMessageBar.Controller.UICommonMessageBarCtrl",
    View = require "UI.UICommonMessageBar.View.UICommonMessageBarView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonMessageBar.prefab",
}

return {
    -- 配置
    UICommonMessageBar = UICommonMessageBar,
}