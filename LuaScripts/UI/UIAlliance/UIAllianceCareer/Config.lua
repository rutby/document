---
--- Created by shimin.
--- DateTime: 2022/3/10 15:37
---
local UIAllianceCareerEdit = {
    Name = UIWindowNames.UIAllianceCareerEdit,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAlliance.UIAllianceCareer.Controller.UIAllianceCareerCtrl",
    View = require "UI.UIAlliance.UIAllianceCareer.View.UIAllianceCareerEditView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/Alliance/AllianceCareer/UIAllianceCareerEdit.prefab",
}

return {
    -- 配置
    UIAllianceCareerEdit = UIAllianceCareerEdit
}