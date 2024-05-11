--
-- 断线重连
--
local UIDisconnect = {
    Name = UIWindowNames.UIDisconnect,
    Layer = UILayer.TopMost,
    Ctrl = require "UI.UIDisconnect.Controller.UIDisconnectCtrl",
    View = require "UI.UIDisconnect.View.UIDisconnectView",
    PrefabPath = "Assets/Main/Prefabs/UI/DisconnectView.prefab",
}

return {
    UIDisconnect = UIDisconnect,
}