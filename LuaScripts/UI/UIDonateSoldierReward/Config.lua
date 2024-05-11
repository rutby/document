
local UIDonateSoldierReward = {
    Name = UIWindowNames.UIDonateSoldierReward,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIDonateSoldierReward.Controller.UIDonateSoldierRewardCtrl",
    View = require "UI.UIDonateSoldierReward.View.UIDonateSoldierRewardView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIDonateSoldier/UIDonateSoldierRewardPanel.prefab",
}

return {
    -- 配置
    UIDonateSoldierReward = UIDonateSoldierReward,
}