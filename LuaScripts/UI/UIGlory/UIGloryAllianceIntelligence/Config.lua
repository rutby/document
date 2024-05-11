---
--- 荣耀之战联盟情报
--- Created by shimin.
--- DateTime: 2023/3/1 15:30
---

local UIGloryAllianceIntelligence =
{
    Name = UIWindowNames.UIGloryAllianceIntelligence,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIGlory.UIGloryAllianceIntelligence.Controller.UIGloryAllianceIntelligenceCtrl",
    View = require "UI.UIGlory.UIGloryAllianceIntelligence.View.UIGloryAllianceIntelligenceView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIGlory/UIGloryAllianceIntelligence/UIGloryAllianceIntelligence.prefab",
}

return
{
    UIGloryAllianceIntelligence = UIGloryAllianceIntelligence,
}