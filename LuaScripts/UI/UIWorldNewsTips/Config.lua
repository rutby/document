---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/29 16:50
---
local UIWorldNewsTips = {
    Name = UIWindowNames.UIWorldNewsTips,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIWorldNewsTips.Controller.UIWorldNewsTipsCtrl",
    View = require "UI.UIWorldNewsTips.View.UIWorldNewsTipsView",
    PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldBattleNewsTip.prefab",
}

return {
    -- 配置
    UIWorldNewsTips = UIWorldNewsTips,
}