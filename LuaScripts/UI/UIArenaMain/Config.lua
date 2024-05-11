--- Created by shimin
--- DateTime: 2023/12/6 12:01
--- 竞技场界面
local UIArenaMain = {
    Name = UIWindowNames.UIArenaMain,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIArenaMain.Controller.UIArenaMainCtrl",
    View = require "UI.UIArenaMain.View.UIArenaMainView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/Arena/ArenaMain.prefab",
}

return {
    -- 配置
    UIArenaMain = UIArenaMain,
}