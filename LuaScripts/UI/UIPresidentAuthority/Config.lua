---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/4/8 18:29
---

local UIPresidentAuthority = {
    Name = UIWindowNames.UIPresidentAuthority,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPresidentAuthority.Controller.UIPresidentAuthorityCtrl",
    View = require "UI.UIPresidentAuthority.View.UIPresidentAuthorityView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIPresidentAuthority/UIPresidentAuthority.prefab",
}

return {
    UIPresidentAuthority = UIPresidentAuthority
}