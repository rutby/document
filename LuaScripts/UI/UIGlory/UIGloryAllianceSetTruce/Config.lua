---
--- 荣耀之战设置休战时间
--- Created by shimin.
--- DateTime: 2023/3/2 15:01
---

local UIGloryAllianceSetTruce =
{
    Name = UIWindowNames.UIGloryAllianceSetTruce,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIGlory.UIGloryAllianceSetTruce.Controller.UIGloryAllianceSetTruceCtrl",
    View = require "UI.UIGlory.UIGloryAllianceSetTruce.View.UIGloryAllianceSetTruceView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIGlory/UIGloryAllianceSetTruce/UIGloryAllianceSetTruce.prefab",
}

return
{
    UIGloryAllianceSetTruce = UIGloryAllianceSetTruce,
}