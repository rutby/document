--
-- PVE 通关奖励界面
--

local UIPVELevelReward = {
    Name = UIWindowNames.UIPVELevelReward,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPVE.UIPVELevelReward.Controller.UIPVELevelRewardCtrl",
    View = require "UI.UIPVE.UIPVELevelReward.View.UIPVELevelRewardView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIPVE/UIPVELevelReward.prefab",
}

return {
    -- 配置
    UIPVELevelReward = UIPVELevelReward,
}