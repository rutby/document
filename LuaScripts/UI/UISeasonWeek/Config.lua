---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/14 16:34
---

local UISeasonWeek =
{
    Name = UIWindowNames.UISeasonWeek,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISeasonWeek.Controller.UISeasonWeekCtrl",
    View = require "UI.UISeasonWeek.View.UISeasonWeekView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UISeasonWeek/UISeasonWeek.prefab",
}

return
{
    UISeasonWeek = UISeasonWeek,
}