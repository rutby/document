--- Created by shimin
--- DateTime: 2023/3/21 15:09
--- 王座荣耀殿堂界面

local UIThronePresidentHonour = {
    Name = UIWindowNames.UIThronePresidentHonour,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIGovernment.UIThronePresidentHonour.Controller.UIThronePresidentHonourCtrl",
    View = require "UI.UIGovernment.UIThronePresidentHonour.View.UIThronePresidentHonourView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIThrone/UIThronePresidentHonour.prefab",
}

return {
    -- 配置
    UIThronePresidentHonour = UIThronePresidentHonour,
}