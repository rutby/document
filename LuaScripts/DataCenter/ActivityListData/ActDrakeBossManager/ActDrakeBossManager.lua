--- Created by shimin.
--- DateTime: 2023/10/30 21:00
--- 德雷克boss活动管理器

local ActDrakeBossManager = BaseClass("ActDrakeBossManager")
local ActDrakeBossInfo = require "DataCenter.ActivityListData.ActDrakeBossManager.ActDrakeBossInfo"

function ActDrakeBossManager:__init()
	self:AddListener()
	self.drake_join_boss_times = 0--德雷克boss参与击杀次数
end

function ActDrakeBossManager:__delete()
	self:RemoveListener()
	self.drake_join_boss_times = 0--德雷克boss参与击杀次数
end

function ActDrakeBossManager:Startup()
end

function ActDrakeBossManager:AddListener()
	
end

function ActDrakeBossManager:RemoveListener()
	
end

function ActDrakeBossManager:InitData(message)
	self.drake_join_boss_times = message["drake_join_boss_times"] or 0
	self.actInfo = ActDrakeBossInfo.New()
end

--推送德雷克活动boos参与击杀次数
function ActDrakeBossManager:PushDailyKillDrakeBossNumberHandle(message)
	local time = message["drake_join_boss_times"]
	if time ~= nil then
		self.drake_join_boss_times = time
	end
	EventManager:GetInstance():Broadcast(EventId.RefreshDrakeBoss)
end

--发送获得上一次召唤的未被击杀的德雷克boss
function ActDrakeBossManager:SendGetUserDrakeBoss()
	SFSNetwork.SendMessage(MsgDefines.GetUserDrakeBoss)
end

--处理获得上一次召唤的未被击杀的德雷克boss
function ActDrakeBossManager:GetUserDrakeBossHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		UIUtil.ShowTipsId(errorCode)
	else
		self.actInfo:ParseInfo(message)
		EventManager:GetInstance():Broadcast(EventId.RefreshDrakeBoss)
	end
end

--获取活动Boss数据
function ActDrakeBossManager:GetActBossInfo()
	return self.actInfo
end

--当点击使用道具
function ActDrakeBossManager:OnClickUseItem(itemData)
	local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemData.itemId)
	if itemTemplate ~= nil then
		--先判断是否已经召唤德雷克
		if self:HasBoss() then
			--判断boss是否距离过远
			if self:IsBossFar() then
				--弹出提示
				UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.DRAKE_BOSS_FAR_TIPS), 1, GameDialogDefine.FIND_GODZILLA, GameDialogDefine.CANCEL, function()
					--英雄是否满军阶
					local isMax = false
					local heroId = tonumber(itemTemplate.para3)
					local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
					if heroData ~= nil and heroData:IsReachMaxMilitaryRank() then
						isMax = true
					end
					if isMax then
						--弹出使用道具面板
						local param = {}
						param.uuid = itemData.uuid
						UIManager:GetInstance():OpenWindow(UIWindowNames.UIDrakeBossUseItem, {anim = true, isBlur = true}, param)
					else
						--召唤并跳转
						SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = itemData.uuid, num = self:GetPerUseItemCount(), callBossUseType = CallBossUseType.CallBoss})
					end
				end)
			else
				--跳转到世界上
				self:GoToBoss()
			end
		else
			--英雄是否满军阶
			local isMax = false
			local heroId = tonumber(itemTemplate.para3)
			local heroData = DataCenter.HeroDataManager:GetHeroById(heroId)
			if heroData ~= nil and heroData:IsReachMaxMilitaryRank() then
				isMax = true
			end
			if isMax then
				--弹出使用道具面板
				local param = {}
				param.uuid = itemData.uuid
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIDrakeBossUseItem, {anim = true, isBlur = true}, param)
			else
				--召唤并跳转
				SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = itemData.uuid, num = self:GetPerUseItemCount(), callBossUseType = CallBossUseType.CallBoss})
			end
		end
	end
end

--是否有boss
function ActDrakeBossManager:HasBoss()
	return self.actInfo:HasBoss()
end

--跳转到boss
function ActDrakeBossManager:GoToBoss()
	GoToUtil.CloseAllWindows()
	local pointId = self.actInfo.pointId
	local pos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
	GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
		GoToUtil.MoveToWorldPointAndOpen(pointId)
		--UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false, UIMainAnim = UIMainAnimType.LeftRightBottomHide}, self.actInfo.uuid, pointId, "", WorldPointUIType.Boss,0)
	end)
end

--处理获得上一次召唤的未被击杀的德雷克boss
function ActDrakeBossManager:UseItemHandle(message)
	self.actInfo:UpdateInfo(message)
	self:GoToBoss()
end

--获取活动的数据
function ActDrakeBossManager:GetActivity()
	local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.LeadingQuest.Type)
	if dataList ~= nil then
		for k, v in ipairs(dataList) do
			if v.sub_type == ActivityEnum.ActivitySubType.DrakeBoss then
				return v
			end
		end
	end
	return nil
end

--获取使用道具id
function ActDrakeBossManager:GetItemId()
	local act = self:GetActivity()
	if act ~= nil then
		return tonumber(act.para1)
	end
	return nil
end

--获取任务
function ActDrakeBossManager:GetTask()
	local act = self:GetActivity()
	if act ~= nil then
		local taskGroups = act:GetTaskGroups()
		for i, taskList in ipairs(taskGroups) do
			for m, taskId in ipairs(taskList) do
				return DataCenter.TaskManager:FindTaskInfo(taskId)
			end
		end
	end
	return nil
end

--每次使用道具数量
function ActDrakeBossManager:GetPerUseItemCount()
	return 1
end

--参与集结德雷克BOSS的次数
function ActDrakeBossManager:GetJoinMaxAllTimes()
	return LuaEntry.DataConfig:TryGetNum("drake_boss", "k1")
end

--获取今日参与集结德雷克BOSS的次数
function ActDrakeBossManager:GetCurJoinTimes()
	return self.drake_join_boss_times
end

--获取发起集结的奖励
function ActDrakeBossManager:GetCallShowReward()
	local result = {}
	local act = self:GetActivity()
	if act ~= nil and act.para2 ~= nil and act.para2 ~= "" then
		local str = string.split_ss_array(act.para2, ";")
		for k, v in ipairs(str) do
			local str1 = string.split_ss_array(v, ",")
			if str1[3] ~= nil then
				local param = {}
				param.rewardType = tonumber(str1[2])
				param.itemId = str1[1]
				param.count = tonumber(str1[3])
				table.insert(result, param)
			end
		end
	end
	return result
end

--获取参与集结的奖励
function ActDrakeBossManager:GetJoinShowReward()
	local result = {}
	local act = self:GetActivity()
	if act ~= nil and act.para3 ~= nil and act.para3 ~= "" then
		local str = string.split_ss_array(act.para3, ";")
		for k, v in ipairs(str) do
			local str1 = string.split_ss_array(v, ",")
			if str1[3] ~= nil then
				local param = {}
				param.rewardType = tonumber(str1[2])
				param.itemId = str1[1]
				param.count = tonumber(str1[3])
				table.insert(result, param)
			end
		end
	end
	return result
end



function ActDrakeBossManager:CheckIfIsNew()
	local act = self:GetActivity()
	if act ~= nil then
		local info = self:GetActInfo()
		if info ~= nil then
			if info.rewardStatus == ChangeNameAndPicType.No then
				return true
			end
		end
	end
	return false
end

function ActDrakeBossManager:SetIsNew()
	EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

function ActDrakeBossManager:GetRedCount()
	if self:CheckIfIsNew() then
		return 1
	else
		local act = self:GetActivity()
		if act ~= nil then
			local info = self:GetActInfo()
			if info ~= nil then
				if info.rewardStatus == ChangeNameAndPicType.No and info.changeName == ChangeNameAndPicType.Yes and info.uploadPic == ChangeNameAndPicType.Yes then
					return 1
				end
			end
		end
	end
	return 0
end

--boss太远需要重新召唤
function ActDrakeBossManager:IsBossFar()
	if self.actInfo ~= nil then
		local vecPos = SceneUtils.IndexToTilePos(self.actInfo.pointId, ForceChangeScene.World)
		local myPos = SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World)
		if math.abs(vecPos.x - myPos.x) <= DrakeBossDistance and math.abs(vecPos.y - myPos.y) <= DrakeBossDistance then
			return false
		end
	end
	return true
end

--有道具，召唤并跳转，没有道具弹出却道具界面
function ActDrakeBossManager:UseItem()
	local useCount = self:GetPerUseItemCount()
	local itemId = self:GetItemId()
	local own = DataCenter.ItemData:GetItemCount(itemId)
	if own >= useCount then
		--召唤并跳转
		local item = DataCenter.ItemData:GetItemById(tostring(itemId))
		SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid, num = useCount, callBossUseType = CallBossUseType.CallBoss})
	else
		local lackTab = {}
		local param = {}
		param.type = ResLackType.Item
		param.id = itemId
		param.targetNum = useCount
		table.insert(lackTab,param)
		GoToResLack.GoToItemResLackList(lackTab)
	end
end

return ActDrakeBossManager