--- Created by shimin.
--- DateTime: 2024/1/18 10:13
--- 一键补充资源界面
local UIResourceReplenishCtrl = BaseClass("UIResourceReplenishCtrl", UIBaseCtrl)

function UIResourceReplenishCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIResourceReplenish)
end

return UIResourceReplenishCtrl