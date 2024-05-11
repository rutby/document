local UIAllianceCompeteMainCtrl = BaseClass("UIAllianceCompeteMainCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceCompeteMain)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end


UIAllianceCompeteMainCtrl.CloseSelf = CloseSelf
UIAllianceCompeteMainCtrl.Close = Close

return UIAllianceCompeteMainCtrl