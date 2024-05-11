---
--- 荣耀之战个人积分详情
--- Created by shimin.
--- DateTime: 2023/3/2 10:51
---

local UIGloryPersonScore =
{
    Name = UIWindowNames.UIGloryPersonScore,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIGlory.UIGloryPersonScore.Controller.UIGloryPersonScoreCtrl",
    View = require "UI.UIGlory.UIGloryPersonScore.View.UIGloryPersonScoreView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIGlory/UIGloryPersonScore/UIGloryPersonScore.prefab",
}

return
{
    UIGloryPersonScore = UIGloryPersonScore,
}