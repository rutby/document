---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/10/28 14:11
---
local UIActivityRewardTip = {
    Name = UIWindowNames.UIActivityRewardTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIActivityRewardTip.Controller.UIActivityRewardTipCtrl",
    View = require "UI.UIActivityRewardTip.View.UIActivityRewardTipView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIActivityCollect/UIActivityRewardTip.prefab",
}

return {
    UIActivityRewardTip = UIActivityRewardTip,
}