---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/9 14:45
---
local UICommonVersionUpdate = {
    Name = UIWindowNames.UICommonVersionUpdate,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UICommonVersionUpdate.Controller.UICommonVersionUpdateCtrl",
    View = require "UI.UICommonVersionUpdate.View.UICommonVersionUpdateView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonVersionUpdate.prefab",
}

return {
    -- 配置
    UICommonVersionUpdate = UICommonVersionUpdate,
}