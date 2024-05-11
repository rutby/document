--- Created by shimin.
--- DateTime: 2023/12/20 19:08
--- 提升战力界面界面
local UIShowPowerCtrl = BaseClass("UIShowPowerCtrl", UIBaseCtrl)

function UIShowPowerCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIShowPower)
end

return UIShowPowerCtrl