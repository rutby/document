local UIGolloesCardsRankCtrl = BaseClass("UIGolloesCardsRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGolloesCardsRank)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIGolloesCardsRankCtrl.CloseSelf = CloseSelf
UIGolloesCardsRankCtrl.Close = Close
return UIGolloesCardsRankCtrl