local UISeasonRankRewardCtrl = BaseClass("UISeasonRankRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UISeasonRankReward)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function ShowReward(self,actId)
	local list = {}
	local activityLine = LocalController:instance():getLine(TableName.ActivityPanel, actId)
	list.strLevel = string.split(activityLine.para1,"|")
	list.strReward = string.split(activityLine.para2,"|")
	return list
end

UISeasonRankRewardCtrl.CloseSelf = CloseSelf
UISeasonRankRewardCtrl.Close = Close
UISeasonRankRewardCtrl.ShowReward = ShowReward
return UISeasonRankRewardCtrl