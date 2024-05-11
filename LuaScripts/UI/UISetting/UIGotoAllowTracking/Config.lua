-- 进入PVE
local UIGotoAllowTracking = {
    Name = UIWindowNames.UIGotoAllowTracking,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UIGotoAllowTracking.Controller.UIGotoAllowTrackingCtrl",
    View = require "UI.UISetting.UIGotoAllowTracking.View.UIGotoAllowTrackingView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIGotoAllowTracking.prefab",
}


return {
    -- 配置
    UIGotoAllowTracking = UIGotoAllowTracking
}