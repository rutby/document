local LWCountBattleLose = {
    Name = UIWindowNames.LWCountBattleLose,
    Layer = UILayer.Normal,
    Ctrl = require "UI.LWCountBattle.LoseUI.Controller.LWCountBattleLoseCtrl",
    View = require "UI.LWCountBattle.LoseUI.View.LWCountBattleLoseView",
    PrefabPath = "Assets/Main/Prefabs/UI/LWCountBattle/UILWCountBattleLose.prefab",
}

return {
    -- 配置
    LWCountBattleLose = LWCountBattleLose,
}