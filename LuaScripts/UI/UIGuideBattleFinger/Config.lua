--- Created by shimin
--- DateTime: 2024/03/28 20:07
--- 战斗开始引导手左右滑动提示

local UIGuideBattleFinger = {
    Name = UIWindowNames.UIGuideBattleFinger,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIGuideBattleFinger.Controller.UIGuideBattleFingerCtrl",
    View = require "UI.UIGuideBattleFinger.View.UIGuideBattleFingerView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideBattleFinger.prefab",
}

return {
    -- 配置
    UIGuideBattleFinger = UIGuideBattleFinger,
}