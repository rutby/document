--- Created by shimin.
--- DateTime: 2024/2/28 18:25
--  引导丧尸来袭页面

local UIGuideMonsterComing = {
    Name = UIWindowNames.UIGuideMonsterComing,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideMonsterComing.Controller.UIGuideMonsterComingCtrl",
    View = require "UI.UIGuideMonsterComing.View.UIGuideMonsterComingView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideMonsterComing.prefab",
}

return {
    -- 配置
    UIGuideMonsterComing = UIGuideMonsterComing,
}
