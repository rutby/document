local UIBlackChangeMaskCtrl = BaseClass("UIBlackChangeMaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIBlackChangeMask,{ anim = false, playEffect = false })
end

UIBlackChangeMaskCtrl.CloseSelf = CloseSelf

return UIBlackChangeMaskCtrl