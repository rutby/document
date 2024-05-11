--- Created by shimin.
--- DateTime: 2024/1/16 16:25
--- 气泡界面
local UIBubbleCtrl = BaseClass("UIBubbleCtrl", UIBaseCtrl)

function UIBubbleCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIBubble)
end

return UIBubbleCtrl