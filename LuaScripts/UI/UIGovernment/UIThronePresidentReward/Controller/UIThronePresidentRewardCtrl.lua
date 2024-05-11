--- Created by shimin
--- DateTime: 2023/3/16 18:10
--- 王座奖励界面

local UIThronePresidentRewardCtrl = BaseClass("UIThronePresidentRewardCtrl", UIBaseCtrl)

function UIThronePresidentRewardCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIThronePresidentReward)
end

return UIThronePresidentRewardCtrl