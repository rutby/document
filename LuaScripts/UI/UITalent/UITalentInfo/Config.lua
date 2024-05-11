
local UITalentInfo = {
    Name = UIWindowNames.UITalentInfo,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UITalent.UITalentInfo.Controller.UITalentInfoCtrl",
    View = require "UI.UITalent.UITalentInfo.View.UITalentInfoView",
    PrefabPath = "Assets/Main/Prefabs/UI/UITalent/UITalentInfo.prefab",
}

return {
    -- 配置
    UITalentInfo = UITalentInfo,
}