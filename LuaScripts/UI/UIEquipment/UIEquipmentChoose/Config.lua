---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/1 15:49
---

local UIEquipmentChoose = {
    Name = UIWindowNames.UIEquipmentChoose,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIEquipment.UIEquipmentChoose.Controller.UIEquipmentChooseCtrl",
    View = require "UI.UIEquipment.UIEquipmentChoose.View.UIEquipmentChooseView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIEquipment/UIEquipmentChoose.prefab",
}

return {
    UIEquipmentChoose = UIEquipmentChoose,
}