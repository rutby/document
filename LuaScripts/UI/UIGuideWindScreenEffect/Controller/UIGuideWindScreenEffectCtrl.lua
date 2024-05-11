--- Created by shimin.
--- DateTime: 2024/3/7 17:27
--- 引导风沙

local UIGuideWindScreenEffectCtrl = BaseClass("UIGuideWindScreenEffectCtrl", UIBaseCtrl)

function UIGuideWindScreenEffectCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIGuideWindScreenEffect)
end

return UIGuideWindScreenEffectCtrl