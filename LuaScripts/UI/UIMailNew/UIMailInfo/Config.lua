---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/9/21 11:22 AM
---
local UIMailInfo = {
    Name = UIWindowNames.UIMailInfo,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIMailNew.UIMailInfo.Controller.UIMailInfoCtrl",
    View = require "UI.UIMailNew.UIMailInfo.View.UIMailInfoView",
    PrefabPath = "Assets/Main/Prefab_Dir/Mail/UIMailInfo.prefab",
}

return {
    -- 配置
    UIMailInfo = UIMailInfo,
}