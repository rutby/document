---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/8 17:21
---

local UIPiggyBank = {
    Name = UIWindowNames.UIPiggyBank,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIPiggyBank.Controller.UIPiggyBankCtrl",
    View = require "UI.UIPiggyBank.View.UIPiggyBankView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIPiggyBank/UIPiggyBank.prefab",
}

return {
    UIPiggyBank = UIPiggyBank,
}