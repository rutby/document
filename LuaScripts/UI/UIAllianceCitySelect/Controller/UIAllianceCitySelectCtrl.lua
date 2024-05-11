--UIAllianceCitySelectCtrl.lua

local UIAllianceCitySelectCtrl = BaseClass("UIAllianceCitySelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceCitySelect)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIAllianceCitySelectCtrl.CloseSelf = CloseSelf
UIAllianceCitySelectCtrl.Close = Close

return UIAllianceCitySelectCtrl