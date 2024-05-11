
-- 窗口配置
local UICrossDesertServer = {
    Name = UIWindowNames.UICrossDesertServer,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UICrossDesertServer.Controller.UICrossDesertServerCtrl",
    View = require "UI.UICrossDesertServer.View.UICrossDesertServerView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/CrossServerDesert/UICrossDesertServer.prefab",
}

return {
    -- 配置
    UICrossDesertServer = UICrossDesertServer
}