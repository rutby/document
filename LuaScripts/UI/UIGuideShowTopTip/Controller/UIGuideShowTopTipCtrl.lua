--- Created by shimin.
--- DateTime: 2023/11/27 20:35
--- 引导顶部提示界面

local UIGuideShowTopTipCtrl = BaseClass("UIGuideShowTopTipCtrl", UIBaseCtrl)

function UIGuideShowTopTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideShowTopTip, { anim = true , playEffect = false})
end

return UIGuideShowTopTipCtrl