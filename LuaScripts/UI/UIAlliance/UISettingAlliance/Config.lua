---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/10 21:26
---
local UISettingAlliance = {
    Name = UIWindowNames.UISettingAlliance,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAlliance.UISettingAlliance.Controller.UISettingAllianceCtrl",
    View = require "UI.UIAlliance.UISettingAlliance.View.UISettingAllianceView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/Alliance/UISettingAlliance.prefab",
}

return {
    -- 配置
    UISettingAlliance = UISettingAlliance
}