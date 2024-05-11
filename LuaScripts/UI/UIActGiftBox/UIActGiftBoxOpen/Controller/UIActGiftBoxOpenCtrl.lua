local UIActGiftBoxOpenCtrl = BaseClass("UIActGiftBoxOpenCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIActGiftBoxOpen)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIActGiftBoxOpenCtrl.CloseSelf = CloseSelf
UIActGiftBoxOpenCtrl.Close = Close
return UIActGiftBoxOpenCtrl