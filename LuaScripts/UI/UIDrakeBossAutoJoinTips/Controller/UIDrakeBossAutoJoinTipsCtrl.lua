--- Created by shimin
--- DateTime: 2023/11/1 16:37
--- 自动参加集结点击德雷克弹出界面

local UIDrakeBossAutoJoinTipsCtrl = BaseClass("UIDrakeBossAutoJoinTipsCtrl", UIBaseCtrl)

function UIDrakeBossAutoJoinTipsCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDrakeBossAutoJoinTips)
end

return UIDrakeBossAutoJoinTipsCtrl