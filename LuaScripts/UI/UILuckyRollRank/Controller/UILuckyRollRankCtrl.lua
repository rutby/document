local UILuckyRollRankCtrl = BaseClass("UILuckyRollRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UILuckyRollRank)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UILuckyRollRankCtrl.CloseSelf = CloseSelf
UILuckyRollRankCtrl.Close = Close
return UILuckyRollRankCtrl