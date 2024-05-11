
local UIGrowthPlanBuyPanel = {
    Name = UIWindowNames.UIGrowthPlanBuyPanel,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIGrowthPlanBuyPanel.Controller.UIGrowthPlanBuyPanelCtrl",
    View = require "UI.UIGrowthPlanBuyPanel.View.UIGrowthPlanBuyPanelView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/GiftPackage/GrowthPlan/UIGrowthPlanBuyPanel.prefab",
}

return {
    -- 配置
    UIGrowthPlanBuyPanel = UIGrowthPlanBuyPanel,
}