--- Created by shimin
--- DateTime: 2023/7/17 20:38
--- 英雄插件品质详情界面

local UIHeroPluginQualityTipCtrl = BaseClass("UIHeroPluginQualityTipCtrl", UIBaseCtrl)

function UIHeroPluginQualityTipCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginQualityTip)
end

return UIHeroPluginQualityTipCtrl