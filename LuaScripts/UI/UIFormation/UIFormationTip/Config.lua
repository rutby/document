---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/1/13 15:04
---
local UIFormationTip = {
    Name = UIWindowNames.UIFormationTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIFormation.UIFormationTip.Controller.UIFormationTipCtrl",
    View = require "UI.UIFormation.UIFormationTip.View.UIFormationTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIFormationTip.prefab",
}

return {
    -- 配置
    UIFormationTip = UIFormationTip
}