
-- 游戏主角信息

local PlayerInfo = BaseClass("PlayerInfo")
local Setting = CS.GameEntry.Setting
local SettingKeys = CS.GameDefines.SettingKeys
local AccountListManager = require "DataCenter.AccountData.AccountListManager"
local AccountInfo = require "DataCenter.AccountData.AccountInfo"

function PlayerInfo:__init()
	
	self:__reset()


end

function PlayerInfo:__reset()
	-- 服务器信息
	self.serverMax = 0 -- 最大服务器id
	self.serverId = -1 -- 账号所在的服务器id
	self.serverType = 0
	self.srcServerType = 0
	self.crossFightSrcServerId = -1 --跨服战时的原服id，若为-1表示没有跨服
	self.checkServerId = -1 -- 目前跨服查看的服务器id
	self.checkWorldId = 0
	self.srcWorldId = 0
	-- 客户端设备id及uuid；理论存储到全局数据
	self.deviceId = ""
	self.uuid = ""

	-- 基本信息
	self.uid = ""
	self.name = ""
	self.level = 0
	self.careerType = CareerType.None
	self.careerLv = 0
	self.exp = 0
	self.abTest = ""
	self.gmFlag = 0
	self.isFirstJoin = 0
	self.allianceId = ""
	self.alsignrewardlog = "" -- 联盟领奖

	self.pic = ""
	self.picVer = 0
	self.picUploading = false
	self.lastUpdateTime = 0 -- 单位秒; 这个服务器发的是一个字符串，比较的时候记得toInt
	self.nickName = ""
	self.renameTime = 0
	
	self.lastFreeAlMoveTime = 0

	-- 注册信息
	self.country = ""	-- 国家
	self.countryFlag = ""
	self.regCountry = ""	-- 注册国家
	self.regTime = 0
	self.inviCode = ""
	self.analyticID = ""
	self.pushMark = 0

	-- 付费信息
	self.gold = 0
	self.paidGoid = 0
	self.sm_addGoldCount = 0

	self.payTotal = 0
	self.payDollerTotal = 0		-- 用户付费信息，用来标志是否为大R

	-- 开服时间（单位毫秒）
	self.openServerTime = 0


	-- 战力数据
	self.lastPower = 0
	self.power = 0

	self.heroPower = 0
	self.sciencePower = 0
	self.buildingPower = 0
	self.armyPower = 0
	self.playerPower = 0

	self.armyDead = 0
	self.armyKill = 0
	self.armyCure = 0

	self.battleLose = 0
	self.battleWin = 0

	-- gm礼包每月配额
	self.gmGold = 0
	self.gmGoldLimit = 0

	-- 保护数据
	self.ProtectTimeStamp = 0         -- 基地保护时间
	self.ResourceProtectTimeStamp = 0 -- 资源保护时间
	self.CooldownTime = ""             -- 冷却时间
	self.ProtectCoolDownTime = ""      -- 保护罩冷却时间

	-- VIP信息
	self.vipActivePoint = 0
	self.isVipStoreUnlock = false
	self.vipframe = 0
	self.SVIPLevel = 0

	-- pin码
	self.pinPwdStatus = 0 -- 0:未设置pin码  1:已设置pin码
	self.pinPwdCheckFrequency = 0
	self.pinPwdChange = 0

	-- 其他用户数据
	self.serverName = ""
	self.nextDay = 0 -- 明天00：00的时间戳，毫秒
	self.moodStr = 0 -- 心情
	self.ptGold = 0 -- 平台币，代币（目前只有mycard)
	self.pveLevel = 0  -- 表示打败过的最大等级怪
	self.firstModfiyPic = false
	self.modfiyPicStatus = false
	self.payMonthlyDollarTotal = 0
	self.alGiftHideName = ""

	-- 其他全局数据
	self.bindFlag = false
	self.newAccount = false
	self.translateKey = "" -- 翻译密钥
	self.curNotifyUserInfoIndex = 0
	self.agreeUserAgreementFlag = 0 -- 用户条款同意

	self.stamina =0 --耐力值
	self.lastStaminaTime =0 --恢复耐力时间
	self.playerStaminaGoldTime = 0 --玩家上次购买体力时间
	self.playerStaminaGoldNum = 0 --玩家购买体力次数

	self.tempStaminaValue = 0 --缓存的体力（一秒内不变）
	self.staminaValue = 0 --缓存的体力（一秒内不变）

	self.pveStamina =0 --pve体力
	self.lastPveStaminaTime =0 --pve体力上次恢复时间，单位毫秒
	self.pveFakeStamina = 0--PVE客户端减少的体力
	
	self.fold_cross_worm_hole_time = 0 --跨服虫洞收起时间
	self.fold_sub_worm_hole_time = 0 --原服虫洞收起时间
	self.world_main_pos = -1 -- -1代表没去过世界并且未落大本；0 代表去过世界未落大本
	self.sex = SexType.None--性别
	self.changeSexCount = 0--改了几次性别
	self.changeSexRecord = {}--没个性别改了几次 dict
	
	self.extraDesertNum = 0 --额外地块上线

	self.nitrogen = 0
	self.lastNitrogenTime = 0
	self.edenEnterCoolDownTime = 0
	self.edenMoveTime = 0
	self.edenStatus = 1
end

function PlayerInfo:InitFromNet(obj)
	
	if obj["user"] then
		self:UpdateUser(obj["user"])
	end
	
	if obj["playerInfo"] then
		self:UpdatePlayerInfo(obj["playerInfo"])
	end

	if obj["lastFreeMoveTime"] then
		self.lastFreeAlMoveTime = obj["lastFreeMoveTime"]
	end
	if obj["eden_enter_cool_down"]~=nil then
		self:UpdateEdenMvCoolDownTime(obj["eden_enter_cool_down"])
	end
	if obj["playerStamina"]~=nil then
		self:SetStaminaGoldTime(obj["playerStamina"])
	end
	if obj["eden_enter_cool_down"]~=nil then
		self:SetEdenCoolDownTime(obj["eden_enter_cool_down"])
	end
	self:SetFoldCrossWormHoleTime(obj)
	self:SetFoldSubWormHoleTime(obj)
	self:UpdateVIPInfo(obj)
	self:UpdateOtherInfo(obj)
	self:UpdateCrossObj(obj)

	-- 有些数据要写入文件
	Setting:SetString(SettingKeys.DEVICE_UID, self.deviceId)
	Setting:SetString(SettingKeys.UUID, self.uuid)
	Setting:SetInt(SettingKeys.GM_FLAG, self.gmFlag)
	
	--local mt = getmetatable(self)
	--if mt then
		--mt.__newindex =
		--function(t,k,v)
			--print("==set: " .. tostring(k) .. " : " .. tostring(v))
		--end
	--end
	
end

-- 处理其他数据
function PlayerInfo:UpdateOtherInfo(obj)

	-- 新账号
	if obj["newAccount"] then
		self.newAccount = obj["newAccount"]
	end

	-- 王国贡献
	if obj["kingdom_contribution"] then
		self.kingdomContribution = obj["kingdom_contribution"]
	end
	
end

-- 更新VIP用户信息
function PlayerInfo:UpdateVIPInfo(obj)
	
	if obj["vipstoreLevel"] then
		self.vipstoreLevel = obj["vipstoreLevel"]
	end
	
	if obj["vipstorestate"] then
		self.vipstorestate = obj["vipstorestate"]
	end
	
	if obj["activepoint"] then
		self.vipActivePoint = obj["activepoint"]
	end

	return
end

-- 战力转换
function PlayerInfo:UpdatePowerData(playerInfo)
	-- 战力数据转换
	self.lastPower = self.power

	if playerInfo["heroPower"] then
		self.heroPower = playerInfo["heroPower"]
	end
	
	if playerInfo["sciencePower"] then
		self.sciencePower = playerInfo["sciencePower"]
	end
	
	if playerInfo["buildingPower"] then
		self.buildingPower = playerInfo["buildingPower"]
	end
	
	if playerInfo["armyPower"] then
		self.armyPower = playerInfo["armyPower"]
	end
	-- FIXME: 怎么还有大小写两种
	if playerInfo["ArmyPower"] then
		self.armyPower = playerInfo["ArmyPower"]
	end
	if playerInfo["HeroPower"] then
		self.heroPower = playerInfo["HeroPower"]
	end
	if playerInfo["SciencePower"] then
		self.sciencePower = playerInfo["SciencePower"]
	end
	if playerInfo["PlayerPower"] then
		self.playerPower = playerInfo["PlayerPower"]
	end
	if playerInfo["playerPower"] then
		self.playerPower = playerInfo["playerPower"]
	end

	if playerInfo["armyDead"] then
		self.armyDead = playerInfo["armyDead"]
	end
	
	if playerInfo["armyKill"] then
		self.armyKill = playerInfo["armyKill"]
	end
	
	if playerInfo["armyCure"] then
		self.armyCure = playerInfo["armyCure"]
	end

	if playerInfo["battleLose"] then
		self.battleLose = playerInfo["battleLose"] 
	end
	
	if playerInfo["battleWin"] then
		self.battleWin = playerInfo["battleWin"]
	end

	if playerInfo["firstModfiyPic"] then
		self.firstModfiyPic = playerInfo["firstModfiyPic"] == 1
	end
	
	if playerInfo["modfiyPicStatus"] then
		self.modfiyPicStatus = playerInfo["modfiyPicStatus"] == 1
	end

	self.power = self.heroPower + 
				self.sciencePower + 
				self.buildingPower + 
				self.armyPower + 
				self.playerPower

	if self.lastPower ~= 0 and self.lastPower ~= self.power then
		EventManager:GetInstance():Broadcast(EventId.PlayerPowerInfoUpdated)
	end
	self:SetStaminaData(playerInfo)
	self:SetPveStaminaData(playerInfo)
	self:SetPlayerNitrogen(playerInfo)
end

-- 解析角色相关的数据
function PlayerInfo:UpdatePlayerInfo(playerInfo)

	-- 战力数据
	self:UpdatePowerData(playerInfo)
	
	-- 其他数据
	if playerInfo["serverName"] then
		self.serverName = playerInfo["serverName"]
	end
	
	if playerInfo["nextDay"] then
		self.nextDay = playerInfo["nextDay"]
	end
	
	if playerInfo["moodStr"] then
		self.moodStr = playerInfo["moodStr"]
	end
	
	if playerInfo["ptGold"] then
		self.ptGold = playerInfo["ptGold"]
	end
	
	if playerInfo["pveLevel"] then
		self.pveLevel = playerInfo["pveLevel"]
	end
	
	-- gm礼包每月配额
	if playerInfo["gmGold"] then
		self.gmGold = playerInfo["gmGold"]
	end
	
	if playerInfo["gmGoldLimit"] then
		self.gmGoldLimit = playerInfo["gmGoldLimit"]
	end
	
	-- 用户条款
	if playerInfo["agreeUserAgreementFlag"] then
		self.agreeUserAgreementFlag = playerInfo["agreeUserAgreementFlag"]
	end
end

function PlayerInfo:UpdateSendCustomHead(message)
	if message["modfiyPicStatus"] ~= nil  then
		self.modfiyPicStatus = message["modfiyPicStatus"] == 1
	end
end

-- 解析用户核心数据
-- 因为user有可能不是全量更新，所以这里需要判断每一个域
function PlayerInfo:UpdateUser(user)

	-- 服务器信息
	if user["serverMax"] then
		self.serverMax = user["serverMax"]
	end
	
	if user["serverId"] then
		self.serverId = user["serverId"]
	end
	if user["worldId"] then
		self.srcWorldId = user["worldId"]
		self:SetWorldId(self.srcWorldId)
	end
	
	if user["serverType"] then
		self.serverType = user["serverType"]
		self.srcServerType = user["serverType"]
	end
	
	if user["crossFightSrcServerId"] then
		self.crossFightSrcServerId = user["crossFightSrcServerId"]
	end
	
	-- 客户端设备id及uuid
	if user["deviceId"] then
		self.deviceId = user["deviceId"]
	end
	
	if user["uuid"] then
		self.uuid = user["uuid"]
	end

	-- 基本信息
	if user["uid"] then
		self.uid = user["uid"]
	end

	if user["srcIsCnServer"] then
		self.srcIsCnServer = user["srcIsCnServer"]
	end

	if user["name"] then
		self.name = user["name"]
	end
	
	if user["level"] then
		self.level = user["level"]
	end

	if user["careerType"] then
		self.careerType = user["careerType"]
	end

	if user["careerLv"] then
		self.careerLv = user["careerLv"]
	end
	
	if user["exp"] then
		self.exp = user["exp"]
	end
	if user["pic"] then
		self.pic = user["pic"]
	end
	
	if user["picVer"] then
		self.picVer = user["picVer"]
	end
	
	
	if user["abTest"] then
		self.abTest = user["abTest"]
		if self.abTest == ABTestType.B then
			Logger.Log("<color=#F100BC>GetABTestType  B  </color>")
		else
			Logger.Log("<color=#F100BC>GetABTestType  A  </color>")
		end
	end
	
	if user["gmFlag"] then
		self.gmFlag = user["gmFlag"]
	end
	
	if user["isfirstJoin"] then
		self.isFirstJoin = user["isfirstJoin"]
	end
	
	if user["allianceId"] then
		self.allianceId = user["allianceId"]
	end
	
	if user["alsignrewardlog"] then
		self.alsignrewardlog = user["alsignrewardlog"]
	end
	
	if user["lastUpdateTime"] then
		self.lastUpdateTime = toInt(user["lastUpdateTime"]) -- 单位秒
	end
	
	if user["nickName"] then
		self.nickName = user["nickName"]
	end
	
	if user["chNameCount"] then
		self.renameTime = user["chNameCount"]
	end
	
	-- 注册信息
	if user["country"] then
		self.country = user["country"]
	end
	
	if user["countryflag"] then
		self.countryFlag = user["countryflag"]
	end
	
	if user["regCountry"] then
		self.regCountry = user["regCountry"]
	end
	
	if user["regTime"] then
		self.regTime = user["regTime"]
	end
	
	
	if user["inviCode"] then
		self.inviCode = user["inviCode"]
	end
	
	self.analyticID = ""
	
	-- 付费信息
	local sm_gold = self.gold
	if user["gold"] then
		self.gold = user["gold"]
	end
	
	if user["paidGold"] then
		self.paidGoid = user["paidGold"]
	end
	
	self.sm_addGoldCount = self.gold - sm_gold
	
	if user["payTotal"] then
		self.payTotal = user["payTotal"]
	end
	
	if user["payDollerTotal"] then
		self.payDollerTotal = user["payDollerTotal"]
	end
	
	-- 其他信息（未归类）
	-- 开服时间（单位毫秒）
	if user["openServerTime"] then
		self.openServerTime = user["openServerTime"]
	end

	if user["pushMark"] then
		self.pushMark = user["pushMark"]
	end
	
	self:SetSexData(user)
	-- 解析账号信息
	self:ProcessAccount(user)
	-- 保存账号信息
	self:SaveThisAccount()
	-- 向facebook打点
	self:LogToFacebook();
end

function PlayerInfo:LogToFacebook()
	local time = UITimeManager:GetInstance():GetServerTime()
	local diff = UITimeManager:GetInstance():GetBetweenDaysForLocal(self.regTime/1000, time/1000)
	local login_times = Setting:GetInt(SettingKeys.LOGIN_SECOND_DAYS, 0)
	if (login_times == 0) then
		if (diff == 1) then
			-- send
			CS.GameEntry.Sdk:LogEvent("secondLogin", self.uid)
			Setting:SetInt(SettingKeys.LOGIN_SECOND_DAYS, 1)
		end
	end
end

function PlayerInfo:GetRegDeltaTime()
	local time = UITimeManager:GetInstance():GetServerTime()
	local diff = UITimeManager:GetInstance():GetBetweenDaysForServer(self.regTime/1000, time/1000)
	return diff
end

function PlayerInfo:GetAllianceChatCount()
	local count = Setting:GetPrivateInt("alliance_chat_num", 0)
	return count
end

function PlayerInfo:SetAllianceChatCount(num)
	Setting:SetPrivateInt("alliance_chat_num",num)
end

-- 处理账户相关的数据
function PlayerInfo:ProcessAccount(user)
	
	if user["bindFlag"] then
		self.bindFlag = user["bindFlag"]
	end
	
	--账号绑定
	local _gp = ""
	if (user["googlePlay"]) then
		self._gp = user["googlePlay"]
	end

	if (user["appStoreId"]) then
		self._gp = user["appStoreId"]
	end

	local localGp = Setting:GetPrivateString(SettingKeys.GP_USERID, "");
	if (_gp ~= localGp) then
		Setting:SetString(SettingKeys.GP_USERID, _gp);
	end


	local _gpAccountname = "";
	if (user["googleAccountName"]) then
		self._gpAccountname = user["googleAccountName"]
	end

	local _localAccountname = Setting:GetString(SettingKeys.GP_USERNAME, "");
	if (_gpAccountname ~= _localAccountname) then
		Setting:SetString(SettingKeys.GP_USERNAME, _gpAccountname);
	end

	-- 微信绑定的UID，用来做账号绑定的显示==！
	local _wxAppId = ""
	if (user["weixin"]) then
		_wxAppId = user["weixin"]
	end

	Setting:SetString(SettingKeys.WX_APPID_CACHE, _wxAppId);

	local _fb = ""
	if (user["facebook"]) then
		self._fb = user["facebook"]
	end

	local _localFB = Setting:GetPrivateString(SettingKeys.FB_USERID, "");
	if (_fb ~= _localFB) then
		Setting:SetString(SettingKeys.FB_USERID, _fb);
	end

	local _fbAccountname = ""
	if (user["facebookAccountName"]) then
		self._fbAccountname = user["facebookAccountName"]
	end

	local _localFBAccountname = Setting:GetString(SettingKeys.FB_USERNAME, "");
	if (_fbAccountname ~= _localFBAccountname) then
		Setting:SetString(SettingKeys.FB_USERNAME, _fbAccountname);
	end

	
	local _oicq = "";
	if (user["oicq"]) then
		_oicq = user["oicq"]
	end

	local _localOicq = Setting:GetString(SettingKeys.OICQ_USERID, "");
	if (_oicq ~= _localOicq) then
		Setting:SetString(SettingKeys.OICQ_USERID, _oicq);
	end

	local _weibo = "";
	if (user["weibo"]) then
		_weibo = user["weibo"]
	end

	local _localWeibo = Setting:GetString(SettingKeys.WEIBO_USERID, "");
	if (_weibo ~= _localWeibo) then
		Setting:SetString(SettingKeys.WEIBO_USERID, _weibo);
	end
	
	-- email
	local _mail = "";
	if (user["email"]) then
		self._mail = user["email"]
	end

	local _localMail = Setting:GetString(SettingKeys.CUSTOM_UID, "");
	if (_mail ~= _localMail) then
		Setting:SetString(SettingKeys.CUSTOM_UID, _mail);
	end

	local _emailConfirm = 0;
	if (user["emailConfirm"]) then
		self._emailConfirm = user["emailConfirm"]
	end

	local _localEmailConfirm = Setting:GetInt(SettingKeys.EMAIL_CONFIRM, 0);
	if (_emailConfirm ~= _localEmailConfirm) then
		Setting:SetInt(SettingKeys.EMAIL_CONFIRM, _emailConfirm);
	end

	if (_gp == "" and _fb == "" and _mail == "" and _oicq == "" and _weibo == "" and _wxAppId == "") then
		LuaEntry.GlobalData.isBindAcount = false;
	else
		LuaEntry.GlobalData.isBindAcount = true;
	end
	
	local _AZAccount = ""
	if (user["az_account"]) then
		self._AZAccount = user["az_account"]
	end

	local _localAZAccount = Setting:GetString(SettingKeys.AZ_ACCOUNT, "");
	if (_AZAccount ~= _localAZAccount) then
		Setting:SetString(SettingKeys.AZ_ACCOUNT, _AZAccount);
	end

	local _AZAccountStatus = ""
	if (user["az_account_status"]) then
		_AZAccountStatus = user["az_account_status"]
	end

	local _localAZAccountStatus = Setting:GetString(SettingKeys.AZ_ACCOUNTSTATUS, "");
	if (_AZAccountStatus ~= _localAZAccountStatus) then
		Setting:SetString(SettingKeys.AZ_ACCOUNTSTATUS, _AZAccountStatus);
	end
	
end

-- 保存本次账户
function PlayerInfo:SaveThisAccount()
	-- 历史账号存储
	local accountInfo = AccountInfo.New()
	accountInfo.serverid = self.serverId
	accountInfo.gameUid = self.uid
	accountInfo.nickname = self.name
	accountInfo.newLevel = DataCenter.BuildManager.MainLv
	accountInfo.ip = Setting:GetString(SettingKeys.SERVER_IP)
	accountInfo.port = Setting:GetInt(SettingKeys.SERVER_PORT)
	accountInfo.zone = Setting:GetString(SettingKeys.SERVER_ZONE)
	accountInfo.time = self.regTime
	DataCenter.AccountListManager:AddAcountInfo(accountInfo)
	Setting:SetString(SettingKeys.GAME_UID, self.uid)
end

function PlayerInfo:getPayLevel()
	-- 付费等级按照 免费 标记0，付费0-100美元 标记1，付费100-1000美金  标记2，付费1000-5000美金 标记3，付费5000-10000美金 标记4，10000-30000美金  标记5，付费30000-80000美金 标记6 付费80000以上美金 标记6
	
	local score =
	{0, 100, 1000, 5000, 10000, 30000, 80000}

	for i=10,-1,0 do
		if self.payMonthlyDollarTotal > score[i] then
			return i
		end
	end
	return 0;
end

function PlayerInfo:getPayLevelM()
	local score = 
	{0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000}
	
	for i=10,-1,0 do	
		if self.payMonthlyDollarTotal > score[i] then
			return i
		end
	end
	
	return 0
end

function PlayerInfo:GetUid()
	return self.uid
end

function PlayerInfo:SetName(name)
	if self.name == name then
		return
	end
	
	self.name = name
	DataCenter.AccountManager:AddSelfAccount()
end

function PlayerInfo:GetName()
	return self.name
end

function PlayerInfo:SetPic(pic)
	self.pic = pic
end
--获得头像名称
function PlayerInfo:GetPic()
	return self.pic
end
--获得头像路径
function PlayerInfo:GetFullPic()
	local index = string.find(self.pic, "player_head_", 0, true)
	if index==nil or index<0 then
		return "Assets/Main/Sprites/UI/Common/New/Common_icon_player_head_big"
	else
		return "Assets/Main/Sprites/UI/UIHeadIcon/"..self.pic..".png"
	end
end

-- 获取当前我在的服务器id
function PlayerInfo:GetCurServerId()
	if self.checkServerId >= 0 then
		return self.checkServerId
	end
	return self.serverId
end

function PlayerInfo:GetCurWorldId()
	return self.checkWorldId
end

function PlayerInfo:SetWorldId(worldId)
	self.checkWorldId = worldId
end

function PlayerInfo:IsInSelfServer()
	if 0 <= self.checkServerId and self.checkServerId~= self.serverId then
		return false
	end
	return true
end

function PlayerInfo:SetCrossServerId(crossServerId)
	self.checkServerId = crossServerId
end
function PlayerInfo:GetCrossServerId()
	return self.checkServerId
end
-- 获取账号所在的服务器id
function PlayerInfo:GetSelfServerId()
	return self.serverId
end
function PlayerInfo:SetServerType(serverType)
	self.serverType = serverType
end
function PlayerInfo:ResetServerType()
	self.serverType = self.srcServerType
end
function PlayerInfo:GetSrcServerId()
	if self.crossFightSrcServerId~=nil and self.crossFightSrcServerId>0 then
		return self.crossFightSrcServerId
	end
	return self.serverId
end

function PlayerInfo:IsInCrossFight()
	if self.crossFightSrcServerId~=nil and self.crossFightSrcServerId>0 and self.crossFightSrcServerId~=self:GetSelfServerId() then
		return true
	end
	return false
end
-- 获取破罩冷却时
function PlayerInfo:GetCityProtectCoolDownTime()

	if (string.IsNullOrEmpty(self.CooldownTime)) then
		return 0;
	end
		
	local cooltimes = self.CooldownTime.Split(';')
	--local mainLv = GameEntry.DataCenter.BuildManager.MainLv
	local mainLv = 1

	if (mainLv > cooltimes.Length) then
		return 0
	end
		
	return toInt(cooltimes[mainLv - 1])
end

function PlayerInfo:GetGMFlag()
	return self.gmFlag
end

-- 是否在联盟中 isTemp：临时联盟
function PlayerInfo:IsInAlliance(isTemp)

	return not string.IsNullOrEmpty(self.allianceId)
	--if (isTemp) then
		--if (GameEntry.Data.Alliance.alliance ~= null and 
				--1 == GameEntry.Data.Alliance.alliance.type) then
			
			--return false;
		--end
		--return not string.IsNullOrEmpty(self.allianceId)
	--end
end

function PlayerInfo:CheckIfHasFreeAlMove()
	local unlock = DataCenter.AllianceBaseDataManager:CheckIfAllianceFuncOpen(AllianceTaskFuncType.AllianceMoveCity)
	if not unlock then
		return false
	end
	
	if self.lastFreeAlMoveTime == 0 then
		return true
	end
	local curTime = UITimeManager:GetInstance():GetServerTime()
	local timeSpanM = LuaEntry.DataConfig:TryGetNum("TP_CD", "k1")
	local nextFreeTime = self.lastFreeAlMoveTime + timeSpanM * 60000
	if curTime > nextFreeTime then
		return true
	else
		return false, nextFreeTime
	end
end

-- 更新头像UpdatePic
function PlayerInfo:UpdatePic(message)
	if message['picVer'] == nil then
		return
	end

	self.picVer = message['picVer']
	self.pic = message['pic'] or ''

	-- 这个值登录的时候没有发过来，只是在换头像之后
	-- 这样的话，换头像再换机器是不受这个限制的。
	-- 因为换头像这个操作限制一般也就24小时，所以他们之前就是这么处理的
	if message['nextUpdateTime'] ~= nil then
		Setting:SetPrivateString("nextUpdateHeadPicTime", tostring(message['nextUpdateTime']))
	end

	if message['lastUpdateTime'] then
		LuaEntry.Player:SetLastUpdateTime(message['lastUpdateTime'])
	end

	--账号列表中要显示头像 因此更新下本地的缓存
	DataCenter.AccountManager:AddSelfAccount()

	--notify
	local obj = SFSObject.New()
	obj:PutUtfString("uid", self.uid)
	obj:PutUtfString("pic", self.pic)
	obj:PutInt("picVer", self.picVer)
	EventManager:GetInstance():Broadcast(EventId.UpdateHeadImg, obj)
end


function PlayerInfo:GetPicVer()
	return self.picVer
end
-- 设置联盟uid
function PlayerInfo:SetAllianceUid(uid)
	self.allianceId = uid
end

-- 获取联盟uid
function PlayerInfo:GetAllianceUid()
	return self.allianceId
end

function PlayerInfo:SetLastFreeMvTime(lastTime)
	self.lastFreeAlMoveTime = lastTime
end

function PlayerInfo:GetHeadBgImg(self)
	return DataCenter.DecorationDataManager:GetSelfHeadFrame()
	--local headBgImg = nil
	--
	--local golloesHeadBg = DataCenter.MonthCardNewManager:GetGolloesHeadBg()
	--if golloesHeadBg and golloesHeadBg ~= "" then
	--	headBgImg = golloesHeadBg
	--end
	--if headBgImg and headBgImg ~= "" then
	--	return string.format(LoadPath.CommonNewPath,headBgImg)
	--end
end

-- 设置最后更新时间
function PlayerInfo:SetLastUpdateTime(lastUpdateTime)
	self.lastUpdateTime = toInt(lastUpdateTime)
	EventManager:GetInstance():Broadcast(ChatInterface.getEventEnum().CHAT_SET_INFO)
end

-- 设置保护罩信息
function PlayerInfo:SetProtectTimeStamp(timeStamp)
	self.ProtectTimeStamp = timeStamp
end

-- 设置资源保护信息
function PlayerInfo:SetResourceProtectTimeStamp(timeStamp)
	self.ResourceProtectTimeStamp = timeStamp
end

-- 获取相应值
function PlayerInfo:GetValue(strKey)
	if self[strKey] then
		return self[strKey]
	end
	
	return nil
end

-- 设置相应值，目前主要是为了兼容C#代码
function PlayerInfo:SetValue(strKey, value)
	self[strKey] = value
end

function PlayerInfo:GetABTestTableName(tableName)
	if LuaEntry.DataConfig:CheckSwitch("ABtest_".. tableName) then
		local useAB = true
		--local country = DataCenter.BuildManager:GetCountry()
		--if country ~= nil and country ~= "" then
		--	for k,v in ipairs(UseABTestCountry) do
		--		if v == country then
		--			useAB = true
		--			break
		--		end
		--	end
		--else
		--	useAB = true
		--end
		if useAB and self.abTest ~= ABTestType.A then
			local name = self.abTest == ABTestType.B and tableName.."_B" or tableName.."_C"
			if LocalController:instance():getTable(name) ~= nil then
				return name
			end
			name = self.abTest == ABTestType.B and tableName.."_b" or tableName.."_c"
			if LocalController:instance():getTable(name) ~= nil then
				return name
			end
		end
	elseif self:GetGMFlag() > 0 and LuaEntry.DataConfig:CheckSwitch(tableName .. "_GM") then
		local name = tableName.."_B"
		if LocalController:instance():getTable(name) ~= nil then
			return name
		end
		name = tableName.."_b"
		if LocalController:instance():getTable(name) ~= nil then
			return name
		end
	end
	
	return tableName
end

function PlayerInfo:ShowPlayerChangeHeadRedPot()
	local flag = Setting:GetInt(self.uid..self.pushMark.."FIRST_PAY_BUY_CLICK", 0)
	return flag == 1 and LuaEntry.Player.modfiyPicStatus == true
end


--记录头像上传状态
function PlayerInfo:IsPicUploading()
	return self.picUploading
end

function PlayerInfo:UploadPicStart()
	self.picUploading = true
	UIUtil.ShowTipsId(280180) --头像上传中
	EventManager:GetInstance():Broadcast(EventId.UploadHead_Start)
end

function PlayerInfo:UploadPicEnd()
	self.picUploading = false
	EventManager:GetInstance():Broadcast(EventId.UploadHead_End)
end

function PlayerInfo:SetStaminaData(message)
	self.pveFakeStamina = 0
	if message["stamina"]~=nil then
		self.stamina = message["stamina"]
	end
	if message["lastStaminaTime"]~=nil then
		self.lastStaminaTime = message["lastStaminaTime"]
	end
	--检查推送
	local config = DataCenter.ArmyFormationDataManager:GetConfigData()
	if config~=nil then
		if config.FormationStaminaMax > self.stamina then
			local deltaNum = config.FormationStaminaMax-self.stamina
			local endTime = deltaNum*config.FormationStaminaUpdateTime
			DataCenter.PushNoticeManager:CheckPushStaminaFull(endTime)
		end
	end
	
end

function PlayerInfo:SetStaminaGoldTime(message)
	if message["playerStaminaGoldTime"]~=nil then
		self.playerStaminaGoldTime = message["playerStaminaGoldTime"]
	end
	if message["playerStaminaGoldNum"]~=nil then
		self.playerStaminaGoldNum = message["playerStaminaGoldNum"]
	end
end

function PlayerInfo:GetCurStaminaGoldNum()
	local curTime = UITimeManager:GetInstance():GetServerSeconds()
	if not UITimeManager:GetInstance():IsSameDayForServer(math.floor(self.playerStaminaGoldTime/1000),curTime) then
		self.playerStaminaGoldNum = 0
	end
	return self.playerStaminaGoldNum
end

function PlayerInfo:GetCurStamina()
	local num = self.stamina + self.pveFakeStamina
	local config = DataCenter.ArmyFormationDataManager:GetConfigData()
	if config~=nil then
		if config.FormationStaminaMax > self.stamina then
			local curTime = UITimeManager:GetInstance():GetServerTime()
			local deltaTime = curTime- self.lastStaminaTime
			local realStamina = math.floor(math.floor(deltaTime/(config.FormationStaminaUpdateTime*1000))+ num)
			num = math.min(realStamina,config.FormationStaminaMax)
		end
	end
	num = math.floor(math.max(0, num)) 
	return num
end

function PlayerInfo:SetPveStaminaData(message)
	self.pveFakeStamina = 0
	if message["pveStamina"]~=nil then
		self.pveStamina = message["pveStamina"]
	end
	if message["lastPveStaminaTime"]~=nil then
		self.lastPveStaminaTime = message["lastPveStaminaTime"]
	end
end

function PlayerInfo:GetCurPveStamina()
	return self:GetCurStamina()
	--local num  = self.pveStamina
	--local maxBase = self:GetMaxPveStamina()
	--if maxBase > self.pveStamina then
	--	local speed = LuaEntry.DataConfig:TryGetNum("pve_energy", "k2")
	--	local curTime = UITimeManager:GetInstance():GetServerTime()
	--	local deltaTime = curTime- self.lastPveStaminaTime
	--	local realStamina = math.floor((deltaTime/(speed * 1000))+ num)
	--	num = math.min(realStamina ,maxBase)
	--end
	--num = math.max(0, num + self.pveFakeStamina)
	--return num
end

--可以为负
function PlayerInfo:ChangePveStamina(addNum)
	self.pveFakeStamina = self.pveFakeStamina + addNum
end

--获取最大体力
function PlayerInfo:GetMaxPveStamina()
	local config = DataCenter.ArmyFormationDataManager:GetConfigData()
	if config~=nil then
		return config.FormationStaminaMax
	end
	return 0
	--return LuaEntry.DataConfig:TryGetNum("pve_energy", "k1") + LuaEntry.Effect:GetGameEffect(EffectDefine.PVE_STAMINA_MAX)
end

function PlayerInfo:SetFoldCrossWormHoleTime(obj)
	if obj["fold_cross_worm_hole_time"]~=nil then
		self.fold_cross_worm_hole_time = obj["fold_cross_worm_hole_time"]
	end
end

function PlayerInfo:GetFoldCrossWormHoleTime()
	return self.fold_cross_worm_hole_time
end

function PlayerInfo:SetFoldSubWormHoleTime(obj)
	self.fold_sub_worm_hole_time = {}
	--if obj["fold_sub_worm_hole_time"]~=nil then
	--	local buildId = BuildingTypes.APS_BUILD_WORMHOLE_SUB
	--	local buildTime = tonumber(obj["fold_sub_worm_hole_time"])
	--	self.fold_sub_worm_hole_time[buildId] = buildTime
	--end
	if obj["fold_sub_worm_hole_time_new"]~=nil then
		local str = obj["fold_sub_worm_hole_time_new"]
		local arr = string.split(str,"|")
		if #arr>0 then
			for i =1,#arr do
				local subArr = string.split(arr[i],";")
				if #subArr>=2 then
					local buildId = toInt(subArr[1])
					local buildTime = tonumber(subArr[2])
					self.fold_sub_worm_hole_time[buildId] = buildTime
				end
			end
		end
	end
end

function PlayerInfo:GetFoldSubWormHoleTime(buildId)
	if self.fold_sub_worm_hole_time[buildId]~=nil then
		return self.fold_sub_worm_hole_time[buildId]
	end
	return 0
end

function PlayerInfo:GetMainWorldPos()
	return self.world_main_pos
end

function PlayerInfo:SetMainWorldPointId(pointId)
	if pointId>0 then
		local posV3 = SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World)
		if posV3~=nil then
			posV3.x = posV3.x-2
			posV3.z = posV3.z-2
			self.world_main_pos= SceneUtils.WorldToTileIndex(posV3,ForceChangeScene.World)
		end
	else
		self.world_main_pos = pointId
	end
end

--获取性别
function PlayerInfo:GetSex()
	return self.sex
end

--获取改变性别所需花费钻石数量(0表示免费)
function PlayerInfo:GetModifySexCostNum()
	return SexUtil.GetModifySexCostNum(self.changeSexCount)
end

--设置性别
function PlayerInfo:SetSexData(user)
	if user["sex"] then
		self.sex = user["sex"]
	end
	if user["changeSexCount"] then
		self.changeSexCount = user["changeSexCount"]
	end
	local changeSexRecord = user["changeSexRecord"]
	if changeSexRecord ~= nil and changeSexRecord ~= "" then
		-- str 性别修改记录 格式  sex;count|sex;count
		self.changeSexRecord = {}
		local str = string.split_ss_array(changeSexRecord, "|")
		if #str > 0 then
			for k, v in ipairs(str) do
				if v ~= "" then
					local per = string.split_ii_array(v, ";")
					if #per > 1 then
						self.changeSexRecord[per[1]] = per[2]
					end
				end
			end
		end
	end
end

--获取每种性别更改的次数
function PlayerInfo:GetSexChangeTimeBySexType(sexType)
	return self.changeSexRecord[sexType] or 0
	
end
function PlayerInfo:SetExtraDesertNum(num)
	self.extraDesertNum = num
	EventManager:GetInstance():Broadcast(EventId.UserGetDesertAdd)
end
function PlayerInfo:GetExtraDesertNum()
	return self.extraDesertNum
end

function PlayerInfo:IsInCnServer()
	return self.srcIsCnServer == 1
end

--获取官职
function PlayerInfo:GetPositionId()
	return DataCenter.GovernmentManager:GetPositionId()
end

--获取官职
function PlayerInfo:GetExploitRank()
	return DataCenter.AlContributeManager:GetSelfExploitRank()
end

function PlayerInfo:IsUseNewABan()
	return self.abTest == ABTestType.B and LuaEntry.DataConfig:CheckSwitch("kaituozhe_ab")
end
function PlayerInfo:SetPlayerNitrogen(message)
	if message["nitrogen"]~=nil then
		self.nitrogen = message["nitrogen"]
	end
	if message["lastNitrogenTime"]~=nil then
		self.lastNitrogenTime = message["lastNitrogenTime"]
	end
end

function PlayerInfo:GetMaxNitrogen()
	return LuaEntry.Effect:GetGameEffect(EffectDefine.NITROGEN_MAX)
end

function PlayerInfo:GetNitrogenSpeed()
	return LuaEntry.Effect:GetGameEffect(EffectDefine.NITROGEN_SPEED)
end

function PlayerInfo:GetCurNitrogen()
	local max = self:GetMaxNitrogen()
	local speed = self:GetNitrogenSpeed()
	local num = self.nitrogen
	if max > self.nitrogen then
		local curTime = UITimeManager:GetInstance():GetServerTime()
		local deltaTime = curTime- self.lastNitrogenTime
		local realNum = deltaTime*speed/1000+num
		num = realNum
	end
	num = math.floor(math.max(0, math.min(num,max)))
	return num
end

function PlayerInfo:SetEdenCoolDownTime(message)
	if message["time"]~=nil then
		self.edenEnterCoolDownTime = message["time"]
	end
	if message["status"]~=nil then
		self.edenStatus = toInt(message["status"])
	end
end
function PlayerInfo:GetEdenCoolDownTime()
	return self.edenEnterCoolDownTime
end
function PlayerInfo:GetEnterEdenStatus()
	return self.edenStatus
end
function PlayerInfo:UpdateEdenMvCoolDownTime(message)
	if message["edenMoveTime"]~=nil then
		self.edenMoveTime = message["edenMoveTime"]
	end
end
function PlayerInfo:GetEdenMoveTime()
	return self.edenMoveTime
end

function PlayerInfo:UpdateCrossObj(message)
	if message["crossWormObj"]~=nil then
		local dragon = message["crossWormObj"]
		if dragon~=nil then
			self:SetWorldId(dragon["worldId"])
			self:SetServerType(dragon["serverType"])
		end
	elseif message["dragonObj"]~=nil then
		local dragon = message["dragonObj"]
		if dragon~=nil then
			self:SetWorldId(dragon["worldId"])
			self:SetServerType(ServerType.DRAGON_BATTLE_FIGHT_SERVER)
		end
	end
end
function PlayerInfo:SetServerType(serverType)
	self.serverType = serverType
end

--是否属于屏蔽国家
function PlayerInfo:IsHideCountryFlag()
	for k,v in ipairs(HideCountryFlag) do
		if v == self.country then
			return true
		end
	end
	if LuaEntry.GlobalData:IsChina() then
		return true
	end
	return false
end
return PlayerInfo

	

