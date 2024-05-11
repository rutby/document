local UIScratchOffRankPageCtrl = BaseClass("UIScratchOffRankPageCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.ScratchOffRankPage)
end

UIScratchOffRankPageCtrl.CloseSelf = CloseSelf
return UIScratchOffRankPageCtrl