local UIMysteriousRankCtrl = BaseClass("UIMysteriousRankCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIMysteriousRank)
end

UIMysteriousRankCtrl.CloseSelf = CloseSelf
return UIMysteriousRankCtrl