--- Created by shimin
--- DateTime: 2023/11/1 15:22
--- 德雷克boss查看奖励界面

local UIDrakeBossRewardTipCtrl = BaseClass("UIDrakeBossRewardTipCtrl", UIBaseCtrl)

function UIDrakeBossRewardTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDrakeBossRewardTip)
end

return UIDrakeBossRewardTipCtrl