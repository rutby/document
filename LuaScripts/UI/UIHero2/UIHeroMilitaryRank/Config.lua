---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2021/6/23 下午3:08
---


-- 窗口配置
local UIHeroMilitaryRank = {
    Name = UIWindowNames.UIHeroMilitaryRank,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIHero2.UIHeroMilitaryRank.Controller.UIHeroMilitaryRankCtrl",
    View = require "UI.UIHero2.UIHeroMilitaryRank.View.UIHeroMilitaryRankView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroMilitaryRank.prefab",
}

return {
    -- 配置
    UIHeroMilitaryRank = UIHeroMilitaryRank
}