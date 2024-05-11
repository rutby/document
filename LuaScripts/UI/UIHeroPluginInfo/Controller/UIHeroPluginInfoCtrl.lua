--- Created by shimin
--- DateTime: 2023/7/14 14:56
--- 英雄插件详情界面

local UIHeroPluginInfoCtrl = BaseClass("UIHeroPluginInfoCtrl", UIBaseCtrl)

function UIHeroPluginInfoCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginInfo)
end

return UIHeroPluginInfoCtrl