local UIMysteriousRewardPreviewCtrl = BaseClass("UIMysteriousRewardPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIMysteriousRewardPreview)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMysteriousRewardPreviewCtrl.CloseSelf = CloseSelf
UIMysteriousRewardPreviewCtrl.Close = Close
return UIMysteriousRewardPreviewCtrl