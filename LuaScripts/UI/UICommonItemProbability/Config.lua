---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
--- 道具概率
local UICommonItemProbability = {
    Name = UIWindowNames.UICommonItemProbability,
    Layer = UILayer.Info,
    Ctrl = require "UI.UICommonItemProbability.Controller.UICommonItemProbabilityCtrl",
    View = require "UI.UICommonItemProbability.View.UICommonItemProbabilityView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonItemProbability.prefab",
}

return {
    -- 配置
    UICommonItemProbability = UICommonItemProbability,
}