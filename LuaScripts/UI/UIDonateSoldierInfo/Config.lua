---
--- 黑骑士信息（点击遗迹城）
--- Created by shimin.
--- DateTime: 2023/3/7 22:25
---

local UIDonateSoldierInfo =
{
    Name = UIWindowNames.UIDonateSoldierInfo,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIDonateSoldierInfo.Controller.UIDonateSoldierInfoCtrl",
    View = require "UI.UIDonateSoldierInfo.View.UIDonateSoldierInfoView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDonateSoldier/UIDonateSoldierInfo.prefab",
}

return
{
    UIDonateSoldierInfo = UIDonateSoldierInfo,
}