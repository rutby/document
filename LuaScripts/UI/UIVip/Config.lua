--- Created by shimin
--- DateTime: 2024/1/11 10:25
--- Vip界面

local UIVip = {
    Name = UIWindowNames.UIVip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIVip.Controller.UIVipCtrl",
    View = require "UI.UIVip.View.UIVipView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIVip/UIVip.prefab",
}

return {
    -- 配置
    UIVip = UIVip,
}