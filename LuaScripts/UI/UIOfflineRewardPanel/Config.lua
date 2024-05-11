
local UIOfflineRewardPanel = {
    Name = UIWindowNames.UIOfflineRewardPanel,
    Layer = UILayer.Info,
    Ctrl = require "UI.UIOfflineRewardPanel.Ctrl.UIOfflineRewardPanelCtrl",
    View = require "UI.UIOfflineRewardPanel.View.UIOfflineRewardPanelView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIOfflineRewardPanel/UIOfflineRewardPanel.prefab",
}

return {
    -- 配置
    UIOfflineRewardPanel = UIOfflineRewardPanel,
}