--- Created by shimin
--- DateTime: 2023/8/15 21:51
--- 主界面聊天联盟邀请迁城Tip

local UIMainChatInviteAllianceMove = {
    Name = UIWindowNames.UIMainChatInviteAllianceMove,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIMainChatInviteAllianceMove.Controller.UIMainChatInviteAllianceMoveCtrl",
    View = require "UI.UIMainChatInviteAllianceMove.View.UIMainChatInviteAllianceMoveView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIMain/UIMainChatInviteAllianceMove.prefab",
}

return {
    -- 配置
    UIMainChatInviteAllianceMove = UIMainChatInviteAllianceMove,
}