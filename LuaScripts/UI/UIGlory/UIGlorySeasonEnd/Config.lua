---
--- 赛季结束说明
--- Created by
--- DateTime: 
---

local UIGlorySeasonEnd =
{
    Name = UIWindowNames.UIGlorySeasonEnd,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIGlory.UIGlorySeasonEnd.Controller.UIGlorySeasonEndCtrl",
    View = require "UI.UIGlory.UIGlorySeasonEnd.View.UIGlorySeasonEndView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIGlory/UIGlorySeasonEnd/UIGlorySeasonEnd.prefab",
}

return
{
    UIGlorySeasonEnd = UIGlorySeasonEnd,
}