--- Created by shimin
--- DateTime: 2023/3/20 20:53
--- 王座发奖界面

local UIThroneRewardSelectMember = {
    Name = UIWindowNames.UIThroneRewardSelectMember,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIGovernment.UIThroneRewardSelectMember.Controller.UIThroneRewardSelectMemberCtrl",
    View = require "UI.UIGovernment.UIThroneRewardSelectMember.View.UIThroneRewardSelectMemberView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIThrone/UIThroneRewardSelectMember.prefab",
}

return {
    -- 配置
    UIThroneRewardSelectMember = UIThroneRewardSelectMember,
}