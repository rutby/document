--- Created by shimin
--- DateTime: 2023/6/9 11:00
--- 英雄插件属性详情界面

local UIHeroPluginUpgradeInfoCtrl = BaseClass("UIHeroPluginUpgradeInfoCtrl", UIBaseCtrl)

function UIHeroPluginUpgradeInfoCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginUpgradeInfo)
end

return UIHeroPluginUpgradeInfoCtrl