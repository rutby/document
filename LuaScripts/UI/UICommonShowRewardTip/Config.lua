--- Created by shimin
--- DateTime: 2023/8/29 19:12
--- 点击未领取奖励箱子弹出道具列表界面

local UICommonShowRewardTip = {
    Name = UIWindowNames.UICommonShowRewardTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UICommonShowRewardTip.Controller.UICommonShowRewardTipCtrl",
    View = require "UI.UICommonShowRewardTip.View.UICommonShowRewardTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonShowRewardTip.prefab",
}

return {
    -- 配置
    UICommonShowRewardTip = UICommonShowRewardTip,
}