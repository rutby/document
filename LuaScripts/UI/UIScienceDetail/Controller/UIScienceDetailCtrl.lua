--- Created by shimin.
--- DateTime: 2023/12/19 22:04
--- 科技属性详情界面
local UIScienceDetailCtrl = BaseClass("UIScienceDetailCtrl", UIBaseCtrl)

function UIScienceDetailCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIScienceDetail)
end

return UIScienceDetailCtrl