local UIBattlePassBuyCtrl = BaseClass("UIBattlePassBuyCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIBattlePassBuy)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIBattlePassBuyCtrl.CloseSelf = CloseSelf
UIBattlePassBuyCtrl.Close = Close
return UIBattlePassBuyCtrl