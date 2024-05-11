--
-- PVE 通关奖励界面Controller
--

local UIPVELevelRewardCtrl = BaseClass("UIPVELevelRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVELevelReward, { anim = false, UIMainAnim = UIMainAnimType.AllHide })
end

UIPVELevelRewardCtrl.CloseSelf = CloseSelf

return UIPVELevelRewardCtrl