---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/9/29 14:45
---
local UIFormationTableNew = {
    Name = UIWindowNames.UIFormationTableNew,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIFormation.UIFormationTableNew.Controller.UIFormationTableNewCtrl",
    View = require "UI.UIFormation.UIFormationTableNew.View.UIFormationTableNewView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIFormation/UIFormationTableNew.prefab",
}

return {
    -- 配置
    UIFormationTableNew = UIFormationTableNew
}