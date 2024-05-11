--- Created by shimin
--- DateTime: 2023/9/26 17:25
--- 推翻胡蒂尔页面

local UIOverthrowHudier = {
    Name = UIWindowNames.UIOverthrowHudier,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIOverthrowHudier.Controller.UIOverthrowHudierCtrl",
    View = require "UI.UIOverthrowHudier.View.UIOverthrowHudierView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIOverthrowHudier/UIOverthrowHudier.prefab",
}

return {
    -- 配置
    UIOverthrowHudier = UIOverthrowHudier,
}