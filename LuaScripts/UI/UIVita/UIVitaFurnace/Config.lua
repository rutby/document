---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/8 17:55
---

local UIVitaFurnace =
{
    Name = UIWindowNames.UIVitaFurnace,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIVita.UIVitaFurnace.Controller.UIVitaFurnaceCtrl",
    View = require "UI.UIVita.UIVitaFurnace.View.UIVitaFurnaceView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIVita/UIVitaFurnace.prefab",
}

return
{
    UIVitaFurnace = UIVitaFurnace,
}