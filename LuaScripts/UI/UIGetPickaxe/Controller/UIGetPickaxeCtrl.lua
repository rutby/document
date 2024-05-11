local UIGetPickaxeCtrl = BaseClass("UIGetPickaxeCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGetPickaxe)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIGetPickaxeCtrl.CloseSelf = CloseSelf
UIGetPickaxeCtrl.Close = Close

return UIGetPickaxeCtrl