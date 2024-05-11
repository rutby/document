--- Created by shimin
--- DateTime: 2023/6/6 21:12
--- 英雄插件交换界面

local UIHeroPluginChangeCtrl = BaseClass("UIHeroPluginChangeCtrl", UIBaseCtrl)

function UIHeroPluginChangeCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginChange)
end

return UIHeroPluginChangeCtrl