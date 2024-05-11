local UIArenaRewardCtrl = BaseClass("UIArenaRewardCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIArenaReward)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function ShowReward(self,actId)
	local list = {}
	if actId then
		local activityLine = LocalController:instance():getLine(TableName.ActivityPanel, actId)
		list.strLevel = string.split(activityLine.para1,"|")
		local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
		local seasonReward = string.split(activityLine.para2,"#")
		if seasonReward[seasonId] then
			list.strReward = string.split(seasonReward[seasonId],"|")
		else
			list.strReward = string.split(seasonReward[table.count(seasonReward)],"|")
		end
	end
	return list
end

UIArenaRewardCtrl.CloseSelf = CloseSelf
UIArenaRewardCtrl.Close = Close
UIArenaRewardCtrl.ShowReward = ShowReward
return UIArenaRewardCtrl