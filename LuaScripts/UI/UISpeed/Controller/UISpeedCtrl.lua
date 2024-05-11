--- Created by shimin.
--- DateTime: 2024/1/19 10:26
--- 加速界面
local UISpeedCtrl = BaseClass("UISpeedCtrl", UIBaseCtrl)

function UISpeedCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UISpeed)
end

return UISpeedCtrl