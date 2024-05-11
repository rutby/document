--- Created by shimin
--- DateTime: 2023/7/19 17:31
--- 英雄插件排行榜点击插件按钮弹出界面

local UIHeroPluginRankInfo = {
    Name = UIWindowNames.UIHeroPluginRankInfo,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroPluginRankInfo.Controller.UIHeroPluginRankInfoCtrl",
    View = require "UI.UIHeroPluginRankInfo.View.UIHeroPluginRankInfoView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroPluginRankInfo.prefab",
}

return {
    -- 配置
    UIHeroPluginRankInfo = UIHeroPluginRankInfo,
}