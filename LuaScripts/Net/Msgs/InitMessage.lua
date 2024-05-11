
local InitMessage = BaseClass("InitMessage", SFSBaseMessage)


-- 基类，用来调用基类方法
local base = SFSBaseMessage

local function OnCreate(self)
	base.OnCreate(self)
end
-- 每次开启游戏的时候只登录第一次,之后切号之类的不处理
local _loginGpPerLaunch = false
local function HandleMessage(self, t)
	base.HandleMessage(self, t)
	LuaEntry:onMessage(t)
	DataCenter.SeasonDataManager:InitData(t)
	DataCenter.BirthPointTemplateManager:InitBornPointList()
	DataCenter.BuildManager:InitData(t)
	DataCenter.AccountManager:InitData(t)
	DataCenter.DailyTaskManager:TryReqUpdateData()
	DataCenter.ChapterTaskManager:InitData(t)
	DataCenter.TaskManager:InitData(t)
	DataCenter.ActivityListDataManager:InitActivityListData(t)
	DataCenter.ItemData:ParseItemData(t.items)
	DataCenter.ItemManager:ItemEffectStateList(t)
	GiftPackageData.init(t)
	MonthCardManager.init(t)
	DataCenter.MonthCardNewManager:InitGolloesMonthCard(t)
	DataCenter.AlContributeManager:UpdateMonthCardInfo(t)
	DataCenter.CumulativeRechargeManager:InitDat(t)
	DataCenter.KeepPayManager:HandleInit(t)
	DataCenter.WatchAdManager:HandleInit(t)
	DataCenter.GolloesCampManager:UpdateGolloesInfo(t)
	DataCenter.PayManager:InitData(t)
	DataCenter.ScienceDataManager:InitData(t)
	DataCenter.ArmyFormationDataManager:InitArmyFormationListData(t)
	DataCenter.QueueDataManager:InitQueueDataList(t)
	DataCenter.BuildQueueManager:InitQueueList(t)
	DataCenter.HeroEffectSkillManager:InitData(t)
	DataCenter.AllianceMineManager:UpdateAllianceMineInfo(t)
	DataCenter.FormStatusManager:HandleInit(t)
	DataCenter.BuildStatusManager:HandleInit(t)
	DataCenter.GovernmentManager:initSelfPosition(t)
	DataCenter.AlContributeManager:InitExploitRankInfo(t)
	DataCenter.GloryManager:GetEdenGroup()
	DataCenter.GloryManager:InitQuitAllianceTime(t["declareWarExitAlRecord"])
	DataCenter.DailyActivityManager:Startup()
	if t["alliance"]~=nil then
		DataCenter.AllianceBaseDataManager:UpdateAllianceBaseData(t,true)
		SFSNetwork.SendMessage(MsgDefines.GetAllianceAutoJoinRallyInfo)
	else
		SFSNetwork.SendMessage(MsgDefines.LoginOther,"alliance")
	end
	DataCenter.AllianceBaseDataManager:UpdateMoveInviteInfo(t, false)
	DataCenter.AllianceBaseDataManager:RequestAlMoveInvitePoint()
	DataCenter.WorldFavoDataManager:InitData()
	if t["allianceNewMail"]~=nil then
		DataCenter.AllianceGiftDataManager:UpdateGiftNum(t["allianceNewMail"])
		EventManager:GetInstance():Broadcast(EventId.UpdateAllianceGiftNum)
	end
	
	DataCenter.AllianceMainManager:InitData()
	DataCenter.AllianceCityLogManager:InitData()
	DataCenter.ArmyManager:InitData(t)
	DataCenter.HospitalManager:InitData(t)
	DataCenter.PushSettingData:InitData(t)
	DataCenter.HeroDataManager:InitData(t)
	DataCenter.DefenceWallDataManager:InitData(t)
	DataCenter.RadarCenterDataManager:InitData()
	BuildFireEffectManager:GetInstance():Startup()
	DataCenter.MonsterManager:InitData(t)
	DataCenter.GuideManager:InitData(t)
	DataCenter.GarageRefitManager:InitData(t)
	DataCenter.HeroStationManager:InitData(t)
	DataCenter.ActBossDataManager:InitData(t)
	DataCenter.VIPManager:InitData(t)
	DataCenter.CollectRewardDataManager:UpdateCollectRewardList(t)
	DataCenter.HeroEntrustManager:InitData(t)
	DataCenter.WorldTrendManager:InitData()
	DataCenter.QNManager:InitData()
	DataCenter.DecorationDataManager:InitUserSkins(t)
	DataCenter.MasteryManager:HandleInit(t)
	DataCenter.DesertOperateManager:UpdateDesertMineStartTime(t)
	DataCenter.CrossWormManager:HandleInit(t)
	DataCenter.AllianceShopDataManager:InitData(t)
	local dataConfig = t["dataConfig"]
	if dataConfig ~= nil then
		if dataConfig["fb_push_unlock"] ~= nil then
			DataCenter.PushSettingData:InitData(dataConfig)
		end
	end
	TroopHeadUIManager:GetInstance():InitConfig()
	DataCenter.WorldMarchDataManager:SendRequest()
	-- 设置屏蔽人数上限
	--ChatManager2:GetInstance().Restrict:SetChatShieldMax(CS.GameEntry.DataConfig.GetSampleInt("chatShieldMax"))
	ChatManager2:GetInstance().Restrict:onServerInfo(t)
	SFSNetwork.SendMessage(MsgDefines.AccountGetAllServer,2,-1)
	SFSNetwork.SendMessage(MsgDefines.UserGetServerEffect)
	SFSNetwork.SendMessage(MsgDefines.UserGetServerActEffect)
	DataCenter.DailyPackageManager:GetDailyPackagePreview()
	DataCenter.MigrateDataManager:InitData()
	DataCenter.StaminaBallManager:InitConfig()
	DataCenter.GovernmentManager:GetKingInfo(LuaEntry.Player:GetSrcServerId())
	DataCenter.WorldAllianceCityDataManager:InitAllCityDataRequest()
	DataCenter.DesertDataManager:InitDesertDataRequest(t)
	DataCenter.SeasonWeekManager:SendGetInfo()
	-- 向服务器请求一些数据信息
	SFSNetwork.SendMessage(MsgDefines.PlayerMonthPayInfo)
	SFSNetwork.SendMessage(MsgDefines.GetMineCavePlunderLog)
	SFSNetwork.SendMessage(MsgDefines.GetHeroBountyInfo)
	
	DataCenter.HeroMedalShopDataManager:OnRequestData()

	pcall(function ()
		local isNotifyOpen = CS.GameEntry.Sdk:GetIsNotifyOpen()
		SFSNetwork.SendMessage(MsgDefines.ClientNotifySetting,isNotifyOpen)
	end)
	DataCenter.LeagueMatchManager:OnRecvInitMsg(t)
	DataCenter.AllianceRedPacketManager:InitRedPacket(t)
	DataCenter.HeroMonthCardManager:Startup()
	DataCenter.WorldNewsDataManager:SendRequest()
	DataCenter.AllianceTaskManager:RequestTaskInfo()--红点
	DataCenter.AllianceDeclareWarManager:InitSend()
	DataCenter.TalentDataManager:InitTalent(t)
	SFSNetwork.SendMessage(MsgDefines.AlApplyList,1)
	DataCenter.CommonShopManager:InitAll()
	DataCenter.WeekCardManager:InitData()
	DataCenter.AllianceAutoInviteManager:GetInviteInfoReq()
	DataCenter.HeroOfficialManager:InitHandle(t)
	--DataCenter.HeroIntensifyManager:HandleInit(t)
	DataCenter.WoundedCompensateData:InitData(t)
	DataCenter.WorldNoticeManager:InitData()
	
	DataCenter.CityCameraManager:InitData()
	DataCenter.EquipmentDataManager:InitEquip(t)
	DataCenter.ActFirstChargeData:InitData(t)
	DataCenter.GovernmentWorldBubbleManager:StartUp()
	DataCenter.StoryManager:HandleInit(t)
	DataCenter.OpinionManager:Startup()
	DataCenter.FurnitureManager:InitData(t)
	DataCenter.VitaManager:HandleInit(t)
	DataCenter.StormManager:InitData(t)
	DataCenter.CityHudManager:Startup()
	DataCenter.LandManager:HandleInit(t)
	DataCenter.CitySiegeManager:HandleInit(t)
	DataCenter.CityWallManager:HandleInit(t)
	DataCenter.ActDrakeBossManager:InitData(t)
	DataCenter.HeroEquipManager:InitData(t)
	DataCenter.DailyMustBuyManager:RequestClaimedReward()
	BuildTopBubbleManager:GetInstance():Startup()
	pcall(function()
		CS.GameEntry.Sdk:requestFCMToken()
		CS.GameEntry.Sdk:CrashlyticsSetUserId(LuaEntry.Player.uid)
	end)
	--[[
		在这个地方做google登录的处理
		如果大本等级小于5级,同时没有改过名字,并且google登录失败次数小于2次
	]]
	--local _loginFailCnt = Setting:GetInt("google_login_fail_cnt", 0)
	--local _mainBuildLV = DataCenter.BuildManager.MainLv
	--local _renameCnt = LuaEntry.Player.renameTime
	--local _gpName = Setting:GetString("google_name", "")
	--local _versionCode = tonumber(CS.GameEntry.Sdk.VersionCode)
	--print(">>>google: failcnt: " .. tostring(_loginFailCnt) .. " maincitylv: " .. tostring(_mainBuildLV) .. " rename: " .. tostring(_renameCnt) .. " _gpname:" .. tostring(_gpName) .. " versioncode: " .. tostring(_versionCode) .. " _loginGpPerLaunch: " .. tostring(_loginGpPerLaunch))
	--if (string.IsNullOrEmpty(_gpName) and 
	--		_mainBuildLV <= 5 and 
	--		_renameCnt == 0 and 
	--		_loginFailCnt < 2 and 
	--		_versionCode > 68 and
	--		_loginGpPerLaunch == false) then
	--	_loginGpPerLaunch = true
	--	CS.GameEntry.Sdk:Login(CS.LoginPlatform.GooglePlay);
	--end
	if not DataCenter.GuideManager:IsStartId() and not SceneUtils.GetIsInPve() then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIMain,{})
	end
	--切场景关闭lua gc 防止c# lua gc造成的崩溃
	--if CS.SceneManager.SetAutoGcFlag~=nil then
	--	CS.SceneManager.SetAutoGcFlag(true)
	--end
	
	RenderSetting.AddUpdater()
	EventManager:GetInstance():Broadcast(EventId.PUSH_INIT_OK, t)
end


InitMessage.OnCreate = OnCreate
InitMessage.HandleMessage = HandleMessage

return InitMessage