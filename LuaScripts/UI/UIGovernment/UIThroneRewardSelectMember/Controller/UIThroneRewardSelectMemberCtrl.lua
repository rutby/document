--- Created by shimin
--- DateTime: 2023/3/20 20:53
--- 王座发奖界面

local UIThroneRewardSelectMemberCtrl = BaseClass("UIThroneRewardSelectMemberCtrl", UIBaseCtrl)

function UIThroneRewardSelectMemberCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIThroneRewardSelectMember)
end

return UIThroneRewardSelectMemberCtrl