local LWCountBattleMain = {
    Name = UIWindowNames.LWCountBattleMain,
    Layer = UILayer.Background,
    Ctrl = require "UI.LWCountBattle.MainUI.Controller.LWCountBattleMainCtrl",
    View = require "UI.LWCountBattle.MainUI.View.LWCountBattleMainView",
    PrefabPath = "Assets/Main/Prefabs/UI/LWCountBattle/UILWCountBattleMain.prefab",
}

return {
    -- 配置
    LWCountBattleMain = LWCountBattleMain,
}