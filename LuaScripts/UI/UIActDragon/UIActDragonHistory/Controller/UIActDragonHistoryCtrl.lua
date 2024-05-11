
local UIActDragonHistoryCtrl = BaseClass("UIActDragonHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActDragonHistory)
end

UIActDragonHistoryCtrl.CloseSelf = CloseSelf

return UIActDragonHistoryCtrl