---
--- 黑骑士信息（点击遗迹城）
--- Created by shimin.
--- DateTime: 2023/3/7 22:25
---

local UIALVSDonateSoldierInfo =
{
    Name = UIWindowNames.UIALVSDonateSoldierInfo,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIALVSDonateSoldier.UIALVSDonateSoldierInfo.Controller.UIALVSDonateSoldierInfoCtrl",
    View = require "UI.UIALVSDonateSoldier.UIALVSDonateSoldierInfo.View.UIALVSDonateSoldierInfoView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIALVSDonateSoldier/UIALVSDonateSoldierInfo.prefab",
}

return
{
    UIALVSDonateSoldierInfo = UIALVSDonateSoldierInfo,
}