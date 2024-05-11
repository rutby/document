local UIGiftBoxRankCtrl = BaseClass("UIGiftBoxRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftBoxRank)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIGiftBoxRankCtrl.CloseSelf = CloseSelf
UIGiftBoxRankCtrl.Close = Close
return UIGiftBoxRankCtrl