---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/16 17:35
---

local UIRobotPack = {
    Name = UIWindowNames.UIRobotPack,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIRobotPack.Controller.UIRobotPackCtrl",
    View = require "UI.UIRobotPack.View.UIRobotPackView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIRobotPack/UIRobotPack.prefab",
}

return {
    UIRobotPack = UIRobotPack,
}