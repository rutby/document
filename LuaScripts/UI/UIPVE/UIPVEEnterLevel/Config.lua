-- 进入PVE
local UIPVEEnterLevel = {
    Name = UIWindowNames.UIPVEEnterLevel,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPVE.UIPVEEnterLevel.Controller.UIPVEEnterLevelCtrl",
    View = require "UI.UIPVE.UIPVEEnterLevel.View.UIPVEEnterLevelView",
    PrefabPath = "Assets/Main/Prefabs/PVE/UIPVEEnterLevel.prefab",
}


return {
    -- 配置
    UIPVEEnterLevel = UIPVEEnterLevel
}