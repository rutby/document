---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/2/28 21:33
---

local UIPoliceStation =
{
    Name = UIWindowNames.UIPoliceStation,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPoliceStation.Controller.UIPoliceStationCtrl",
    View = require "UI.UIPoliceStation.View.UIPoliceStationView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIPoliceStation.prefab",
}

return
{
    -- 配置
    UIPoliceStation = UIPoliceStation
}