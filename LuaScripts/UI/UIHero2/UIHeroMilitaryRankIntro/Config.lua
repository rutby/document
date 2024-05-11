
-- 窗口配置
local UIHeroMilitaryRankIntro = {
    Name = UIWindowNames.UIHeroMilitaryRankIntro,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIHero2.UIHeroMilitaryRankIntro.Controller.UIHeroMilitaryRankIntroCtrl",
    View = require "UI.UIHero2.UIHeroMilitaryRankIntro.View.UIHeroMilitaryRankIntroView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroMilitaryRankIntro.prefab",
}

return {
    -- 配置
    UIHeroMilitaryRankIntro = UIHeroMilitaryRankIntro
}