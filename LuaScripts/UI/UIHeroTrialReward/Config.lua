local UIHeroTrialReward = {
    Name = UIWindowNames.UIHeroTrialReward,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroTrialReward.Controller.UIHeroTrialRewardCtrl",
    View = require "UI.UIHeroTrialReward.View.UIHeroTrialRewardView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/HeroTrial/HeroTrialReward.prefab",
}

return {
    -- 配置
    UIHeroTrialReward = UIHeroTrialReward,
}