---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/14 21:45
---
local UIMoving = {
    Name = UIWindowNames.UIMoving,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIMoving.Controller.UIMovingCtrl",
    View = require "UI.UIMoving.View.UIMovingView",
    PrefabPath = "Assets/Main/Prefabs/UI/World/UIMoving.prefab",
}

return {
    -- 配置
    UIMoving = UIMoving,
}