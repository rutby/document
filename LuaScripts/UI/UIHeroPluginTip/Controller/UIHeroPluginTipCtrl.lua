--- Created by shimin
--- DateTime: 2023/6/2 14:58
--- 英雄界面点击插件按钮弹出界面

local UIHeroPluginTipCtrl = BaseClass("UIHeroPluginTipCtrl", UIBaseCtrl)

function UIHeroPluginTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginTip)
end

return UIHeroPluginTipCtrl