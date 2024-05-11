--- Created by shimin.
--- DateTime: 2024/1/19 17:04
--- 一键补充加速界面
local UISpeedReplenishCtrl = BaseClass("UISpeedReplenishCtrl", UIBaseCtrl)

function UISpeedReplenishCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UISpeedReplenish)
end

return UISpeedReplenishCtrl