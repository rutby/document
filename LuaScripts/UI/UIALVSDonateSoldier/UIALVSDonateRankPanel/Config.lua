
local UIALVSDonateRank = {
    Name = UIWindowNames.UIALVSDonateRank,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIALVSDonateSoldier.UIALVSDonateRankPanel.Controller.UIALVSDonateRankCtrl",
    View = require "UI.UIALVSDonateSoldier.UIALVSDonateRankPanel.View.UIALVSDonateRankView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/ActivityCenter/UIALVSDonateSoldier/UIALVSDonateRankPanel.prefab",
}

return {
    -- 配置
    UIALVSDonateRank = UIALVSDonateRank,
}