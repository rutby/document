--- Created by shimin.
--- DateTime: 2023/10/9 17:41
--- 改头换面活动管理器

local ChangeNameAndPicManager = BaseClass("ChangeNameAndPicManager")
local ChangeNameAndPicInfo = require "DataCenter.ActivityListData.ChangeNameAndPic.ChangeNameAndPicInfo"

function ChangeNameAndPicManager:__init()
	self:AddListener()
	self.actInfo = ChangeNameAndPicInfo.New()
	self.canShowRed = true
end

function ChangeNameAndPicManager:__delete()
	self:RemoveListener()
	self.canShowRed = true
end

function ChangeNameAndPicManager:Startup()
end

function ChangeNameAndPicManager:AddListener()
	
end

function ChangeNameAndPicManager:RemoveListener()
	
end

--获取活动数据
function ChangeNameAndPicManager:GetActInfo()
	return self.actInfo
end

--发送获取上传头像活动信息
function ChangeNameAndPicManager:SendGetUploadPicActivityInfo(activityId)
	SFSNetwork.SendMessage(MsgDefines.GetUploadPicActivityInfo, {activityId = activityId})
end

--发送获取上传头像活动信息(活动开启才发)
function ChangeNameAndPicManager:CheckSendGetUploadPicActivityInfo()
	local act = DataCenter.ChangeNameAndPicManager:GetActivity()
	if act ~= nil then
		DataCenter.ChangeNameAndPicManager:SendGetUploadPicActivityInfo(tonumber(act.id))
	end
end

--处理获取上传头像活动信息
function ChangeNameAndPicManager:GetUploadPicActivityInfoHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		UIUtil.ShowTipsId(errorCode)
	else
		self.actInfo:ParseInfo(message)
		EventManager:GetInstance():Broadcast(EventId.RefreshChangeNameAndPic)
		EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
	end
end

--发送领取上传头像活动奖励
function ChangeNameAndPicManager:SendReceiveUploadPicActivityReward()
	local info = self:GetActivity()
	if info ~= nil then
		SFSNetwork.SendMessage(MsgDefines.ReceiveUploadPicActivityReward, {activityId = info.id})
	end
end

--处理领取上传头像活动奖励
function ChangeNameAndPicManager:ReceiveUploadPicActivityRewardHandle(message)
	local errorCode = message["errorCode"]
	if errorCode ~= nil then
		UIUtil.ShowTipsId(errorCode)
	else
		self.actInfo:ParseInfo(message)
		local reward = message["reward"]
		if reward ~= nil then
			for k,v in pairs(message["reward"]) do
				DataCenter.RewardManager:AddOneReward(v)
			end
			DataCenter.RewardManager:ShowCommonReward(message)
		end
		EventManager:GetInstance():Broadcast(EventId.RefreshChangeNameAndPic)
		EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
	end
end

--获取活动中的改头换面活动数据
function ChangeNameAndPicManager:GetActivity()
	local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ChangeNameAndPic)
	if dataList ~= nil then
		return dataList[1]
	end
	return nil
end

function ChangeNameAndPicManager:CheckIfIsNew()
	if self.canShowRed then
		local act = self:GetActivity()
		if act ~= nil then
			local info = self:GetActInfo()
			if info ~= nil then
				if info.rewardStatus == ChangeNameAndPicType.No then
					return true
				end
			end
		end
	end
	return false
end

function ChangeNameAndPicManager:SetIsNew()
	self.canShowRed = false
	EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

function ChangeNameAndPicManager:GetRedCount()
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


return ChangeNameAndPicManager