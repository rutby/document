--- Created by shimin
--- DateTime: 2023/11/1 16:37
--- 自动参加集结点击德雷克弹出界面

local UIDrakeBossAutoJoinTips = {
    Name = UIWindowNames.UIDrakeBossAutoJoinTips,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIDrakeBossAutoJoinTips.Controller.UIDrakeBossAutoJoinTipsCtrl",
    View = require "UI.UIDrakeBossAutoJoinTips.View.UIDrakeBossAutoJoinTipsView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/DrakeBoss/UIDrakeBossAutoJoinTips.prefab",
}

return {
    -- 配置
    UIDrakeBossAutoJoinTips = UIDrakeBossAutoJoinTips,
}