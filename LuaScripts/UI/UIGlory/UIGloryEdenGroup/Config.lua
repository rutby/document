---
--- 赛季结束说明
--- Created by
--- DateTime: 
---

local UIGloryEdenGroup =
{
    Name = UIWindowNames.UIGloryEdenGroup,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIGlory.UIGloryEdenGroup.Controller.UIGloryEdenGroupCtrl",
    View = require "UI.UIGlory.UIGloryEdenGroup.View.UIGloryEdenGroupView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIGlory/UIGloryMain/UIGloryEdenGroup.prefab",
}

return
{
    UIGloryEdenGroup = UIGloryEdenGroup,
}