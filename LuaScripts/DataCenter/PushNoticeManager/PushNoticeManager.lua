
local Localization = CS.GameEntry.Localization
local PushData = require "DataCenter.PushNoticeManager.PushData"
local PushNoticeManager = BaseClass("PushNoticeManager")
--推送通知管理器，当需要推送手机通知时调用

-- 这个地方后续会添加一些业务逻辑代码,比如设置界面关闭该类型的推送,或者需要自己组织语言的这种
function PushNoticeManager:PushNotice(pushId, noticeTime,value)
	local pushItem = LocalController:instance():getLine(TableName.APS_PUSH,pushId)
	if pushItem == nil then
		return
	end
	local pushData = PushData.New()
	local push_type = pushItem:getValue("push_type") or ""
	local pushBody = pushItem:getValue("dialogId") or ""
	local param_count = toInt(pushItem:getValue("param_count"))
	if param_count<=0 or value == nil then
		pushBody = Localization:GetString(pushBody)
	else
		pushBody = Localization:GetString(pushBody,table.unpack(value))
	end
	
	local push_tag = pushItem:getValue("tag") or ""
	if push_type == "" then
		return
	end
	pushData:SetData(pushId, toInt(noticeTime), pushBody, push_tag, push_type)
	DataCenter.PushUtil:pushNotice(pushData)
end

function PushNoticeManager:CancelPushNotice(pushId)
	local pushItem = LocalController:instance():getLine(TableName.APS_PUSH,pushId)
	if pushItem == nil then
		return
	end
	local pushData = PushData.New()
	local push_type = pushItem:getValue("push_type") or ""
	if push_type == "" then
		return
	end
	pushData:SetData(pushId,0,"", "", push_type)
	DataCenter.PushUtil:CanclePush(pushData)
end
function PushNoticeManager:PushRegisterSecondDay()
	--登陆游戏判断注册时间
	--local registerTime = LuaEntry.Player.regTime * 0.001
	local now = UITimeManager:GetInstance():GetServerSeconds()
	--if now - registerTime >= 48*OneHourTime then
	--	return
	--end
	local isFinish = Setting:GetInt(LuaEntry.Player.uid ..LuaEntry.Player.pushMark.. "PLAYER_CALLBACK_TIME_Finish",0)
	if isFinish>0 then
		return
	end
	local lastSendTime = Setting:GetInt(LuaEntry.Player.uid ..LuaEntry.Player.pushMark.. "PLAYER_CALLBACK_TIME",now)
	--if state == 1 then
	--    return
	--end
	local timeTab = os.date("*t")
	local todayZero = now - timeTab.hour * OneHourTime - timeTab.min * 60
	local minDeltaTime = 0
	local playerMark = {}
	for i = 1, 4 do
		local idArr = PushRegisterSecondDay[i]
		for a = 1,#idArr do
			local param = {}
			local realId = idArr[a]
			param.mark = GetTableData(TableName.APS_PUSH,realId, 'player_mark')
			param.id = realId
			param.push_type = GetTableData(TableName.APS_PUSH,realId, 'push_type')
			param.time = GetTableData(TableName.APS_PUSH,realId, 'type_value')
			if tonumber(param.mark) == LuaEntry.Player.pushMark then
				local deltaTime = tonumber(param.time)* OneHourTime
				local push_time = GetTableData(TableName.APS_PUSH,realId, 'push_time')
				local targetStr = string.split(push_time,":")
				if #targetStr>=2 then
					local hour = tonumber(targetStr[1])
					local minute = tonumber(targetStr[2])
					local targetTimeDelta = hour * OneHourTime + minute * 60
					local afterTime = todayZero+targetTimeDelta-now
					if afterTime<deltaTime then
						afterTime = afterTime+OneDayTime
					end
					param.sendTime = afterTime
					if minDeltaTime>0 then
						if afterTime<minDeltaTime then
							minDeltaTime = afterTime
						end
					else
						minDeltaTime = afterTime
					end
					table.insert(playerMark,param)
				end
			end
		end
	end
	local continueTime = now-lastSendTime
	local isCancel = false--(continueTime>0)
	for i = 1, #playerMark do
		if isCancel then
			local data = playerMark[i]
			local pushData = PushData.New()
			pushData:SetData(data.id, data.sendTime,"", "", data.push_type)
			DataCenter.PushUtil:CanclePush(pushData)
		else
			local targetTime = tonumber(playerMark[i].sendTime)
			DataCenter.PushNoticeManager:PushNotice(tonumber(playerMark[i].id), targetTime)
		end
	end
	if isCancel then
		Setting:SetInt(LuaEntry.Player.uid ..LuaEntry.Player.pushMark.. "PLAYER_CALLBACK_TIME_Finish",1)
	else
		local sendTime = minDeltaTime+now
		Setting:SetInt(LuaEntry.Player.uid ..LuaEntry.Player.pushMark.. "PLAYER_CALLBACK_TIME",sendTime)
		
	end
end

function PushNoticeManager:CheckPushStaminaFull(endTime)
	if endTime>0 then
		DataCenter.PushNoticeManager:PushNotice(PushStaminaFull, endTime)
	end
end
function PushNoticeManager:CheckTrainArmyFinish(endTime,value)
	if endTime>0 then
		DataCenter.PushNoticeManager:PushNotice(PushTrainArmyFinish, endTime,value)
	else
		DataCenter.PushNoticeManager:CancelPushNotice(PushTrainArmyFinish)
	end
end
function PushNoticeManager:CheckPlayerBuildingFinish(endTime,value)
	if endTime>0 then
		DataCenter.PushNoticeManager:PushNotice(PushPlayerBuildFinish, endTime,value)
	else
		DataCenter.PushNoticeManager:CancelPushNotice(PushPlayerBuildFinish)
	end
end
function PushNoticeManager:CheckPlayerScienceFinish(endTime,value)
	if endTime>0 then
		DataCenter.PushNoticeManager:PushNotice(PushScienceFinish, endTime,value)
	else
		DataCenter.PushNoticeManager:CancelPushNotice(PushScienceFinish)
	end
end

return PushNoticeManager