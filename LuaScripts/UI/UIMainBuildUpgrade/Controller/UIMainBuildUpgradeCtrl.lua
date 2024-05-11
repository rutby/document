
local UIMainBuildUpgradeCtrl = BaseClass("UIMainBuildUpgradeCtrl", UIBaseCtrl)

function UIMainBuildUpgradeCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIMainBuildUpgrade)
end

function UIMainBuildUpgradeCtrl:Close()
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

return UIMainBuildUpgradeCtrl