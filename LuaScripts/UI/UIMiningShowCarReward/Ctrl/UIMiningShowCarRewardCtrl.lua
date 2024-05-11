
local UIMiningShowCarRewardCtrl = BaseClass("UIMiningShowCarRewardCtrl", UIBaseCtrl)

function UIMiningShowCarRewardCtrl : CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMiningShowCarReward)
end

return UIMiningShowCarRewardCtrl