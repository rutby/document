local UIAllianceScienceInfoCtrl = BaseClass("UIAllianceScienceInfoCtrl", UIBaseCtrl)

function UIAllianceScienceInfoCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceScienceInfo)
end

return UIAllianceScienceInfoCtrl