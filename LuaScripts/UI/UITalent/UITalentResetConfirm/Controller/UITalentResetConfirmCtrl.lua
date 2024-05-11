local UITalentResetConfirmCtrl = BaseClass("UITalentResetConfirmCtrl", UIBaseCtrl)
local function CloseSelf(self,noPlayCloseEffect)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITalentResetConfirm)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UITalentResetConfirmCtrl.CloseSelf =CloseSelf
UITalentResetConfirmCtrl.Close =Close

return UITalentResetConfirmCtrl