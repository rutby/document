---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/9 14:45
---
local UIWorldCollectMessageTip = {
    Name = UIWindowNames.UIWorldCollectMessageTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIWorldCollect.UIWorldCollectMessageTip.Controller.UIWorldCollectMessageTipCtrl",
    View = require "UI.UIWorldCollect.UIWorldCollectMessageTip.View.UIWorldCollectMessageTipView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UISearch/UIWorldCollectMessageTip.prefab",
}

return {
    -- 配置
    UIWorldCollectMessageTip = UIWorldCollectMessageTip,
}