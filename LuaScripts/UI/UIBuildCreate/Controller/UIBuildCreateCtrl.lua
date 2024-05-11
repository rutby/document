--- Created by shimin
--- DateTime: 2023/11/23 22:41
--- 建筑建造界面

local UIBuildCreateCtrl = BaseClass("UIBuildCreateCtrl", UIBaseCtrl)

function UIBuildCreateCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildCreate)
end

return UIBuildCreateCtrl