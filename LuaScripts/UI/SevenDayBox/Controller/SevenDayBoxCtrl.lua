local SevenDayBoxCtrl = BaseClass("SevenDayBoxCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.SevenDayBox)
end

SevenDayBoxCtrl.CloseSelf = CloseSelf
return SevenDayBoxCtrl