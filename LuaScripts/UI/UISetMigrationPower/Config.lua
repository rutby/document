---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/4/18 19:24
---
local UISetMigrationPower = {
    Name = UIWindowNames.UISetMigrationPower,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetMigrationPower.Controller.UISetMigrationPowerCtrl",
    View = require "UI.UISetMigrationPower.View.UISetMigrationPowerView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIInterstellarMigration/UIInterstellarMigrationManagement.prefab",
}

return {
    -- 配置
    UISetMigrationPower = UISetMigrationPower,
}