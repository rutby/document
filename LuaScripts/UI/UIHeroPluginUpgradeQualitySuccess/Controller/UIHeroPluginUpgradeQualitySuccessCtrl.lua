--- Created by shimin
--- DateTime: 2023/7/18 20:30
--- --- 英雄插件品质升级成功界面

local UIHeroPluginUpgradeQualitySuccessCtrl = BaseClass("UIHeroPluginUpgradeQualitySuccessCtrl", UIBaseCtrl)

function UIHeroPluginUpgradeQualitySuccessCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginUpgradeQualitySuccess)
end

return UIHeroPluginUpgradeQualitySuccessCtrl