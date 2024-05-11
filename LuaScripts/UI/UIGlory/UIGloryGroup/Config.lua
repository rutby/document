---
--- 荣耀之战联赛分组
--- Created by shimin.
--- DateTime: 2023/2/28 18:56
---

local UIGloryGroup =
{
    Name = UIWindowNames.UIGloryGroup,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIGlory.UIGloryGroup.Controller.UIGloryGroupCtrl",
    View = require "UI.UIGlory.UIGloryGroup.View.UIGloryGroupView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIGlory/UIGloryGroup/UIGloryGroup.prefab",
}

return
{
    UIGloryGroup = UIGloryGroup,
}