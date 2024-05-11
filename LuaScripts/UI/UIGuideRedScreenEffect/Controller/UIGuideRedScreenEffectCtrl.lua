--- Created by shimin.
--- DateTime: 2024/3/7 17:29
--- 引导红色警告

local UIGuideRedScreenEffectCtrl = BaseClass("UIGuideRedScreenEffectCtrl", UIBaseCtrl)

function UIGuideRedScreenEffectCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIGuideRedScreenEffect)
end

return UIGuideRedScreenEffectCtrl