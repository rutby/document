--- Created by shimin.
--- DateTime: 2023/3/6 11:21
--- 黑骑士活动管理器

local ActBlackKnightManager = BaseClass("ActBlackKnightManager")
local ActBlackKnightInfo = require "DataCenter.ActivityListData.ActBlackKnightInfo"
local ActBlackKnightKillRewardInfo = require "DataCenter.ActivityListData.ActBlackKnightKillRewardInfo"
local ActBlackKnightLevelRewardInfo = require "DataCenter.ActivityListData.ActBlackKnightLevelRewardInfo"
local ActBlackKnightUserRankInfo = require "DataCenter.ActivityListData.ActBlackKnightUserRankInfo"
local ActBlackKnightAllianceRankInfo = require "DataCenter.ActivityListData.ActBlackKnightAllianceRankInfo"

local Setting = CS.GameEntry.Setting
local PushEventType = 
{
	StartEventAnnounce = 1,--推送活动开始的联盟公告
	BossEventAnnounce = 2,--推送领主出动的联盟公告
	EndEventAnnounce = 3--推送本联盟活动结束（出怪结束）的联盟公告
}

function ActBlackKnightManager:__init()
	self:AddListener()
	self.warningState = BlackKnightWarningState.Open
	self.actInfo = ActBlackKnightInfo.New()
	--奖励信息
	self.levelRankRewardList = {} --阶段目标奖励
	self.memberKillRankRewardList = {} --个人杀怪排名奖励
	self.allianceKillRankRewardList = {} --联盟杀怪排名奖励
	self.userRankHistory = {}--个人杀敌排行榜
	self.allianceRankHistory = {}--联盟杀敌排行榜
end

function ActBlackKnightManager:__delete()
	self:RemoveListener()
	self.warningState = BlackKnightWarningState.Open
	self.levelRankRewardList = {} --阶段目标奖励
	self.memberKillRankRewardList = {} --个人杀怪排名奖励
	self.allianceKillRankRewardList = {} --联盟杀怪排名奖励
	self.userRankHistory = {}--个人杀敌排行榜
	self.allianceRankHistory = {}--联盟杀敌排行榜
end

function ActBlackKnightManager:Startup()
end

function ActBlackKnightManager:AddListener()
	if self.getRankRefreshSignal == nil then
		self.getRankRefreshSignal = function(t)
			self:GetRankRefreshSignal(t)
		end
		EventManager:GetInstance():AddListener(EventId.GetRankRefresh, self.getRankRefreshSignal)
	end
end

function ActBlackKnightManager:RemoveListener()
	if self.getRankRefreshSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.GetRankRefresh, self.getRankRefreshSignal)
		self.getRankRefreshSignal = nil
	end
end

function ActBlackKnightManager:InitData()
	self.warningState = Setting:GetPrivateInt(SettingKeys.BLACK_KNIGHT_CANCEL_WARNING, BlackKnightWarningState.Open)
	self:SendMonsterSiegeActivityInfo()
	self:SendMonsterSiegeRewardInfo()
end

--获取黑骑士活动数据
function ActBlackKnightManager:GetActInfo()
	return self.actInfo
end

--获取活动的状态
function ActBlackKnightManager:GetActState()
	return self.actInfo.state
end

--获取活动的状态
function ActBlackKnightManager:GetUIActState()
	if not LuaEntry.Player:IsInAlliance() then
		return BlackKnightState.NoAlliance
	end
	return self:GetActState()
end

--是否是开启警告
function ActBlackKnightManager:IsShowWarning()
	return self.warningState == BlackKnightWarningState.Open
end

--开启警告
function ActBlackKnightManager:OpenWarning()
	if self.warningState ~= BlackKnightWarningState.Open then
		self.warningState = BlackKnightWarningState.Open
		Setting:SetPrivateInt(SettingKeys.BLACK_KNIGHT_CANCEL_WARNING, BlackKnightWarningState.Open)
		EventManager:GetInstance():Broadcast(EventId.BlackKnightWarning)
	end
end

--关闭启警告
function ActBlackKnightManager:CloseWarning()
	if self.warningState ~= BlackKnightWarningState.Close then
		self.warningState = BlackKnightWarningState.Close
		Setting:SetPrivateInt(SettingKeys.BLACK_KNIGHT_CANCEL_WARNING, BlackKnightWarningState.Close)
		EventManager:GetInstance():Broadcast(EventId.BlackKnightWarning)
	end
end

--处理获取黑骑士活动消息
function ActBlackKnightManager:MonsterSiegeActivityInfoHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		UIUtil.ShowTipsId(errorCode)
	else
		self.actInfo:ParseInfo(message)
		EventManager:GetInstance():Broadcast(EventId.BlackKnightUpdate)
	end
end

--处理获取黑骑士联盟开启怪物攻城消息
function ActBlackKnightManager:MonsterSiegeStartHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		UIUtil.ShowTipsId(errorCode)
	else
		self.actInfo:ChangePoint(message)
		UIUtil.ShowTipsId(GameDialogDefine.START_BLACK_KNIGHT_TIPS)
		self:SendMonsterSiegeActivityInfo()
		--跳到世界点
		GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.actInfo.pointId,ForceChangeScene.World), CS.SceneManager.World.InitZoom
			,LookAtFocusTime, nil, LuaEntry.Player.serverId)
	end
end

--处理获取黑骑士怪物攻城奖励信息消息
function ActBlackKnightManager:MonsterSiegeRewardInfoHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		UIUtil.ShowTipsId(errorCode)
	else
		self.levelRankRewardList = {}
		self.memberKillRankRewardList = {}
		self.allianceKillRankRewardList = {}
		local msReward = message["msReward"]
		if msReward ~= nil then
			local gole = msReward["gole"]
			if gole ~= nil then
				for k,v in ipairs(gole) do
					local rewardInfo = ActBlackKnightLevelRewardInfo.New()
					rewardInfo:ParseInfo(v)
					table.insert(self.levelRankRewardList, rewardInfo)
				end
				if self.levelRankRewardList[2] ~= nil then
					table.sort(self.levelRankRewardList, function(a,b) 
						return a.rank < b.rank
					end)
				end
			end

			local memberKill = msReward["memberKill"]
			if memberKill ~= nil then
				for k,v in ipairs(memberKill) do
					local rewardInfo = ActBlackKnightKillRewardInfo.New()
					rewardInfo:ParseInfo(v)
					table.insert(self.memberKillRankRewardList, rewardInfo)
				end
				if self.memberKillRankRewardList[2] ~= nil then
					table.sort(self.memberKillRankRewardList, function(a,b)
						return a.rank < b.rank
					end)
				end
			end

			local allianceKill = msReward["allianceKill"]
			if allianceKill ~= nil then
				for k,v in ipairs(allianceKill) do
					local rewardInfo = ActBlackKnightKillRewardInfo.New()
					rewardInfo:ParseInfo(v)
					table.insert(self.allianceKillRankRewardList, rewardInfo)
				end
				if self.allianceKillRankRewardList[2] ~= nil then
					table.sort(self.allianceKillRankRewardList, function(a,b)
						return a.rank < b.rank
					end)
				end
			end
		end
	end
end

--联盟开启怪物攻城
function ActBlackKnightManager:SendMonsterSiegeStart()
	SFSNetwork.SendMessage(MsgDefines.MonsterSiegeStart)
end

--黑骑士活动数据
function ActBlackKnightManager:SendMonsterSiegeActivityInfo()
	SFSNetwork.SendMessage(MsgDefines.MonsterSiegeActivityInfo)
end

--怪物攻城奖励信息
function ActBlackKnightManager:SendMonsterSiegeRewardInfo()
	SFSNetwork.SendMessage(MsgDefines.MonsterSiegeRewardInfo)
end

--推送怪物攻城信息
function ActBlackKnightManager:PushMonsterAttackHandle(message)
	local pushEventType = message["type"]
	if pushEventType == PushEventType.StartEventAnnounce then
		UIUtil.ShowTipsId(GameDialogDefine.START_BLACK_KNIGHT_TIPS)
		self:SendMonsterSiegeActivityInfo()
	elseif pushEventType == PushEventType.BossEventAnnounce then
		UIUtil.ShowTipsId(GameDialogDefine.BOSS_BLACK_KNIGHT_TIPS)
	elseif pushEventType == PushEventType.EndEventAnnounce then
		UIUtil.ShowTipsId(GameDialogDefine.BLACK_KNIGHT_OVER)
		self:SendMonsterSiegeActivityInfo()
	end
end

--获取活动中的黑骑士活动数据
function ActBlackKnightManager:GetActivity()
	local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.BlackKnight)
	if dataList ~= nil then
		return dataList[1]
	end
	return nil
end

--黑骑士个人杀怪排行榜
function ActBlackKnightManager:SendMonsterSiegeUserRank()
	SFSNetwork.SendMessage(MsgDefines.GetRank, RankType.MONSTER_SIEGE_USER)
end

--黑骑士联盟杀怪排行榜
function ActBlackKnightManager:SendMonsterSiegeAllianceRank()
	SFSNetwork.SendMessage(MsgDefines.GetRank, RankType.MONSTER_SIEGE_ALLIANCE)
end

--黑骑士联盟杀怪排行榜
function ActBlackKnightManager:GetRankRefreshSignal(message)
	local errorCode = message["errorCode"]
	if errorCode == nil then
		local rankType = message["type"]
		if rankType == RankType.MONSTER_SIEGE_USER then
			self.userRankHistory = {}
			local allianceRanking = message["rankArr"]
			if allianceRanking ~= nil then
				for k,v in ipairs(allianceRanking) do
					local info = ActBlackKnightUserRankInfo.New()
					info:ParseInfo(v)
					table.insert(self.userRankHistory, info)
				end
				if self.userRankHistory[2] ~= nil then
					table.sort(self.userRankHistory, function(a,b)
						return a.rank < b.rank
					end)
				end
			end
			EventManager:GetInstance():Broadcast(EventId.BlackKnightRank)
		elseif rankType == RankType.MONSTER_SIEGE_ALLIANCE then
			self.allianceRankHistory = {}
			local allianceRanking = message["rankList"]
			if allianceRanking ~= nil then
				for k,v in ipairs(allianceRanking) do
					local info = ActBlackKnightAllianceRankInfo.New()
					info:ParseInfo(v)
					table.insert(self.allianceRankHistory, info)
				end
				if self.allianceRankHistory[2] ~= nil then
					table.sort(self.allianceRankHistory, function(a,b)
						return a.rank < b.rank
					end)
				end
			end
			EventManager:GetInstance():Broadcast(EventId.BlackKnightRank)
		end
	end
end

--获取黑骑士个人杀怪排行榜
function ActBlackKnightManager:GetUserRankHistory()
	return self.userRankHistory
end

--获取黑骑士联盟杀怪排行榜
function ActBlackKnightManager:GetAllianceRankHistory()
	return self.allianceRankHistory
end

--获取黑骑士活动本周结束时间
function ActBlackKnightManager:GetWeekEndTime()
	local result = 0
	local act = self:GetActInfo()
	if act ~= nil then
		result = act.activityET
	end
	return result
end

--获取黑骑士分数奖励
function ActBlackKnightManager:GetLevelRankRewardList()
	return self.levelRankRewardList
end

--获取黑骑士个人排行奖励奖励
function ActBlackKnightManager:GetUserRewardList()
	return self.memberKillRankRewardList
end

--获取黑骑士联盟排行奖励奖励
function ActBlackKnightManager:GetAllianceRewardList()
	return self.allianceKillRankRewardList
end

--获取黑骑士个人排行奖励奖励
function ActBlackKnightManager:GetUserRewardByRank(rank)
	return self.memberKillRankRewardList[rank + 1] --0开始
end

--获取黑骑士联盟排行奖励奖励
function ActBlackKnightManager:GetAllianceRewardByRank(rank)
	return self.allianceKillRankRewardList[rank + 1] --0开始
end

--是否正在警告
function ActBlackKnightManager:IsActWarning()
	if self:GetActState() == BlackKnightState.OPEN then
		return true
	end
	return false
end

function ActBlackKnightManager:CheckIfIsNew()
	local endTime = self:GetWeekEndTime() / 1000
	local lastTime = Setting:GetPrivateInt(SettingKeys.BLACK_KNIGHT_RED_NEW, 0)
	if lastTime ~= endTime then
		return true
	end
	return false
end

function ActBlackKnightManager:SetIsNew()
	local endTime = self:GetWeekEndTime() / 1000
	Setting:SetPrivateInt(SettingKeys.BLACK_KNIGHT_RED_NEW, endTime)
	EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

function ActBlackKnightManager:GetSelfAllianceRank()
	local param = {}
	param.rankType = UIBlackKnightRankType.AllianceRank
	local data = ActBlackKnightAllianceRankInfo.New()
	param.noUseBg = true
	param.data = data
	local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
	if allianceData ~= nil then
		data.abbr =allianceData.abbr
		data.allianceName =allianceData.allianceName
		data.icon = allianceData.icon
	else
		data.abbr = ""
		data.allianceName = ""
		data.icon = ""--联盟图标 string
	end
	local info = DataCenter.ActBlackKnightManager:GetActInfo()
	if info ~= nil then
		data.score = info.allKill or 0--分数 long  
		data.rank = info.allRank or 0
	end
	return param
end

function ActBlackKnightManager:GetSelfRank()
	local param = {}
	param.rankType = UIBlackKnightRankType.PersonalRank
	local data = ActBlackKnightUserRankInfo.New()
	param.data = data
	param.noUseBg = true
	local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
	if allianceData ~= nil then
		data.abbr =allianceData.abbr
		data.allianceName =allianceData.allianceName
		data.icon = allianceData.icon
	else
		data.abbr = ""
		data.allianceName = ""
		data.icon = ""--联盟图标 string
	end

	data.uid = LuaEntry.Player.uid
	data.pic = LuaEntry.Player.pic
	data.picVer = LuaEntry.Player.picVer
	data.name = LuaEntry.Player.name
	data.headSkinId = LuaEntry.Player.headSkinId
	data.headSkinET = LuaEntry.Player.headSkinET
	
	local info = DataCenter.ActBlackKnightManager:GetActInfo()
	if info ~= nil then
		data.score = info.userKill or 0--分数 long  
		data.rank = info.userRank or 0
	end
	return param
end


return ActBlackKnightManager