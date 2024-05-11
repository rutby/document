---
--- Created by shimin.
--- DateTime: 2022/3/14 18:53
---


-- 窗口配置
local UIAllianceCareerEffectTip = {
    Name = UIWindowNames.UIAllianceCareerEffectTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAlliance.UIAllianceCareerEffectTip.Controller.UIAllianceCareerEffectTipCtrl",
    View = require "UI.UIAlliance.UIAllianceCareerEffectTip.View.UIAllianceCareerEffectTipView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceCareer/UIAllianceCareerEffectTip.prefab",
}

return {
    -- 配置
    UIAllianceCareerEffectTip = UIAllianceCareerEffectTip
}