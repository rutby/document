---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/6/16 10:10
---
local UIDragonBuffTip = {
    Name = UIWindowNames.UIDragonBuffTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIDragonBuffTip.Controller.UIDragonBuffTipCtrl",
    View = require "UI.UIDragonBuffTip.View.UIDragonBuffTipView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIDragon/UIDragonBuffTip.prefab",
}

return {
    -- 配置
    UIDragonBuffTip = UIDragonBuffTip,
}