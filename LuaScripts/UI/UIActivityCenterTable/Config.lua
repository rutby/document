---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/10/22 16:59
---
local UIActivityCenterTable = {
    Name = UIWindowNames.UIActivityCenterTable,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIActivityCenterTable.Controller.UIActivityCenterTableCtrl",
    View = require "UI.UIActivityCenterTable.View.UIActivityCenterTableView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIActivityCollect/UIActivityCenterTableNew.prefab",
}

return {
    UIActivityCenterTable = UIActivityCenterTable,
}