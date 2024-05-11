
-- 窗口配置
local UIActDragonBattleTime = {
    Name = UIWindowNames.UIActDragonBattleTime,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIActDragon.UIActDragonBattleTime.Controller.UIActDragonBattleTimeCtrl",
    View = require "UI.UIActDragon.UIActDragonBattleTime.View.UIActDragonBattleTimeView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DragonAct/UIActDragonBattleTime.prefab",
}

return {
    -- 配置
    UIActDragonBattleTime = UIActDragonBattleTime
}