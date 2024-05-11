---
--- 通知设置
--- Created by shimin.
--- DateTime: 2020/9/22 15:29
---
local PushSettingData = BaseClass("PushSettingData")
local Localization = CS.GameEntry.Localization


local function __init(self)
	self.pushSettingList = {}	--推送信息
	self.pushInfoList = {}
end

local function __delete(self)
	self.pushSettingList = nil
	self.pushInfoList = nil
end

--初始化所有任务信息
local function InitData(self,message)
	if message["pushSetting"] ~= nil then
		self.pushSettingList = {}
		for k,v in pairs(message["pushSetting"]) do
			self:UpdateOnePushSettingInfo(v)
		end
	end

	if message["fb_push_unlock"] ~= nil then
		self.pushInfoList = {}
		for k,v in pairs(message["fb_push_unlock"]) do
			self:UpdateOnePushInfo(v)
		end
	end
	
end

--更新一个推送信息
local function UpdateOnePushSettingInfo(self,message)
	if message ~= nil and message["type"] ~= nil then
		local type = message["type"]
		local one = self:GetPushSettingInfoByType(type)
		if one == nil then
			one = PushSettingInfo.New()
			one:UpdateInfo(message)
			self.pushSettingList[type] = one
		else
			one:UpdateInfo(message)
		end
	end
end

--通过推送类型获取推送信息
local function GetPushSettingInfoByType(self,type)
	return self.pushSettingList[type]
end

--更新一个信息
local function UpdateOnePushInfo(self,message)
	if message ~= nil and message["id"] ~= nil then
		local id = message["id"]
		local one = self:GetPushInfoByType(id)
		if one == nil then
			one = PushSettingInfo.New()
			one:UpdateInfo(message)
			self.pushInfoList[id] = one
		else
			one:UpdateInfo(message)
		end
	end
end

--通过推送类型获取推送信息
local function GetPushInfoByType(self,id)
	return self.pushInfoList[id]
end

--是否开启推送
local function IsPushNotify(self,type)
	local temp = self:GetPushSettingInfoByType(type)
	if temp ~= nil and temp.status == SettingNoticeStatus.Off then
		return false
	end

	return true
end


local function CheckPushUnlock(self,id)
	local temp = self:GetPushInfoByType(id)
	if temp ~= nil and temp.unlock == SettingNoticeUnlock.UnLock then
		return true
	end

	return false
end

local function ParsePushSetHandle(self,message)
	if message["errorCode"] ~= nil then
		UIUtil.ShowTips(Localization:GetString(message["errorCode"]))
	else
		self:UpdateOnePushSettingInfo(message)
	end
end

local function PushSettingHandle(self,message)
	if message["pushSetting"] ~= nil then
		for k,v in pairs(message["pushSetting"]) do
			self:UpdateOnePushSettingInfo(v)
		end
	end
end


PushSettingData.__init = __init
PushSettingData.__delete = __delete
PushSettingData.InitData = InitData
PushSettingData.UpdateOnePushSettingInfo = UpdateOnePushSettingInfo
PushSettingData.GetPushSettingInfoByType = GetPushSettingInfoByType
PushSettingData.IsPushNotify = IsPushNotify
PushSettingData.GetPushInfoByType = GetPushInfoByType
PushSettingData.UpdateOnePushInfo = UpdateOnePushInfo
PushSettingData.CheckPushUnlock = CheckPushUnlock
PushSettingData.ParsePushSetHandle = ParsePushSetHandle
PushSettingData.PushSettingHandle = PushSettingHandle

return PushSettingData