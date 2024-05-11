local UIBattlePassGiftPackagePopUpCtrl = BaseClass("UIBattlePassGiftPackagePopUpCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassGiftPackagePopUp)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBattlePassGiftPackagePopUpCtrl.CloseSelf = CloseSelf
UIBattlePassGiftPackagePopUpCtrl.Close = Close
return UIBattlePassGiftPackagePopUpCtrl