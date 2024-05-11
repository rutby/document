local UIAllianceCompeteNewCtrl = BaseClass("UIAllianceCompeteNewCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceCompeteNew)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetAllianceListRanked(self)
	local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
	
	local retList = {}
	if tempStage == LeagueMatchStage.Notice or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
		retList = DataCenter.LeagueMatchManager:GetLastMatchGroupInfo()
	else
		retList = DataCenter.LeagueMatchManager:GetMatchGroupInfo()
	end
	retList = retList or {}
	table.sort(retList, function(a, b)
		if a.winTimes ~= b.winTimes then
			return a.winTimes > b.winTimes
		elseif (not string.IsNullOrEmpty(a.roundResult)) and a.roundResult ~= b.roundResult then
			return a.roundResult > b.roundResult
		elseif a.position ~= b.position then
			return a.position < b.position
		else
			return false
		end
	end)

	for i, v in ipairs(retList) do
		v.rank = i
	end
	
	--local tempRank = 0
	--local tempStr = "-"
	--for i, v in ipairs(retList) do
	--	if v.roundResult ~= tempStr then
	--		tempStr = v.roundResult
	--		tempRank = i
	--		v.rank = tempRank
	--	else
	--		v.rank = tempRank
	--	end
	--end
	
	return retList
end

local function CheckIfTabIsVisible(self, tabType)
	local myMatchInfo = DataCenter.LeagueMatchManager:GetMyMatchInfo()
	local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
	if tabType == LeagueMatchTab.Activity then
		local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
		if not actInfo or actInfo.finish or actInfo:GetEventInfo() == nil then
			return false
		end
		return true
	elseif tabType == LeagueMatchTab.Compete then
		local hasAlliance = LuaEntry.Player:IsInAlliance()
		if not hasAlliance then
			return true
		end
		
		local isSubmiting = DataCenter.LeagueMatchManager:CheckIsSubmitting()
		
		local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
		return actInfo
	elseif tabType == LeagueMatchTab.CrossServer then
		if not LuaEntry.Player:IsInAlliance() then
			return false
		end
		local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
		if actInfo then
			local eventInfo = actInfo:GetEventInfo()
			if eventInfo and eventInfo:CheckIfShowCrossServer() then
				return true
			end
		end
		return false
	elseif tabType == LeagueMatchTab.CrossServerDesert then
		if not LuaEntry.Player:IsInAlliance() then
			return false
		end
		local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
		if actInfo then
			local eventInfo = actInfo:GetEventInfo()
			if eventInfo and eventInfo:CheckIfShowCrossDesert() then
				return true
			end
		end
		return false
	elseif tabType == LeagueMatchTab.Notice then
		if tempStage == LeagueMatchStage.Notice then
			return true
		else
			return false
		end
	elseif tabType == LeagueMatchTab.DrawLots then
		local allianceInMatch = DataCenter.LeagueMatchManager:CheckAllianceInMatch()
		if not allianceInMatch then
			return false
		end
		if (tempStage == LeagueMatchStage.DrawLots) or tempStage == LeagueMatchStage.DrawLotsFinished then
			return true
		else
			return false
		end
	elseif tabType == LeagueMatchTab.AllianceRank then
		if tempStage == LeagueMatchStage.Notice or tempStage == LeagueMatchStage.DrawLots or tempStage == LeagueMatchStage.DrawLotsFinished then
			if myMatchInfo and myMatchInfo.lastDuelInfo then
				return true
			else
				return false
			end
		else
			if myMatchInfo and myMatchInfo.duelInfo then
				return true
			else
				return false
			end
		end
	else
		return false
	end
end


UIAllianceCompeteNewCtrl.CloseSelf = CloseSelf
UIAllianceCompeteNewCtrl.Close = Close

UIAllianceCompeteNewCtrl.CheckIfTabIsVisible = CheckIfTabIsVisible
UIAllianceCompeteNewCtrl.GetAllianceListRanked = GetAllianceListRanked

return UIAllianceCompeteNewCtrl