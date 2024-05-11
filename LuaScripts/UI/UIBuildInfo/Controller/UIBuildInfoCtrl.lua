--- Created by shimin
--- DateTime: 2024/01/08 17:06
--- 建筑信息界面

local UIBuildInfoCtrl = BaseClass("UIBuildInfoCtrl", UIBaseCtrl)

function UIBuildInfoCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildInfo)
end

return UIBuildInfoCtrl