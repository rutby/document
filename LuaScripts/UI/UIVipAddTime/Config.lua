---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 4/2/2024 上午10:05
---
local UIVipAddTime = {
    Name = UIWindowNames.UIVipAddTime,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIVipAddTime.Controller.UIVipAddTimeCtrl",
    View = require "UI.UIVipAddTime.View.UIVipAddTimeView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIVip/UIVipAddTime.prefab",
}

return {
    -- 配置
    UIVipAddTime = UIVipAddTime,
}