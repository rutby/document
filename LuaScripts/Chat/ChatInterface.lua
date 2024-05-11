--[[
	这个类封装了游戏相关的接口

	写这个类的主要目的是提高聊天相关类的内聚性，低耦合，
	外部属性和方法都统一从这里调用，这样修改的时候也统一修改这个类就行了
]]

local Localization = CS.GameEntry.Localization

local ChatInterface = {}

-- 获取聊天的管理器
function ChatInterface.getRoomMgr()
	return ChatManager2:GetInstance().Room
end




-- 获取房间信息
function ChatInterface.getRoomData(roomId)
	return ChatManager2:GetInstance().Room:GetRoomData(roomId)
end

function ChatInterface.getCountryRoomId()
	return ChatManager2:GetInstance().Room:GetCountryRoomId()
end

function ChatInterface.getAllianceRoomId()
	return ChatManager2:GetInstance().Room:GetAllianceRoomId()
end

function ChatInterface:getCrossServerRoomId()
	return ChatManager2:GetInstance().Room:GetCrossServerRoomId()
end
-- 获取聊天的管理器
function ChatInterface.getUserMgr()
	return ChatManager2:GetInstance().User
end

-- 获取用户信息
function ChatInterface.getUserData(uid)
	return ChatManager2:GetInstance().User:getChatUserInfo(uid)
end

-- 获取翻译管理器
function ChatInterface.getTranslateMgr()
	return ChatManager2:GetInstance().Translate
end

--是否是debug模式
function ChatInterface.isDebug()
	return CS.CommonUtils.IsDebug()
	--return true
end

---获取玩家信息
function ChatInterface.getPlayer()
	return LuaEntry.Player
end

function ChatInterface.getPlayerServerId()
	return LuaEntry.Player.serverId
end

function ChatInterface.getSelfServerId()
	return ChatInterface.getPlayer():GetSelfServerId()
end
function ChatInterface.getSrcServerId()
	return ChatInterface.getPlayer():GetSrcServerId()
end
---获取联盟id--
function ChatInterface.getAllianceId()
	return ChatInterface.getPlayer().allianceId
end
function ChatInterface.getAllianceAbbr()
	local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
	if data~=nil then
		return data.abbr
	end
	
	return nil
end
--是否再联盟--
function ChatInterface.isInAlliance()
	return ChatInterface.getPlayer():IsInAlliance()
end
function ChatInterface.isDragonServerOpen()
	return LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER
end
function ChatInterface.isCrossServerOpen()
	local chatOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_dule_crosschat")
	if not chatOpenState then
		return false
	end
	local configOpenState = LuaEntry.DataConfig:CheckSwitch("alliance_duel")
	if not configOpenState then
		return false
	end
	
	local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
	local isInMatch = DataCenter.LeagueMatchManager:CheckIfInMatch()
	if tempStage ~= LeagueMatchStage.None then
		if isInMatch then
			if not LuaEntry.Player:IsInAlliance() then
				return false
			end
			local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
			if duelInfo and not string.IsNullOrEmpty(duelInfo.group) then
				return true
			else
				return false
			end
		else
			return false
		end
	else
		local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
		if not activityInfo then
			return false
		end
		local mainBuildLV = DataCenter.BuildManager.MainLv
		if activityInfo.needMainCityLevel > mainBuildLV then
			return false
		end
		local matchGroupId = activityInfo.matchGroupId
		if matchGroupId==nil or matchGroupId =="" then
			return false
		end
		return true
	end

end 
function ChatInterface.getCrossServerIdFlag()
	local tempStage = DataCenter.LeagueMatchManager:GetLeagueMatchStage()
	if tempStage ~= LeagueMatchStage.None then
		local duelInfo = DataCenter.LeagueMatchManager:GetMyCurDuelInfo()
		if duelInfo and not string.IsNullOrEmpty(duelInfo.group) then
			return duelInfo.group
		end
	else
		local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
		if activityInfo~=nil then
			local matchGroupId = activityInfo.matchGroupId
			if matchGroupId~=nil and matchGroupId~="" then
				return matchGroupId
			end
		end
	end
	return ""
end

--语言频道开关
function ChatInterface.isLangOpen()
	local chatOpenState = LuaEntry.DataConfig:CheckSwitch("Local_language_channel")
	return chatOpenState
end

function ChatInterface.getPlayerUid()
	return ChatInterface.getPlayer().uid
end

function ChatInterface.getPlayerName()
	return ChatInterface.getPlayer().name
end

function ChatInterface.getLastUpdateTime()
	return toInt(ChatInterface.getPlayer().lastUpdateTime)
end

---获取版本号---
function ChatInterface.getVersionName()
	-- return CS.LF.LuaInterfaceCommon.GetVersionName()
	return "1.250.001"
end

---获取枚举---
function ChatInterface.getEventEnum()
	--return EventId
	return ChatEventEnum
end

---获取服务器时间 单位 秒---
function ChatInterface.getServerTime()
	return math.floor(UITimeManager:GetInstance():GetServerTime() / 1000)
end

--检测开关--
function ChatInterface.checkIsOpenByKey(key)
	return LuaEntry.DataConfig:CheckSwitch(key)
end

function ChatInterface.getLanguageName()
	local lang = Localization.Language
	local LanguageType = CS.GameFramework.Localization.Language
	if lang == LanguageType.ChineseSimplified then
		return "zh_CN";
	end
	if lang == LanguageType.ChineseTraditional then
		return "zh_TW";
	end
	if lang == LanguageType.English then
		return "en";
	end
	if lang == LanguageType.PortuguesePortugal then
		return "pt";
	end
	if lang == LanguageType.Turkish then
		return "tr";
	end
	if lang == LanguageType.French then
		return "fr";
	end
	if lang == LanguageType.Norwegian then
		return "no";
	end
	if lang == LanguageType.Korean then
		return "ko";
	end
	if lang == LanguageType.Japanese then
		return "ja";
	end
	if lang == LanguageType.Dutch then
		return "nl";
	end
	if lang == LanguageType.Italian then
		return "it";
	end
	if lang == LanguageType.German then
		return "de";
	end
	if lang == LanguageType.Spanish then
		return "es";
	end
	if lang == LanguageType.Russian then
		return "ru";
	end
	if lang == LanguageType.Arabic then
		return "ar";
	end
	if lang == LanguageType.Persian then
		return "pr";
	end
	return Localization:GetLanguageName()
end

function ChatInterface.getString(langId,...)
	return Localization:GetString(langId, ...)
end

--显示提示框---
function ChatInterface.flyHint(msg)
	UIUtil.ShowTips(msg)
end


	---获取聊天开关
	-- function ChatInterface.getSwitchFlagDic()
	-- 	local flagTbl = LuaChatGlobalData:getInstance():getSwitchFlagTable()
	-- 	return 	flagTbl
	-- end

function ChatInterface.getWritablePath()
	return device.writablePath
end

function ChatInterface.getCustomPicUrl(uid,picVer)
	local isok,url,key = CS.CommonUtils.GetCustomPicUrl(uid,picVer,url,key)
	return url
end


function ChatInterface.httpPostData(url,param)
	CS.LuaChatHelper.HttpPostData(url,param)
end

function ChatInterface.getHttpResponseString()
	return CS.LuaChatHelper.GetResponseString()
end

function ChatInterface.getTranslateKey()
	return ChatInterface.getPlayer().translateKey
end

--是否是外网调试
function ChatInterface.isExternalNetDebug()
	return false
end

function ChatInterface.isChina()
	return CS.LF.LuaInterfaceCommon.IsChinaRegion()
end

function ChatInterface.refreshMainUILastChat()
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().LF_UPDATE_UIMAIN_CHAT_MSG)
end

function ChatInterface.getRoomName(roomId)
	local roomData = ChatManager2:GetInstance().Room:GetRoomData(roomId)
	if roomData then
		return roomData:getRoomName()
	end
	
	return ""
end

function ChatInterface.isChatGM(playerUid)
	if (string.len(playerUid) == 5) then
		local i = toInt(playerUid)
		if i>= 10000 and i<= 10020 then
			return true
		end
	end
	return false
end

function ChatInterface.ChatShareMsg(roomId,dialogId,dialogParamNum,unUseDialogParamList,useDialogParamList)
	local chat_data = {}
	chat_data.roomId = roomId
	chat_data.post = PostType.Text_MsgShare
	local chat_param = {}
	chat_param.dialogId = dialogId
	chat_param.dialogParamNum = dialogParamNum
	chat_param.unUseDialogParamList =unUseDialogParamList
	chat_param.useDialogParamList =useDialogParamList
	chat_data.param = chat_param
	EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, chat_data)
end 
return ChatInterface

