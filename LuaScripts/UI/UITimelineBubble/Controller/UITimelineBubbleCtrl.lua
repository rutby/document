--- Created by shimin.
--- DateTime: 2024/1/24 17:38
--- timeline气泡界面
local UITimelineBubbleCtrl = BaseClass("UITimelineBubbleCtrl", UIBaseCtrl)

function UITimelineBubbleCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UITimelineBubble)
end

return UITimelineBubbleCtrl