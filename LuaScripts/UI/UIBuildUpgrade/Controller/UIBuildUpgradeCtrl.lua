--- Created by shimin
--- DateTime: 2024/01/08 12:11
--- slg建筑升级界面

local UIBuildUpgradeCtrl = BaseClass("UIBuildUpgradeCtrl", UIBaseCtrl)

function UIBuildUpgradeCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildUpgrade)
end

return UIBuildUpgradeCtrl