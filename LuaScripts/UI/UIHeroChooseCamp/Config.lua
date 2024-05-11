--- Created by shimin
--- DateTime: 2023/9/19 10:09
--- 英雄选择阵容页面

local UIHeroChooseCamp = {
    Name = UIWindowNames.UIHeroChooseCamp,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroChooseCamp.Controller.UIHeroChooseCampCtrl",
    View = require "UI.UIHeroChooseCamp.View.UIHeroChooseCampView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIHero/New/UIHeroChooseCamp.prefab",
}

return {
    -- 配置
    UIHeroChooseCamp = UIHeroChooseCamp,
}