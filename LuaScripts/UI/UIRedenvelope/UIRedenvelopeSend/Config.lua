---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 2022/2/22
---
local UIRedenvelopeSend = {
    Name = UIWindowNames.UIRedenvelopeSend,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIRedenvelope.UIRedenvelopeSend.Controller.UIRedenvelopeSendCtrl",
    View = require "UI.UIRedenvelope.UIRedenvelopeSend.View.UIRedenvelopeSendView",
    PrefabPath = "Assets/Main/Prefab_Dir/ChatNew/UIRedenvelopeSend.prefab",
}

return {
    -- 配置
    UIRedenvelopeSend = UIRedenvelopeSend
}