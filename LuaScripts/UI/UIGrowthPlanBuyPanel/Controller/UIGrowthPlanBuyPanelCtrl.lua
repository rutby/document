
local UIGrowthPlanBuyPanelCtrl = BaseClass("UIGrowthPlanBuyPanelCtrl", UIBaseCtrl)

function UIGrowthPlanBuyPanelCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGrowthPlanBuyPanel)
end

return UIGrowthPlanBuyPanelCtrl