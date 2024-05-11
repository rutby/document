--UIDigRewardCtrl.lua

local UIDigRewardCtrl = BaseClass("UIDigRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIDigReward)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIDigRewardCtrl.CloseSelf = CloseSelf
UIDigRewardCtrl.Close = Close

return UIDigRewardCtrl