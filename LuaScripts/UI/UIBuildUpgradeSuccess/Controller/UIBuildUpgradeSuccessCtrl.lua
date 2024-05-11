
local UIBuildUpgradeSuccessCtrl = BaseClass("UIBuildUpgradeSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuildUpgradeSuccess)
end

UIBuildUpgradeSuccessCtrl.CloseSelf = CloseSelf

return UIBuildUpgradeSuccessCtrl