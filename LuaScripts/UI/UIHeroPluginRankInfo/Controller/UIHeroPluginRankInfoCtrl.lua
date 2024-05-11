--- Created by shimin
--- DateTime: 2023/7/19 17:31
--- 英雄插件排行榜点击插件按钮弹出界面

local UIHeroPluginRankInfoCtrl = BaseClass("UIHeroPluginRankInfoCtrl", UIBaseCtrl)

function UIHeroPluginRankInfoCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPluginRankInfo)
end

return UIHeroPluginRankInfoCtrl