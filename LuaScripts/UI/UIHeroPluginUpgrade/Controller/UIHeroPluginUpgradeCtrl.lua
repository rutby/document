--- Created by shimin
--- DateTime: 2023/6/5 18:36
--- 英雄插件升级界面

local UIHeroPluginUpgradeCtrl = BaseClass("UIHeroPluginUpgradeCtrl", UIBaseCtrl)

function UIHeroPluginUpgradeCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginUpgrade)
end

return UIHeroPluginUpgradeCtrl