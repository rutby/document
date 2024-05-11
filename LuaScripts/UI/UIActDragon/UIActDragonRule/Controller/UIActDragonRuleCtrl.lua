
local UIActDragonRuleCtrl = BaseClass("UIActDragonRuleCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActDragonRule)
end

UIActDragonRuleCtrl.CloseSelf = CloseSelf

return UIActDragonRuleCtrl