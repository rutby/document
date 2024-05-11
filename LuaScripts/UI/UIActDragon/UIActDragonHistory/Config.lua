
-- 窗口配置
local UIActDragonHistory = {
    Name = UIWindowNames.UIActDragonHistory,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIActDragon.UIActDragonHistory.Controller.UIActDragonHistoryCtrl",
    View = require "UI.UIActDragon.UIActDragonHistory.View.UIActDragonHistoryView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DragonAct/UIActDragonHistory.prefab",
}

return {
    -- 配置
    UIActDragonHistory = UIActDragonHistory
}