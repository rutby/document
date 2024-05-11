local UIUpPowerCtrl = BaseClass("UIUpPowerCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIUpPower)
end

local function Close(self)
	--self:CloseSelf()
	--UIManager.Instance:DestroyWindow(UIWindowNames.UIActivityCenterTable)
	GoToUtil.CloseAllWindows()
end

UIUpPowerCtrl.CloseSelf = CloseSelf
UIUpPowerCtrl.Close = Close
return UIUpPowerCtrl