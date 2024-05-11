--- Created by shimin.
--- DateTime: 2024/1/22 21:11
--- 运兵车升级属性提示界面
local UIGarageRefitUpgradeTipCtrl = BaseClass("UIGarageRefitUpgradeTipCtrl", UIBaseCtrl)

function UIGarageRefitUpgradeTipCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGarageRefitUpgradeTip)
end

return UIGarageRefitUpgradeTipCtrl