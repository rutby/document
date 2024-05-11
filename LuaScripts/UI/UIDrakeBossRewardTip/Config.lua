--- Created by shimin
--- DateTime: 2023/11/1 15:22
--- 德雷克boss查看奖励界面

local UIDrakeBossRewardTip = {
    Name = UIWindowNames.UIDrakeBossRewardTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIDrakeBossRewardTip.Controller.UIDrakeBossRewardTipCtrl",
    View = require "UI.UIDrakeBossRewardTip.View.UIDrakeBossRewardTipView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DrakeBoss/UIDrakeBossRewardTip.prefab",
}

return {
    -- 配置
    UIDrakeBossRewardTip = UIDrakeBossRewardTip,
}