---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/2 14:01
---
local UIDetectEvent = {
    Name = UIWindowNames.UIDetectEvent,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIRadarCenter.UIDetectEvent.Controller.UIDetectEventCtrl",
    View = require "UI.UIRadarCenter.UIDetectEvent.View.UIDetectEventView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIRadarCenter/UIDetectEvent.prefab",
}

return {
    UIDetectEvent = UIDetectEvent
}