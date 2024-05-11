--- Created by shimin.
--- DateTime: 2023/11/7 10:36
--- 家具升级界面
local UIFurnitureUpgradeCtrl = BaseClass("UIFurnitureUpgradeCtrl", UIBaseCtrl)

function UIFurnitureUpgradeCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIFurnitureUpgrade)
end

function UIFurnitureUpgradeCtrl:Close()
	UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

return UIFurnitureUpgradeCtrl