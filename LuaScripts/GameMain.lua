-- 全局模块
require "Global.Global"
require "Common.LocalController"
local QualitySettingUtil = require "Util.QualitySettingUtil"
local _, LuaDebuggee = pcall(require, 'LuaDebuggee')
if LuaDebuggee and LuaDebuggee.StartDebug then
	if LuaDebuggee.StartDebug('127.0.0.1', 9826) then
		print('LuaPerfect: Successfully connected to debugger!')
	else
		print('LuaPerfect: Failed to connect debugger!')
	end
else
	print('LuaPerfect: Check documents at: https://luaperfect.net')
end
--
--package.cpath = package.cpath .. ';C:/Users/C/AppData/Roaming/JetBrains/Rider2021.1/plugins/EmmyLua/classes/debugger/emmy/windows/x64/?.dll'
--local dbg = require('emmy_core')
--dbg.tcpListen('localhost', 9966)

--package.cpath = package.cpath .. ';/Users/zhangliheng/Library/Application Support/Rider2018.3/intellij-emmylua/classes/debugger/emmy/mac/?.dylib'
--local dbg = require('emmy_core')
--dbg.tcpConnect('localhost', 9966)
--package.cpath = package.cpath .. ';/Users/mac/Library/Application Support/Rider2018.3/intellij-emmylua/classes/debugger/emmy/mac/?.dylib'
--local dbg = require('emmy_core')
--dbg.tcpConnect('localhost', 9966)

----shimin 断点
--package.cpath = package.cpath .. ';C:/Users/1/AppData/Roaming/JetBrains/Rider2023.1/plugins/EmmyLua/debugger/emmy/windows/x64/?.dll'
--local dbg = require('emmy_core')
--dbg.tcpListen('localhost', 9980)

--package.cpath = package.cpath .. ';/Users/mac/Library/Application Support/Rider2018.3/intellij-emmylua/classes/debugger/emmy/mac/?.dylib'
--local dbg = require('emmy_core'
--dbg.tcpConnect('localhost', 9966)
-- 定义为全局模块，整个lua程序的入口类
GameMain = {};
-- Lua脚本主入口
local function Start()
	--WriteLogUtil.OpenFile()
	--debug.sethook(
	--		function (event, line)
	--			WriteLogUtil.WriteToFile("debug.setHook"..debug.getinfo(2).short_src .. ":" .. line)
	--		end
	--, "l")
	Logger.Log("GameMain start.....")
	if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
		Logger.Log("Start lua debugger client")
		--require"Common.mobdebug".start()
	end
	--if CS.CommonUtils.IsDebug() then
		CS.GameEntry.Localization:SetSuportedLanguages(SuportedLanguages)
	--else
	--	CS.GameEntry.Localization:SetSuportedLanguages(OnlineSuportedLanguages)
	--end
	-- 初始化随机种子
	math.randomseed(os.time())
	-- 更新管理器放到第一个处理
	UpdateManager:GetInstance():Startup()
	
	LuaEntry:init()
	RenderSetting.InitRender()
	-- 模块启动
	PBController.InitPBConfig()
	TimerManager:GetInstance():Startup()
	UIManager:GetInstance():Startup()
	LuaEntry:LoadDataConfig()
	DataCenter.QueueDataManager:Startup()
	DataCenter.BuildManager:Startup()
	DataCenter.BuildBubbleManager:Startup()
	DataCenter.PayManager:Startup()
	DataCenter.WorldBuildBubbleManager:Startup()
	DataCenter.BuildUpgradeEffectManager:Startup()
	Sound3DEffectManager:GetInstance():Startup()
	CityDomeProtectEffectManager:GetInstance():Startup()
	DragonEffectManager:GetInstance():Startup()
	DataCenter.BuildQueueManager:Startup()
	BuildBloodManager:GetInstance():Startup()
	AllianceBuildBloodManager:GetInstance():Startup()
	-- BuildLabelTipManager:GetInstance():Startup()
	WorldMarchTileUIManager:GetInstance():Startup()
	TroopHeadUIManager:GetInstance():Startup()
	TroopNameLabelManager:GetInstance():Startup()
	WorldTroopAttackBuildIconManager:GetInstance():Startup()
	PlaceAllianceCenterEffectManager:GetInstance():Startup()
	WorldAlCenterSelectEffectManager:GetInstance():Startup()
	WorldTroopTransIconManager:GetInstance():Startup()
	DataCenter.GuideManager:Startup()
	DataCenter.GuideCityAnimManager:Startup()
	DataCenter.UINoInputManager:Startup()
	DataCenter.WorldAllianceCityDataManager:Startup()
	DataCenter.DesertDataManager:Startup()
	DataCenter.CollectRewardDataManager:Startup()
	WorldArrowManager:GetInstance():Startup()
	MonsterRewardBoxEffectManager:GetInstance():Startup()
	WorldCanBuildEffectManager:GetInstance():Startup()
	WorldNewsTipsManager:GetInstance():Startup()
	WorldDesertEffectManager:GetInstance():Startup()
	WorldCityTipManager:GetInstance():Startup()
	--AllianceCityRangeEffectManager:GetInstance():Startup()
	WorldDesertBattleManager:GetInstance():Startup()
	ThroneBloodManager:GetInstance():Startup()
	AllianceActMineBloodManager:GetInstance():Startup()
	WorldDesertSelectEffectManager:GetInstance():Startup()
	WorldDesertLevelUpManager:GetInstance():Startup()
	DragonRangeEffectManager:GetInstance():Startup()
	WorldBuildHeadUIManager:GetInstance():Startup()
	WorldBattleBuffManager:GetInstance():Startup()
	WorldBattleSiegeEffectManager:GetInstance():Startup()
	WorldBattleDamageDesManager:GetInstance():Startup()
	WorldBattleMineDamageManager:GetInstance():Startup()
	WorldBossBloodTipManager:GetInstance():Startup()
	AllianceBossBloodTipManager:GetInstance():Startup()
	WorldMonsterBloodTipManager:GetInstance():Startup()
	DataCenter.ActivityTipManager:Startup()
	DataCenter.AllianceCityTipManager:Startup()
	DataCenter.SteamPriceTemplateManager:Startup()
	DataCenter.AllianceCityTemplateManager:Startup()
	DataCenter.WorldDesertRefreshTemplateManager:StartUp()
	DataCenter.DesertTemplateManager:StartUp()
	DataCenter.CityPointManager:Startup()
	EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, GameMain.OnEnterGameHandle)
	DataCenter.FlyController:Startup()
	DataCenter.LoginPopManager:Startup()
	DataCenter.AllianceCareerManager:Startup()
	DataCenter.HeroEntrustManager:Startup()
	DataCenter.HeroEntrustBubbleManager:Startup()
	DataCenter.GuideNeedLoadManager:Startup()
	DataCenter.ShaderEffectManager:Startup()
	DataCenter.CityLabelManager:Startup()
	DataCenter.WorldBuildTimeManager:Startup()
	DataCenter.DeadArmyRecordManager:Startup()
	DataCenter.CityCameraManager:Startup()
	DataCenter.WorldCameraManager:Startup()
	DataCenter.ActBlackKnightManager:Startup()
	DataCenter.WorldGotoManager:Startup()
	DataCenter.HeroPluginManager:Startup()
	DataCenter.HeroPluginRankManager:Startup()
	DataCenter.HeroMedalRedemptionManager:Startup()
	DataCenter.HeroLevelUpTemplateManager:Startup()
	DataCenter.RadarBossManager:Startup()
	DataCenter.ChangeNameAndPicManager:Startup()
	DataCenter.GoogleAdsManager:Startup()
	DataCenter.UnityAdsManager:Startup()
	DataCenter.FurnitureManager:Startup()
	DataCenter.StormManager:Startup()
	DataCenter.FurnitureObjectManager:Startup()
	DataCenter.FurnitureEffectManager:Startup()
	DataCenter.BuildCityBuildManager:Startup()
	DataCenter.BuildCanCreateManager:Startup()
	DataCenter.ZeroTreeManager:Startup()
	DataCenter.UnlockBtnManager:Startup()
	DataCenter.BuildWallEffectManager:Startup()
	DataCenter.FogManager:Startup()
	DataCenter.BuildEffectManager:Startup()
	DataCenter.WaitTimeManager:Startup()
	DataCenter.BuildFogEffectManager:Startup()
	DataCenter.BellManager:Startup()
	DataCenter.EffectSceneManager:Startup()
	DataCenter.WaitUpdateManager:Startup()
	DataCenter.HeroStarStoryManager:Startup()
	DataCenter.FurnitureProductManager:Startup()
	DataCenter.TaskFlipManager:Startup()
	CS.MoreMountains.NiceVibrations.MMVibrationManager.SetHapticsActive(CS.GameEntry.Setting:GetBool(SettingKeys.VIBRATE, true))
	-- 
	-- DOTween.Init(true)
	PveUtil.CheckConfigChanged()

	--collectgarbage('setpause', 99)
	--collectgarbage('setstepmul', 500)
end

local function DoLoading(isReload, showLogo)
	-- 转到loading UI
	AppStartupLoading:GetInstance():Start(isReload, showLogo)
end
-- 退出
local function Exit()
	LuaDBInterface.Uninit()
	
	DataCenter.ResourceManager:Delete()
	DataCenter.TaskFlipManager:Delete()
	DataCenter.FurnitureProductManager:Delete()
	DataCenter.WaitUpdateManager:Delete()
	DataCenter.EffectSceneManager:Delete()
	DataCenter.BellManager:Delete()
	DataCenter.BuildFogEffectManager:Delete()
	DataCenter.WaitTimeManager:Delete()
	DataCenter.BuildEffectManager:Delete()
	DataCenter.BuildWallEffectManager:Delete()
	DataCenter.UnlockBtnManager:Delete()
	DataCenter.ZeroTreeManager:Delete()
	DataCenter.BuildCanCreateManager:Delete()
	DataCenter.BuildCityBuildManager:Delete()
	DataCenter.FurnitureEffectManager:Delete()
	DataCenter.FurnitureObjectManager:Delete()
	DataCenter.StormManager:Delete()
	DataCenter.FurnitureManager:Delete()
	DataCenter.ChangeNameAndPicManager:Delete()
	DataCenter.RadarBossManager:Delete()
	DataCenter.GoogleAdsManager:Delete()
	DataCenter.UnityAdsManager:Delete()
	DataCenter.HeroLevelUpTemplateManager:Delete()
	DataCenter.HeroMedalRedemptionManager:Delete()
	DataCenter.HeroPluginRankManager:Delete()
	DataCenter.HeroPluginManager:Delete()
	DataCenter.WorldGotoManager:Delete()
	DataCenter.ActBlackKnightManager:Delete()
	DataCenter.CityCameraManager:Delete()
	DataCenter.WorldCameraManager:Delete()
	DataCenter.DeadArmyRecordManager:Delete()
	DataCenter.WorldBuildTimeManager:Delete()
	DataCenter.CityLabelManager:Delete()
	DataCenter.ShaderEffectManager:Delete()
	DataCenter.GuideNeedLoadManager:Delete()
	DataCenter.HeroEntrustBubbleManager:Delete()
	DataCenter.HeroEntrustManager:Delete()
	DataCenter.AllianceCareerManager:Delete()
	DataCenter.UINoInputManager:Delete()
	DataCenter.GuideCityAnimManager:Delete()
	DataCenter.GuideCityManager:Delete()
	DataCenter.GuideManager:Delete()
	DataCenter.ArrowManager:Delete()
	DataCenter.MonsterManager:Delete()
	DataCenter.ItemData:Delete()
	DataCenter.BuildQueueManager:Delete()
	Sound3DEffectManager:GetInstance():Delete()
	CityDomeProtectEffectManager:GetInstance():Delete()
	DragonEffectManager:GetInstance():Delete()
	DataCenter.QueueDataManager:Delete()
	DataCenter.BuildManager:Delete()
	DataCenter.BuildBubbleManager:Delete()
	DataCenter.WorldBuildBubbleManager:Delete()
	DataCenter.PushNoticeManager:Delete()
	DataCenter.AccountManager:Delete()
	DataCenter.BuildUpgradeEffectManager:Delete()
	DataCenter.PushUtil:Delete()
	DataCenter.ResLackManager:Delete()
	DataCenter.WorldAllianceCityDataManager:Delete()
	DataCenter.DesertDataManager:Delete()
	DataCenter.CollectRewardDataManager:Delete()
	DataCenter.ActivityTipManager:Delete()
	DataCenter.AllianceCityTipManager:Delete()
	DataCenter.AllianceCityTemplateManager:Delete()
	DataCenter.SteamPriceTemplateManager:Delete()
	DataCenter.WorldDesertRefreshTemplateManager:Delete()
	DataCenter.DesertTemplateManager:Delete()
	DataCenter.CityPointManager:Delete()
	DataCenter.BattleLevel:Destroy()
	DataCenter.LWBattleManager:Destroy()
	DataCenter.FlyController:Delete()
	DataCenter.CityNpcManager:Delete()
	AllianceBuildBloodManager:GetInstance():Delete()
	BuildBloodManager:GetInstance():Delete()
	-- BuildLabelTipManager:GetInstance():Delete()
	WorldMarchTileUIManager:GetInstance():Delete()
	WorldMarchEmotionManager:GetInstance():Destroy()
	TroopHeadUIManager:GetInstance():Delete()
	WorldTroopTransIconManager:GetInstance():Delete()
	WorldTroopAttackBuildIconManager:GetInstance():Delete()
	WorldAlCenterSelectEffectManager:GetInstance():Delete()
	TroopNameLabelManager:GetInstance():Delete()
	WorldArrowManager:GetInstance():Delete()
	MonsterRewardBoxEffectManager:GetInstance():Delete()
	WorldCanBuildEffectManager:GetInstance():Delete()
	WorldBossBloodTipManager:GetInstance():Delete()
	WorldMonsterBloodTipManager:GetInstance():Delete()
	AllianceBossBloodTipManager:GetInstance():Delete()
	WorldNewsTipsManager:GetInstance():Delete()
	WorldDesertEffectManager:GetInstance():Delete()
	WorldCityTipManager:GetInstance():Delete()
	--AllianceCityRangeEffectManager:GetInstance():Delete()
	WorldDesertBattleManager:GetInstance():Delete()
	ThroneBloodManager:GetInstance():Delete()
	AllianceActMineBloodManager:GetInstance():Delete()
	WorldDesertSelectEffectManager:GetInstance():Delete()
	WorldDesertLevelUpManager:GetInstance():Delete()
	WorldBuildHeadUIManager:GetInstance():Delete()
	PlaceAllianceCenterEffectManager:GetInstance():Delete()
	WorldBattleBuffManager:GetInstance():Delete()
	WorldBattleSiegeEffectManager:GetInstance():Delete()
	WorldBattleDamageDesManager:GetInstance():Delete()
	WorldBattleMineDamageManager:GetInstance():Delete()
	UIManager:GetInstance():DestroyAllWindow(true)
	DataCenter.DailyActivityManager:Delete()
	DataCenter.VitaManager:Delete()
	DataCenter.OpinionManager:Delete()
	DataCenter.CityResidentManager:Delete()
	DataCenter.CityHudManager:Delete()
	DataCenter.FogManager:Delete()
	DataCenter.LandManager:Delete()
	DataCenter.HeroStarStoryManager:Delete()
	DataCenter.CityWallManager:Delete()

	DataCenter.MailDataManager:Cleanup()
	ChatManager2:GetInstance():Uninit()
	
	RenderSetting.RemoveUpdater()
	QualitySettingUtil.Uninit()
	EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, GameMain.OnEnterGameHandle)
	
	LuaEntry:Uninit()
	TimerManager:GetInstance():Dispose()
	UpdateManager:GetInstance():Dispose()
	
	DOTween.KillAll()
	DOTween.ClearCachedTweens()
	--WriteLogUtil.CloseFile()
	return
end

local function ClearIfTrackingDisabled()
	if CS.SDKManager.IS_IPhonePlayer() then
		pcall(function()
			local lastAllow = CS.GameEntry.Setting:GetBool(SettingKeys.LAST_ALLOW_TRACKING, false)
			local allow = CS.GameEntry.Sdk:IsTrackingEnabled()
			if allow then
				CS.GameEntry.Setting:SetBool(SettingKeys.ALLOW_TRACKING_CLICK, true)
			elseif lastAllow and not allow then
				CS.GameEntry.Setting:SetBool(SettingKeys.ALLOW_TRACKING_CLICK, false)
			end
			CS.GameEntry.Setting:SetBool(SettingKeys.LAST_ALLOW_TRACKING, allow)
		end)
	end
end
local function OnEnterGameHandle()
	local ok, errorMsg = xpcall(function()
		GameMain.OnEnterGame()
	end, debug.traceback)
	if not ok then
		local now = UITimeManager:GetInstance():GetServerSeconds()
		CommonUtil.SendErrorMessageToServer(now, now, errorMsg)
		Logger.LogError(errorMsg)
	end
end
local function OnEnterGame()
	Logger.Log("[loading]on enterGame start")
	QualitySettingUtil.Init()
	UIManager:GetInstance():OpenWindow(UIWindowNames.TouchScreenEffect)
	DataCenter.EdenPassTemplateManager:InitTemplateDict()
	DataCenter.SteamPriceTemplateManager:InitTemplateDict()
	DataCenter.EdenAreaTemplateManager:InitTemplateDict()
	DataCenter.BuildQueueTemplateManager:InitAllTemplate()
	DataCenter.ItemTemplateManager:InitAllTemplate()
	DataCenter.DragonBuildTemplateManager:InitTemplates()
	DataCenter.UavDialogueTemplateManager:InitAllTemplate()
	DataCenter.AccountManager:AddSelfAccount()
	EventManager:GetInstance():Broadcast(EventId.LUA_BUILD_INIT_END)
	DataCenter.PushNoticeManager:PushRegisterSecondDay()
	DataCenter.GuideNeedLoadManager:InitLoadScene()
	DataCenter.AllianceBaseDataManager:DelayShowMoveInviteOnLogin()
	DataCenter.DeadArmyRecordManager:InitReadRecordTime()
	DataCenter.RandomPlugCostTemplateManager:TransAllTemplates()
	DataCenter.RandomPlugTemplateManager:TransAllTemplates()
	DataCenter.HeroLevelUpTemplateManager:TransAllTemplates()
	if DataCenter.HeroPluginManager:IsOpen() then
		DataCenter.HeroPluginRankManager:SendGetPluginRank()
	end
	Sound3DEffectManager:GetInstance():TryAdd3DSoundItem()
	DataCenter.CityResidentManager:Init()
	ClearIfTrackingDisabled()
	Logger.Log("[loading]on enterGame finish")
end

local function Protocal(cmd, t)
	if SFSNetwork.HandleMessage(cmd, t) == true then
		return 
	end
	
	if ChatManager2:GetInstance():OnHandleMessage(cmd, t) == true then
		return 
	end
	
	if CS.CommonUtils.IsDebug() then
		print("unknown msg: " .. (cmd or "nil"))
	end
end


local function DataCenterInit()
	ChatPrint("DataCenterInit!!")
	local playerUid = LuaEntry.Player.uid

	-- 想屏蔽聊天就把这个打开
	-- return
	
	-- 初始化数据库系统，初始完毕之后初始化邮件和聊天
	LuaDBInterface.Init(
			function ()
				ChatManager2:GetInstance():Init(playerUid)
				DataCenter.MailDataManager:Startup()
			end)
end

local function UpdateUITimeStamp(timeStamp)
	UITimeManager:GetInstance():UpdateServerMsDeltaTime(timeStamp)
end


local function ShowTips(msg)--,img)
	UIUtil.ShowTips(msg)--,img)
end

local function ShowMessage(tipText,btnNum,text1,text2,action1,action2,closeAction,titleText,isChangeImg)
	UIUtil.ShowMessage(tipText,btnNum,text1,text2,action1,action2,closeAction,titleText,isChangeImg)
end

local function ShowFoldUpBuild(posX,posY,posZ,bUuid)
	local pos = Vector3.New(tonumber(posX),tonumber(posY),tonumber(posZ))
	DataCenter.FlyResourceEffectManager:ShowFoldUpBuildEffect(pos,tonumber(bUuid))
end

local function GetTemplateData(_type, itemId, name)
	--这里是C#读表接口，先判断AB测
	if LuaEntry.Player ~= nil then
		_type = LuaEntry.Player:GetABTestTableName(_type)
	end
	return LocalController:instance():getStrValue(_type, itemId, name)
end

local function PreloadAssets()
	local ResourceManager = CS.GameEntry.Resource
	local type = typeof(CS.UnityEngine.GameObject)
end

local function GetArmyFormationStamina(uuid)
	return DataCenter.ArmyFormationDataManager:GetArmyInfoByStamina(uuid)
end

GameMain.Start = Start
GameMain.Exit = Exit
GameMain.OnEnterGameHandle = OnEnterGameHandle
GameMain.OnEnterGame = OnEnterGame
GameMain.Protocal = Protocal
GameMain.DataCenterInit = DataCenterInit
GameMain.UpdateUITimeStamp = UpdateUITimeStamp
GameMain.ShowTips = ShowTips
GameMain.ShowMessage = ShowMessage
GameMain.ShowFoldUpBuild = ShowFoldUpBuild
GameMain.GetTemplateData = GetTemplateData
GameMain.PreloadAssets = PreloadAssets
GameMain.GetArmyFormationStamina = GetArmyFormationStamina
GameMain.DoLoading = DoLoading
return GameMain