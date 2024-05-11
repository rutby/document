---
--- Created by shimin.
--- DateTime: 2022/6/14 15:11
--- 英雄委托
---



local UIHeroEntrust = {
    Name = UIWindowNames.UIHeroEntrust,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIHeroEntrust.Controller.UIHeroEntrustCtrl",
    View = require "UI.UIHeroEntrust.View.UIHeroEntrustView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIHeroEntrust/UIHeroEntrust.prefab",
}

return {
    -- 配置
    UIHeroEntrust = UIHeroEntrust,
}
