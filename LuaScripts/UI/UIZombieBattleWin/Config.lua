---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2022/11/30 12:52
---

local UIZombieBattleWin = {
    Name = UIWindowNames.UIZombieBattleWin,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIZombieBattleWin.Controller.UIZombieBattleWinCtrl",
    View = require "UI.UIZombieBattleWin.View.UIZombieBattleWinView",
    PrefabPath = "Assets/Main/Prefabs/UI/LWStage/LWBattleWinPanel.prefab",
}

return {
    -- 配置
    UIZombieBattleWin = UIZombieBattleWin,
}