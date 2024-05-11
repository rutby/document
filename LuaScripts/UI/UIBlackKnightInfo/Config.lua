---
--- 黑骑士信息（点击遗迹城）
--- Created by shimin.
--- DateTime: 2023/3/7 22:25
---

local UIBlackKnightInfo =
{
    Name = UIWindowNames.UIBlackKnightInfo,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIBlackKnightInfo.Controller.UIBlackKnightInfoCtrl",
    View = require "UI.UIBlackKnightInfo.View.UIBlackKnightInfoView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIBlackKnight/UIBlackKnightInfo.prefab",
}

return
{
    UIBlackKnightInfo = UIBlackKnightInfo,
}