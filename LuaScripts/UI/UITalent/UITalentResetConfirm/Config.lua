local UITalentResetConfirm = {
    Name = UIWindowNames.UITalentResetConfirm,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UITalent.UITalentResetConfirm.Controller.UITalentResetConfirmCtrl",
    View = require "UI.UITalent.UITalentResetConfirm.View.UITalentResetConfirmView",
    PrefabPath = "Assets/Main/Prefabs/UI/UITalent/UITalentResetConfirm.prefab",
}

return {
    -- 配置
    UITalentResetConfirm = UITalentResetConfirm,
}