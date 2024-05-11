local UIActGiftBoxRewardCtrl = BaseClass("UIActGiftBoxRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIActGiftBoxReward)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIActGiftBoxRewardCtrl.CloseSelf = CloseSelf
UIActGiftBoxRewardCtrl.Close = Close
return UIActGiftBoxRewardCtrl