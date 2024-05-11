
-- 窗口配置
local UIHeroSkillAdvance = {
    Name = UIWindowNames.UIHeroSkillAdvance,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHero2.UIHeroSkillAdvance.Controller.UIHeroSkillAdvanceCtrl",
    View = require "UI.UIHero2.UIHeroSkillAdvance.View.UIHeroSkillAdvanceView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroSkillAdvance.prefab",
}

return {
    -- 配置
    UIHeroSkillAdvance = UIHeroSkillAdvance
}