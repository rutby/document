---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Still4.
--- DateTime: 2021/6/29 16:02
---
local UIPositionTip = {
    Name = UIWindowNames.UIPositionTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPositionTip.Controller.UIPositionTipCtrl",
    View = require "UI.UIPositionTip.View.UIPositionTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/World/UIPositionTips.prefab",
}

return {
    UIPositionTip = UIPositionTip
}