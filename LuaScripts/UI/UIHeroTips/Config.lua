---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 7/22/21 2:46 PM
---
-- 窗口配置
local UIHeroTips = {
    Name = UIWindowNames.UIHeroTips,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroTips.Controller.UIHeroTipsCtrl",
    View = require "UI.UIHeroTips.View.UIHeroTipsView",
    PrefabPath = "Assets/Main/Prefabs/UI/Common/UIHeroTips.prefab",
}

return {
    -- 配置
    UIHeroTips = UIHeroTips,
}