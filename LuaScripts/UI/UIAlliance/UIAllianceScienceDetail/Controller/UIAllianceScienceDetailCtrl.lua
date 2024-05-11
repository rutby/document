--- Created by shimin.
--- DateTime: 2023/12/19 22:04
--- 科技属性详情界面
local UIAllianceScienceDetailCtrl = BaseClass("UIAllianceScienceDetailCtrl", UIBaseCtrl)

function UIAllianceScienceDetailCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceScienceDetail)
end

return UIAllianceScienceDetailCtrl