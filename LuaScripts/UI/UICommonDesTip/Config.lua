---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/12/28 15:52
---
local UICommonDesTip = {
    Name = UIWindowNames.UICommonDesTip,
    Layer = UILayer.Info,
    Ctrl = require "UI.UICommonDesTip.Controller.UICommonDesTipCtrl",
    View = require "UI.UICommonDesTip.View.UICommonDesTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonDesTip.prefab",
}

return {
    -- 配置
    UICommonDesTip = UICommonDesTip
}