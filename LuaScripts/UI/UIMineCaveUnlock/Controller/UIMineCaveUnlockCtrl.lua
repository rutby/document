--UIMineCaveUnlockCtrl.lua

local UIMineCaveUnlockCtrl = BaseClass("UIMineCaveUnlockCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIMineCaveUnlock)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIMineCaveUnlockCtrl.CloseSelf = CloseSelf
UIMineCaveUnlockCtrl.Close = Close

return UIMineCaveUnlockCtrl