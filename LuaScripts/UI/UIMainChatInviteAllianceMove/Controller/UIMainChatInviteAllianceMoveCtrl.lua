--- Created by shimin
--- DateTime: 2023/8/15 21:51
--- 主界面聊天联盟邀请迁城Tip

local UIMainChatInviteAllianceMoveCtrl = BaseClass("UIMainChatInviteAllianceMoveCtrl", UIBaseCtrl)

function UIMainChatInviteAllianceMoveCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainChatInviteAllianceMove)
end

return UIMainChatInviteAllianceMoveCtrl