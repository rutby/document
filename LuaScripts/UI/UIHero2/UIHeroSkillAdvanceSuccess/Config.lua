
-- 窗口配置
local UIHeroSkillAdvanceSuccess = {
    Name = UIWindowNames.UIHeroSkillAdvanceSuccess,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHero2.UIHeroSkillAdvanceSuccess.Controller.UIHeroSkillAdvanceSuccessCtrl",
    View = require "UI.UIHero2.UIHeroSkillAdvanceSuccess.View.UIHeroSkillAdvanceSuccessView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroSkillAdvanceSuccess.prefab",
}

return {
    -- 配置
    UIHeroSkillAdvanceSuccess = UIHeroSkillAdvanceSuccess
}