---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/12 16:49
---
local UIWorldNewsAbbrDetail = {
    Name = UIWindowNames.UIWorldNewsAbbrDetail,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIWorldNewsAbbrDetail.Controller.UIWorldNewsAbbrDetailCtrl",
    View = require "UI.UIWorldNewsAbbrDetail.View.UIWorldNewsAbbrDetailView",
    PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldNewsAbbrDetail.prefab",
}

return {
    -- 配置
    UIWorldNewsAbbrDetail = UIWorldNewsAbbrDetail,
}