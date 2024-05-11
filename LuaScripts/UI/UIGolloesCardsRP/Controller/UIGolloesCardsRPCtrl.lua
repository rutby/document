local UIGolloesCardsRPCtrl = BaseClass("UIGolloesCardsRPCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGolloesCardsRP)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIGolloesCardsRPCtrl.CloseSelf = CloseSelf
UIGolloesCardsRPCtrl.Close = Close
return UIGolloesCardsRPCtrl