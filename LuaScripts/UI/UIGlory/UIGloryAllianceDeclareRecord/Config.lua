---
--- 荣耀之战宣战记录
--- Created by shimin.
--- DateTime: 2023/3/2 17:33
---

local UIGloryAllianceDeclareRecord =
{
    Name = UIWindowNames.UIGloryAllianceDeclareRecord,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIGlory.UIGloryAllianceDeclareRecord.Controller.UIGloryAllianceDeclareRecordCtrl",
    View = require "UI.UIGlory.UIGloryAllianceDeclareRecord.View.UIGloryAllianceDeclareRecordView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIGlory/UIGloryAllianceDeclareRecord/UIGloryAllianceDeclareRecord.prefab",
}

return
{
    UIGloryAllianceDeclareRecord = UIGloryAllianceDeclareRecord,
}