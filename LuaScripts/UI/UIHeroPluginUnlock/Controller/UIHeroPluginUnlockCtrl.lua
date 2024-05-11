--- Created by shimin
--- DateTime: 2023/6/9 19:29
--- 英雄插件解锁界面

local UIHeroPluginUnlockCtrl = BaseClass("UIHeroPluginUnlockCtrl", UIBaseCtrl)

function UIHeroPluginUnlockCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginUnlock)
end

return UIHeroPluginUnlockCtrl