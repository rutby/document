---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/22 14:12
---
local UIAllianceOfficeSelect = {
    Name = UIWindowNames.UIAllianceOfficeSelect,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAlliance.UIAllianceOfficeSelect.Controller.UIAllianceOfficeSelectCtrl",
    View = require "UI.UIAlliance.UIAllianceOfficeSelect.View.UIAllianceOfficeSelectView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/Alliance/UIAllianceOfficeSelect.prefab",
}

return {
    -- 配置
    UIAllianceOfficeSelect = UIAllianceOfficeSelect
}