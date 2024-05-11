local UIAllianceScienceCtrl = BaseClass("UIAllianceScienceCtrl", UIBaseCtrl)

function UIAllianceScienceCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceScience)
end

return UIAllianceScienceCtrl