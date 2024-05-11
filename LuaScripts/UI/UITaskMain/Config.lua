
local UITaskMain = {
    Name = UIWindowNames.UITaskMain,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UITaskMain.Ctrl.UITaskMainCtrl",
    View = require "UI.UITaskMain.View.UITaskMainView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UITask/UITaskMain.prefab",
}

return {
    -- 配置
    UITaskMain = UITaskMain,
}