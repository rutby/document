local ScienceManager = BaseClass("ScienceManager")
local Localization = CS.GameEntry.Localization

local function __init(self)
	self.scienceTab = {}
end

local function __delete(self)
	self.scienceTab = nil
end

local function PushScienceChangeHandle(self,message)
	local science = message["science"]
	if science ~= nil then
		DataCenter.ScienceDataManager:UpdateOneData(science)
		local scienceId = science["itemId"]
		local level = science["level"]
		DataCenter.BuildManager:CheckShowBuildUnlockWhenScienceLevelUp(scienceId, level)
		EventManager:GetInstance():Broadcast(EventId.UPDATE_SCIENCE_DATA, scienceId)
		local power = GetTableData(DataCenter.ScienceTemplateManager:GetTableName(), scienceId + level, "power", 0)
		if level > 1 then
			power = power - GetTableData(DataCenter.ScienceTemplateManager:GetTableName(), scienceId + level - 1, "power", 0)
		end
		
		if power > 0 then
			GoToUtil.ShowPower({power = power})
		end
	end
end

local function ScienceResearchNewMessageHandle(self,message)
	if message["errorCode"] == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end

		if message["gold"] ~= nil then
			LuaEntry.Player.gold = message["gold"]
			EventManager:GetInstance():Broadcast(EventId.UpdateGold)
		end

		if message["goodsRest"] ~= nil then
			DataCenter.ItemData:UpdateItems(message["goodsRest"])
			EventManager:GetInstance():Broadcast(EventId.RefreshItems)
		end
		
		local queue = message["queue"]
		if queue ~= nil then
			local itemObj = queue["itemObj"]
			if itemObj ~= nil then
				DataCenter.QueueDataManager:UpdateQueueData(queue)
				EventManager:GetInstance():Broadcast(EventId.OnScienceQueueResearch, queue["funcUuid"])
			end
		end
		local science = message["science"]
		if science ~= nil then
			DataCenter.ScienceDataManager:UpdateOneData(science)
			local scienceId = science["itemId"]
			local level = science["level"]
			UIUtil.ShowTips(Localization:GetString("129062",
					Localization:GetString(GetTableData(DataCenter.ScienceTemplateManager:GetTableName(), scienceId + level, "name", 0))))
			DataCenter.BuildManager:CheckShowBuildUnlockWhenScienceLevelUp(scienceId, level)
			EventManager:GetInstance():Broadcast(EventId.UPDATE_SCIENCE_DATA, scienceId)
			local power = GetTableData(DataCenter.ScienceTemplateManager:GetTableName(), scienceId + level, "power", 0)
			if level > 1 then
				power = power - GetTableData(DataCenter.ScienceTemplateManager:GetTableName(), scienceId + level - 1, "power", 0)
			end
			if power > 0 then
				GoToUtil.ShowPower({power = power})
			end
		end
	else
		local errorCode = message["errorCode"]
		if errorCode ~= SeverErrorCode then
			UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
		end
	end
end

local function GetScienceTemplate(self,id)
	local level = self:GetScienceLevel(id)
	if level <= 0 then
		level = 1
	end
	return DataCenter.ScienceTemplateManager:GetScienceTemplate(id,level)
end

local function GetScienceLevel(self,id)
	local science = DataCenter.ScienceDataManager:GetScienceById(id)
	if science ~= nil then
		return science.level
	end
	return 0
end

--获取该科技能提升的最大等级
local function GetScienceMaxLevel(self,id)
	local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id)
	if template ~= nil then
		return template.max_level
	end
	return 0
end

local function GetScienceQueue(self)
	return DataCenter.QueueDataManager:GetQueueByType(NewQueueType.Science)
end

local function GetScienceQueueByScienceId(self,scienceId)
	return DataCenter.QueueDataManager:GetQueueByScienceId(scienceId)
end

local function CheckResearchFinish(self) 
	local queue = self:GetScienceQueue()
	if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
		local param = {}
		param.uuid =  queue.uuid
		SFSNetwork.SendMessage(MsgDefines.QueueFinish, param)
		return true
	end
	return false
end

local function CheckResearchFinishByBuildUuid(self,bUuid)
	local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(bUuid)
	if queue ~= nil and queue:GetQueueState() == NewQueueState.Finish then
		local param = {}
		param.uuid =  queue.uuid
		SFSNetwork.SendMessage(MsgDefines.QueueFinish, param)
		return true
	end
	return false
end

--获取正在研究的科技template
local function GetSearchingScienceTemplate(self,uuid)
	local queue = DataCenter.QueueDataManager:GetQueueByUuid(uuid)
	if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
		local id = tonumber(queue.itemId)
		local level = 1
		local science = DataCenter.ScienceDataManager:GetScienceById(id)
		if science ~= nil then
			level = science.level + 1
		end
		return DataCenter.ScienceTemplateManager:GetScienceTemplate(id,level)
	end
end

--是否有该等级的科技
local function HasScienceByIdAndLevel(self,id,level)
	local temp = DataCenter.ScienceDataManager:GetScienceById(id)
	return temp ~= nil and temp.level >= level
end

local function GetRealResearchQueue(self, bUuid)
	local retQueue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(bUuid)
	if retQueue:GetQueueState() ~= NewQueueState.Free then
		local mainLvLimit = LuaEntry.DataConfig:TryGetNum("science_interface", "k2") or 0
		if DataCenter.BuildManager.MainLv >= mainLvLimit then
			local freeQueue = DataCenter.QueueDataManager:GetIsQueueFreeForScienceId()
			if freeQueue then
				retQueue = freeQueue
			end
		end
	end
	return retQueue
end

ScienceManager.__init = __init
ScienceManager.__delete = __delete
ScienceManager.PushScienceChangeHandle = PushScienceChangeHandle
ScienceManager.ScienceResearchNewMessageHandle = ScienceResearchNewMessageHandle
ScienceManager.GetScienceTemplate = GetScienceTemplate
ScienceManager.GetScienceLevel = GetScienceLevel
ScienceManager.GetScienceMaxLevel = GetScienceMaxLevel
ScienceManager.GetScienceQueue = GetScienceQueue
ScienceManager.CheckResearchFinish = CheckResearchFinish
ScienceManager.GetSearchingScienceTemplate = GetSearchingScienceTemplate
ScienceManager.HasScienceByIdAndLevel = HasScienceByIdAndLevel
ScienceManager.GetScienceQueueByScienceId = GetScienceQueueByScienceId
ScienceManager.CheckResearchFinishByBuildUuid = CheckResearchFinishByBuildUuid
ScienceManager.GetRealResearchQueue = GetRealResearchQueue
return ScienceManager