
local UIActDragonBattleTimeCtrl = BaseClass("UIActDragonBattleTimeCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActDragonBattleTime)
end

UIActDragonBattleTimeCtrl.CloseSelf = CloseSelf

return UIActDragonBattleTimeCtrl