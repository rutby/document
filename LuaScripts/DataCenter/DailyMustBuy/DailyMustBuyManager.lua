---@class DailyMustBuyManager
local DailyMustBuyManager = BaseClass("DailyMustBuyManager")
local Localization = CS.GameEntry.Localization


local function __init(self)
	self.stages = nil
	EventManager:GetInstance():AddListener(EventId.OnPassWeek, self.RequestClaimedReward)
end

local function __delete(self)
	self.stages = nil
	EventManager:GetInstance():RemoveListener(EventId.OnPassWeek, self.RequestClaimedReward)
end


---@param msg table
local function UpdateData(self,msg)
	if not msg then
		return
	end
	self.stages = msg.dailyMustList
	if not table.IsNullOrEmpty(self.stages) then
		for i, v in pairs(self.stages) do
			v.showReward = DataCenter.RewardManager:ReturnRewardParamForView(v.reward)
		end
	end
	EventManager:GetInstance():Broadcast(EventId.OnDailyMustBuyDataChanged)
	EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function AddNewClaimedReward(self,index)
	if not index then
		return
	end
	if not table.IsNullOrEmpty(self.stages) then
		for i, v in pairs(self.stages) do
			if v.index == index then
				v.state = 1
				break
			end
		end
	end
	EventManager:GetInstance():Broadcast(EventId.OnDailyMustBuyDataChanged)
	EventManager:GetInstance():Broadcast(EventId.RefreshWelfareRedDot)
end

local function ClaimRewardAtStage(self,stageId)
	if not stageId then
		return
	end
	SFSNetwork.SendMessage(MsgDefines.DailyMustBuyReward,stageId)
end

local function RequestClaimedReward(self)
	SFSNetwork.SendMessage(MsgDefines.DailyMustBuyList)
end

local function GetMaxScore(self)
	if self.maxScore then
		return self.maxScore
	end
	local maxScore = 0
	if not table.IsNullOrEmpty(self.stages) then
		for i, v in pairs(self.stages) do
			if v.score > maxScore then
				maxScore = v.score
			end
		end
	end
	self.maxScore = maxScore
	return maxScore
end

local function GetCurScore(self)
	if not self.itemId then
		self.itemId = LuaEntry.DataConfig:TryGetNum("Daily_must_buy", "k2",0)
	end
	local count = DataCenter.ItemData:GetItemCount(self.itemId)
	return count
end

local function GetStages(self)
	if not self.stages then
		return {}
	end
	return DeepCopy(self.stages)
end

local function GetCanGetStageNum(self)
	if not self.stages then
		return 0
	end
	local num = 0
	local curScore = DataCenter.DailyMustBuyManager:GetCurScore()
	for i, v in pairs(self.stages) do
		if v.state == 0 and v.score <= curScore then
			num = num + 1
		end
	end
	return num
end

DailyMustBuyManager.__init = __init
DailyMustBuyManager.__delete = __delete
DailyMustBuyManager.UpdateData = UpdateData
DailyMustBuyManager.AddNewClaimedReward = AddNewClaimedReward
DailyMustBuyManager.ClaimRewardAtStage = ClaimRewardAtStage
DailyMustBuyManager.RequestClaimedReward = RequestClaimedReward
DailyMustBuyManager.GetMaxScore = GetMaxScore
DailyMustBuyManager.GetCurScore = GetCurScore
DailyMustBuyManager.GetStages = GetStages
DailyMustBuyManager.GetCanGetStageNum = GetCanGetStageNum

return DailyMustBuyManager