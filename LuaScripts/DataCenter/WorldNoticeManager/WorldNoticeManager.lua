---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local WorldNoticeManager = BaseClass("WorldNoticeManager" ,Singleton)
local WorldNoticeDataInfo = require "DataCenter.WorldNoticeManager.WorldNoticeDataInfo"
local rapidjson = require "rapidjson"
local Localization = CS.GameEntry.Localization
-- 翻译地址
local TRANS_URL = "http://10.7.88.22:83/client.php"
local TRANS_CHANNEL	= "APS"
function WorldNoticeManager:__init()
	self.dataList = {}
	self.curUuid = 0
	self.title = {}
	self.version = ChatInterface.getVersionName()
	self.translatingList = {}
	
	TRANS_URL = "http://translate-ds.metapoint.club/client.php"

	local isMiddleEast = false; -- GlobalData::shared()->isMiddleEast();
	if isMiddleEast then
		TRANS_URL = "http://app1.im.medrickgames.com:8083/v3/client.php"
	end

end

function WorldNoticeManager:__delete()
	self.dataList = nil
	self.curUuid = nil
	self.title = {}
	self.translatingList = {}
end

--登陆时请求一下
function WorldNoticeManager:InitData()
	SFSNetwork.SendMessage(MsgDefines.GetNoticeList)
end

function WorldNoticeManager:ParseNoticeList(message)
	self.dataList = {}
	if message then
		if message["noticeList"] ~= nil then
			local list = message["noticeList"]
			for i = 1 ,table.count(list) do
				local tempData = WorldNoticeDataInfo.New()
				tempData:UpdateDataInfo(list[i])
				table.insert(self.dataList ,tempData)
			end
			self:SortNotice(self.dataList)
		end
	end
	EventManager:GetInstance():Broadcast(EventId.GetNoticeList)
end

--新公告推送
function WorldNoticeManager:NewNoticeHandle(message)
	if message then
		local data = message["notice"]
		local tempData = WorldNoticeDataInfo.New()
		tempData:UpdateDataInfo(data)
		if self.dataList then
			table.insert(self.dataList ,1,tempData)
		else
			self.dataList = {}
			table.insert(self.dataList ,tempData)
		end
		self:SortNotice(self.dataList)
        EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
	end
end

--删除公告推送
function WorldNoticeManager:DeleteNoticeHandle(message)
	if self.dataList then
		for i = 1 ,table.count(self.dataList) do
			if self.dataList[i].noticeId == message["noticeId"] then
				table.remove(self.dataList ,i)
				break
			end
		end
	end
    EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
end

function WorldNoticeManager:SortNotice(dataList)
	if dataList and next(dataList) then
		table.sort(dataList,function(a,b)
			if a.noticeId > b.noticeId then
				return true
			end
			return false
		end)
	end
end

--获取信息
function WorldNoticeManager:GetDataInfo()
	return self.dataList
end

--获取分类好的公告
function WorldNoticeManager:GetDataType()
	local data = self:GetDataInfo()
	local list = {}
	self.title = {}
	for i = 1 ,table.count(data) do
		--没有值的默认分类为1
		if data[i].showType ~= "" then
			local str = string.split(data[i].showType,";")
			if list[tonumber(str[2])] then
				table.insert(list[tonumber(str[2])],data[i])
			else
				list[tonumber(str[2])] = {}
				table.insert(list[tonumber(str[2])],data[i])
				self.title[tonumber(str[2])] = str[1]
			end
		else
			if list[1] then
				table.insert(list[1],data[i])
			else
				list[1] = {}
				table.insert(list[1],data[i])
			end
		end
	end
	return list
end
--获取类型对应描述
function WorldNoticeManager:GetTitleByType(type)
	if self.title[type] then
		return self.title[type]
	end
	return ""
end

function WorldNoticeManager:GetNoticeInfoById(uuid)
	if self.dataList then
		for i = 1 ,table.count(self.dataList) do
			if self.dataList[i].uuid == uuid then
				return self.dataList[i]
			end
		end
	end
	return nil
end

--{{{标记公告已读
--标记公告已读
function WorldNoticeManager:SendReadNotice(uuid)
	SFSNetwork.SendMessage(MsgDefines.ReadNotice ,uuid)
end

function WorldNoticeManager:SetCurId(uid)
	self.curUuid = uid
end

function WorldNoticeManager:GetCurId()
	return self.curUuid
end

--标记公告已读返回
function WorldNoticeManager:ReadNoticeHandle(message)
	if message then
		for i = 1 ,table.count(self.dataList) do
			if self.dataList[i].uuid == message["uuid"] then
				self.dataList[i].status = message["status"]
			end
		end
        EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
	end
end
--}}}

--{{{领取公告奖励
--领取公告奖励
function WorldNoticeManager:SendReceiveReward(uuid)
	SFSNetwork.SendMessage(MsgDefines.ReceiceNoticeReward ,uuid)
end

--领取公告奖励返回
function WorldNoticeManager:ReceiveRewardHandle(message)
	if message["reward"] ~= nil then
		DataCenter.RewardManager:ShowCommonReward(message)
		for k ,v in pairs(message["reward"]) do
			DataCenter.RewardManager:AddOneReward(v)
		end
	end
	for i = 1 ,table.count(self.dataList) do
		if self.dataList[i].uuid == message["uuid"] then
			self.dataList[i].rewardStatus = message["rewardStatus"]
		end
	end
    EventManager:GetInstance():Broadcast(EventId.RefreshNotice)
	EventManager:GetInstance():Broadcast(EventId.NoticeItemReward)
end
--}}}

function WorldNoticeManager:CheckShow()
	local data = self:GetDataInfo()
	if data then
		for i = 1 ,table.count(data) do
			if data[i].status == 0 or data[i].rewardStatus == 0 then
				return true
			end
		end
	end
	return false
end

function WorldNoticeManager:CheckNotice()
	local data = self:GetDataInfo()
	if data then
		if table.count(data) > 0 then
			return true
		end
	end
	return false
end

--{{{公告翻译
function WorldNoticeManager:TranslateNotice(origInfo)
	if not origInfo then
		return false
	end
	local oriLang = ""
	local targetLang = Localization:GetLanguageName()
	local strMsg = origInfo:GetMailMessage()
	local urlParams = self:MakePostParam(oriLang, targetLang, strMsg)
	table.insert(self.translatingList, origInfo)

	CS.ChatService.Instance:RequestTranslate(TRANS_URL, urlParams,
			function (ok, text)
				table.removebyvalue(self.translatingList, origInfo)
				self:onTranslateCallback(origInfo, ok, text)
			end)
	return true
end

function WorldNoticeManager:GetLangString(str)
	if not str then
		str = ""
	end
	if str == "zh-CN" or str == "zh_CN" or str == "zh-Hans" or str == "zh-CHS" or str == "cn" then
		return "zh-Hans"
	elseif str == "zh-TW" or str == "zh_TW" or str == "zh-Hant" or str == "zh-CHT" or str == "tw" then
		return "zh-Hant"
	end
	return str
end

-- 制作post参数，老规矩
function WorldNoticeManager:MakePostParam(srcLang, targetLang, content)
	local tarL = self:GetLangString(targetLang)

	local oriL = srcLang -- "auto"--self:GetLangString(originLang);
	local pUid = LuaEntry.Player.uid
	local sid = LuaEntry.Player.serverId
	local ui = pUid .. "," .. sid .. "," .. self.version
	local translateKey = LuaEntry.Player.translateKey-- ChatInterface.getTranslateKey()

	-- 聊天频道
	local channel = TRANS_CHANNEL

	-- 这里的sig计算等放到了C#
	local t = {}
	t["sc"] = tostring(content)
	t["sf"] = tostring(oriL)
	t["tf"] = tostring(tarL)
	t["ch"] = tostring(channel)
	t["ui"] = tostring(ui)
	t["scene"] = tostring(channel)
	t["uid"] = tostring(pUid)
	t["tk"] = tostring(translateKey)

	return t

end

function WorldNoticeManager:onTranslateCallback(origInfo, ok, responseString)
	local ret = false
	if not string.IsNullOrEmpty(responseString) then
		local data = rapidjson.decode(responseString)
		if not data or data.code ~= 0 then
		else
			origInfo.translateMsg = data.translateMsg
			origInfo.translatedLang = data.targetLang
			ret = true
		end
	end

	-- db操作
	if ret == true then
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTranslatedNotice, origInfo)
	end
end
--}}}

return WorldNoticeManager
