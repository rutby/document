--- Created by shimin.
--- DateTime: 2024/1/8 18:05
--- 建筑属性详情界面
local UIBuildDetailCtrl = BaseClass("UIBuildDetailCtrl", UIBaseCtrl)

function UIBuildDetailCtrl:CloseSelf()
	UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildDetail)
end

return UIBuildDetailCtrl