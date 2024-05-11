
local UIArmyUnlockCtrl = BaseClass("UIArmyUnlockCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArmyUnlock)
end

UIArmyUnlockCtrl.CloseSelf = CloseSelf

return UIArmyUnlockCtrl