---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/9/6 15:11
---
local UIPing = {
    Name = UIWindowNames.UIPing,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UIPing.Controller.UIPingCtrl",
    View = require "UI.UISetting.UIPing.View.UIPingView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UIPing.prefab",
}

return {
    -- 配置
    UIPing = UIPing,
}