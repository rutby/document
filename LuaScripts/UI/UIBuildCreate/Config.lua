--- Created by shimin
--- DateTime: 2023/11/23 22:41
--- 建筑建造界面
local UIBuildCreate = {
    Name = UIWindowNames.UIBuildCreate,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIBuildCreate.Controller.UIBuildCreateCtrl",
    View = require "UI.UIBuildCreate.View.UIBuildCreateView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIBuildUpgrade/UIBuildCreate.prefab",
}

return {
    -- 配置
    UIBuildCreate = UIBuildCreate,
}