local UIMiningGiftPackagePopUpCtrl = BaseClass("UIMiningGiftPackagePopUpCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIMiningGiftPackagePopUp)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMiningGiftPackagePopUpCtrl.CloseSelf = CloseSelf
UIMiningGiftPackagePopUpCtrl.Close = Close
return UIMiningGiftPackagePopUpCtrl