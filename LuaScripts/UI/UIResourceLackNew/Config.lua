---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/9/8 18:27
---
local UIResourceLackNew = {
    Name = UIWindowNames.UIResourceLackNew,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIResourceLackNew.Controller.UIResourceLackNewCtrl",
    View = require "UI.UIResourceLackNew.View.UIResourceLackNewView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIResource/UIResourceLackNew.prefab",
}

return {
    -- 配置
    UIResourceLackNew = UIResourceLackNew,
}