---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/4/27 20:32
---

local UIPVELoading = {
    Name = UIWindowNames.UIPVELoading,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPVE.UIPVELoading.Controller.UIPVELoadingCtrl",
    View = require "UI.UIPVE.UIPVELoading.View.UIPVELoadingView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVELoading.prefab",
}

return {
    -- 配置
    UIPVELoading = UIPVELoading,
}