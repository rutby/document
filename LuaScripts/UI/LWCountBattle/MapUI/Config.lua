
local LWCountBattleMap = {
    Name = UIWindowNames.LWCountBattleMap,
    Layer = UILayer.Normal,
    Ctrl = require "UI.LWCountBattle.MapUI.Controller.LWCountBattleMapCtrl",
    View = require "UI.LWCountBattle.MapUI.View.LWCountBattleMapView",
    PrefabPath = "Assets/Main/Prefabs/UI/LWCountBattle/UILWCountBattleMap.prefab",
    HideBack = true,
}

return {
    -- 配置
    LWCountBattleMap = LWCountBattleMap,
}