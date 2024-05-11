local UIAllianceFlagCtrl = BaseClass("UIAllianceFlagCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceFlag)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIAllianceFlagCtrl.CloseSelf = CloseSelf
UIAllianceFlagCtrl.Close = Close

return UIAllianceFlagCtrl