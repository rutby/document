local UISeasonNewWorldCtrl = BaseClass("UISeasonNewWorldCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UISeasonNewWorld)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UISeasonNewWorldCtrl.CloseSelf = CloseSelf
UISeasonNewWorldCtrl.Close = Close

return UISeasonNewWorldCtrl