--- Created by shimin.
--- DateTime: 2023/12/25 17:41
--- 点击原始时间界面
local UIShowReasonCtrl = BaseClass("UIShowReasonCtrl", UIBaseCtrl)

function UIShowReasonCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIShowReason)
end

return UIShowReasonCtrl