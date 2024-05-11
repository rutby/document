
-- 窗口配置
local UIActDragonRule = {
    Name = UIWindowNames.UIActDragonRule,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIActDragon.UIActDragonRule.Controller.UIActDragonRuleCtrl",
    View = require "UI.UIActDragon.UIActDragonRule.View.UIActDragonRuleView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DragonAct/UIActDragonRule.prefab",
}

return {
    -- 配置
    UIActDragonRule = UIActDragonRule
}