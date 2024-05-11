local LWCountBattleWin = {
    Name = UIWindowNames.LWCountBattleWin,
    Layer = UILayer.Normal,
    Ctrl = require "UI.LWCountBattle.WinUI.Controller.LWCountBattleWinCtrl",
    View = require "UI.LWCountBattle.WinUI.View.LWCountBattleWinView",
    PrefabPath = "Assets/Main/Prefabs/UI/LWCountBattle/UILWCountBattleWin.prefab",
}

return {
    -- 配置
    LWCountBattleWin = LWCountBattleWin,
}