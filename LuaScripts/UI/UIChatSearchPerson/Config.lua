---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/24/21 11:02 AM
---
local UIChatSearchPerson = {
    Name = UIWindowNames.UIChatSearchPerson,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIChatSearchPerson.Controller.UIChatSearchPersonCtrl",
    View = require "UI.UIChatSearchPerson.View.UIChatSearchPersonView",
    PrefabPath = "Assets/Main/Prefab_Dir/ChatNew/SearchPerson/UIChatSearchPerson.prefab",
}

return {
    UIChatSearchPerson = UIChatSearchPerson,
}