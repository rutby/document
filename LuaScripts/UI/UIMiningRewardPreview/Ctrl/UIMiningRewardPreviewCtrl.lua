local UIMiningRewardPreviewCtrl = BaseClass("UIMiningRewardPreviewCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIMiningRewardPreview)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMiningRewardPreviewCtrl.CloseSelf = CloseSelf
UIMiningRewardPreviewCtrl.Close = Close
return UIMiningRewardPreviewCtrl