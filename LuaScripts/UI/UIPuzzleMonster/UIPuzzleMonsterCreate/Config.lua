---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/6/8 16:25
---

local UIPuzzleMonsterCreate = {
    Name = UIWindowNames.UIPuzzleMonsterCreate,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPuzzleMonster.UIPuzzleMonsterCreate.Controller.UIPuzzleMonsterCreateCtrl",
    View = require "UI.UIPuzzleMonster.UIPuzzleMonsterCreate.View.UIPuzzleMonsterCreateView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIPuzzleMonster/UIPuzzleMonsterCreate.prefab",
}

return {
    -- 配置
    UIPuzzleMonsterCreate = UIPuzzleMonsterCreate,
}
