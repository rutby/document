local UIPopupPackageCtrl = BaseClass("UIPopupPackageCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIPopupPackage)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function BuyGift(self,info)
	DataCenter.PayManager:CallPayment(info, UIWindowNames.UIPopupPackage)
	self:CloseSelf()
end

UIPopupPackageCtrl.CloseSelf = CloseSelf
UIPopupPackageCtrl.Close = Close
UIPopupPackageCtrl.BuyGift = BuyGift


return UIPopupPackageCtrl