
-- 窗口配置
local UIArmyUnlock = {
    Name = UIWindowNames.UIArmyUnlock,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIArmyUnlock.Controller.UIArmyUnlockCtrl",
    View = require "UI.UIArmyUnlock.View.UIArmyUnlockView",
    PrefabPath = "Assets/Main/Prefabs/UI/UITrain/UIArmyUnlock.prefab",
}

return {
    -- 配置
    UIArmyUnlock = UIArmyUnlock
}