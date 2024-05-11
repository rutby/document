local UIGolloesCardsExShopCtrl = BaseClass("UIGolloesCardsExShopCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGolloesCardsExShop)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIGolloesCardsExShopCtrl.CloseSelf = CloseSelf
UIGolloesCardsExShopCtrl.Close = Close
return UIGolloesCardsExShopCtrl