--- Created by shimin.
--- DateTime: 2023/12/14 00:17
--- 点击训练士兵属性页签弹窗

local UITrainDetailTipCtrl = BaseClass("UITrainDetailTipCtrl", UIBaseCtrl)

function UITrainDetailTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainDetailTip)
end

return UITrainDetailTipCtrl