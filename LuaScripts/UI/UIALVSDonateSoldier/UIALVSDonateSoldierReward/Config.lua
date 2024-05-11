
local UIALVSDonateSoldierReward = {
    Name = UIWindowNames.UIALVSDonateSoldierReward,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIALVSDonateSoldier.UIALVSDonateSoldierReward.Controller.UIALVSDonateSoldierRewardCtrl",
    View = require "UI.UIALVSDonateSoldier.UIALVSDonateSoldierReward.View.UIALVSDonateSoldierRewardView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIALVSDonateSoldier/UIALVSDonateSoldierRewardPanel.prefab",
}

return {
    -- 配置
    UIALVSDonateSoldierReward = UIALVSDonateSoldierReward,
}