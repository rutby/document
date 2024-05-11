local UIScienceTabCtrl = BaseClass("UIScienceTabCtrl", UIBaseCtrl)

function UIScienceTabCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIScienceTab)
end

return UIScienceTabCtrl