--- Created by shimin
--- DateTime: 2023/3/16 18:10
--- 王座奖励界面

local UIThronePresidentReward = {
    Name = UIWindowNames.UIThronePresidentReward,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIGovernment.UIThronePresidentReward.Controller.UIThronePresidentRewardCtrl",
    View = require "UI.UIGovernment.UIThronePresidentReward.View.UIThronePresidentRewardView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIThrone/UIThronePresidentReward.prefab",
}

return {
    -- 配置
    UIThronePresidentReward = UIThronePresidentReward,
}