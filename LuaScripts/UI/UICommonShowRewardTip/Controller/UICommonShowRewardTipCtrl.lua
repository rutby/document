--- Created by shimin
--- DateTime: 2023/8/29 19:12
--- 点击未领取奖励箱子弹出道具列表界面


local UICommonShowRewardTipCtrl = BaseClass("UICommonShowRewardTipCtrl", UIBaseCtrl)

function UICommonShowRewardTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonShowRewardTip)
end

return UICommonShowRewardTipCtrl