---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local UIVIPRewardPopUp = {
    Name = UIWindowNames.UIVIPRewardPopUp,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIVip.UIVIPRewardPopUp.Controller.UIVIPRewardPopUpCtrl",
    View = require "UI.UIVip.UIVIPRewardPopUp.View.UIVIPRewardPopUpView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIVip/UIVIPRewardPopUp.prefab",
}

return {
    -- 配置
    WorldDesUI = UIVIPRewardPopUp,
}