--[[
-- added by wsh @ 2017-11-30
-- 1、加载全局模块，所有全局性的东西都在这里加载，好集中管理
-- 2、模块定义时一律用local再return，模块是否是全局模块由本脚本决定，在本脚本加载的一律为全局模块
-- 3、对必要模块执行初始化
-- 注意：
-- 1、全局的模块和被全局模块持有的引用无法GC，除非显式设置为nil
-- 2、除了单例类、通用的工具类、逻辑上的静态类以外，所有逻辑模块不要暴露到全局命名空间
-- 3、Unity侧导出所有接口到CS命名空间，访问cs侧函数一律使用CS.xxx，命名空间再cs代码中给了，这里不需要处理
-- 4、这里的全局模块是相对与游戏框架或者逻辑而言，lua语言层次的全局模块放Common.Main中导出
--]]

-- 加载全局模块
require "Framework.Common.BaseClass"
require "Framework.Common.DataClass"
require "Framework.Common.ConstClass"
require "Framework.LuaMono.MonoClass"

App = require "Global.App"
-- 创建全局模块
Config = require "Global.Config"
GlobalCache = require "Global.Cache"

Singleton = require "Framework.Common.Singleton"
Updatable = require "Framework.Common.Updatable"
LocalController = require "Common.LocalController"
-- UpdatableSingleton = require "Framework.Common.UpdatableSingleton"
Logger = require "Framework.Logger.Logger"
PostEventLog = require "Framework.Logger.PostEventLog"
-- require "Framework.Updater.Coroutine"
EventId = require("Framework.UI.Message.EventId")
EventManager = require("Framework.UI.Message.EventManager")
UITimeManager  = require "Framework.UI.Time.UITimeManager"
-- game data
NameCount = 0
DataCenter = require "DataCenter.DataCenter"
RenderSetting =require "Render.RenderSetting"
EnumType = require "Global.EnumType"
require "Global.EnumSoundType"

-- LW PVE
LWEnumType = require "Global.LWEnumType"
HeroSkillTemplate = require "DataCenter.HeroSkillTemplateManager.HeroSkillTemplate"
-- LW PVE end

PostType = require "Chat.Constant.PostType"
GameDialogDefine = require "Global.GameDialogDefine"
ConstDefine = require "Global.ConstDefine"
AppStartupLoading = require "Loading.AppStartupLoading"
QueueInfo = require "DataCenter.QueueData.QueueInfo"
ArmyFormationInfo = require "DataCenter.ArmyFormationData.ArmyFormationInfo"
BasePlayerInfo = require "DataCenter.PlayerData.BasePlayerInfo"
ArenaRankData = require "DataCenter.ArenaManager.ArenaRankData"

AllianceBaseInfo = require "DataCenter.AllianceData.AllianceBaseInfo"
AllianceStorageRecordData = require "DataCenter.AllianceData.AllianceStorageRecordData"
AllianceMemberInfo = require "DataCenter.AllianceData.AllianceMemberInfo"
AllianceInviteMemberData = require "DataCenter.AllianceData.AllianceInviteMemberData"
AllianceWarInfo = require "DataCenter.AllianceData.AllianceWarInfo"
AlLeaderCandidateData = require "DataCenter.AllianceData.AlLeaderCandidateData"
AllianceTaskData = require "DataCenter.AllianceData.AllianceTaskData"
AllianceWarMemberData = require "DataCenter.AllianceData.AllianceWarMemberData"
AllianceWarLeaderData = require "DataCenter.AllianceData.AllianceWarLeaderData"
GiftPackageData = require "DataCenter.GiftPackageData.GiftPackManager"
MonthCardManager = require "DataCenter.MonthCardData.MonthCardManager"
StatusItem = require "DataCenter.ItemData.StatusItem"
ArmyInfo = require "DataCenter.ArmyManager.ArmyInfo"
PlayerRankData = require "DataCenter.RankData.PlayerRankData"
AllianceRankData = require "DataCenter.RankData.AllianceRankData"
AllianceGiftData = require "DataCenter.AllianceData.AllianceGiftData"
TaskInfo = require "DataCenter.TaskData.TaskInfo"
ChapterTaskInfo = require "DataCenter.ChapterTaskData.ChapterTaskInfo"
DailyTaskInfo = require "DataCenter.DailyTaskData.DailyTaskInfo"
AllianceHelpInfo = require "DataCenter.AllianceData.AllianceHelpInfo"
AllianceAutoInviteData = require "DataCenter.AllianceData.AllianceAutoInviteData"
AllianceDonateRankData = require "DataCenter.AllianceData.AllianceDonateRankData"
PushInfo = require "DataCenter.PushSettingData.PushInfo"
PushSettingInfo = require "DataCenter.PushSettingData.PushSettingInfo"
AccountInfo = require "DataCenter.AccountData.AccountInfo"
ActivityInfoData = require "DataCenter.ActivityListData.ActivityInfoData"
ActivityScoreInfo = require "DataCenter.ActivityListData.ActivityScoreInfo"
ActivityEventInfo = require "DataCenter.ActivityListData.ActivityEventInfo"
ActivityEventRankRewardInfo = require "DataCenter.ActivityListData.ActivityEventRankRewardInfo"
PersonalRankData = require "DataCenter.ActivityListData.PersonalRankData"
ActivitySevenDayInfo = require "DataCenter.ActivityListData.ActivitySevenDayInfo"
BookMark = require "DataCenter.WorldFavoData.BookMark"
AllianceMarkData = require "DataCenter.WorldFavoData.AllianceMarkData"
--HeroManager = require "DataCenter.HeroData.HeroManager"
SkillInfo = require "DataCenter.HeroData.SkillInfo"
UnlockData = require "DataCenter.UnlockData.UnlockData"
--SlotInfo = require "DataCenter.HeroData.SlotInfo"
--SkillDataManager = require "DataCenter.SkillData.SkillDataManager"
--SkillInfo = require "DataCenter.SkillData.SkillInfo"
--TalentInfo = require "DataCenter.HeroData.TalentInfo"

VIPManager = require "DataCenter.VIPData.VIPManager"
VIPTemplateManager = require "DataCenter.VIPData.VIPTemplateManager"
MonthCardNewInfo = require "DataCenter.MonthCardNewManager.MonthCardNewInfo"

AllianceTaskTemplate = require "DataCenter.AllianceData.AllianceTaskTemplate"
UavDialogueTemplate = require "DataCenter.BuildQueueTalkManager.UavDialogueTemplate"
DefenceWallData = require "DataCenter.DefenceWallDataManager.DefenceWallData"
FormationAssistanceData =  require "DataCenter.FormationAssistanceDataManager.FormationAssistanceData"
ResourceTemplate = require "DataCenter.ResourceManager.ResourceTemplate"
BirthPointTemplate = require "DataCenter.BirthPointManager.BirthPointTemplate"
DetectEventInfo = require "DataCenter.RadarCenterDataManager.DetectEventInfo"
WorldPointDetailData = require "DataCenter.WorldPointDetail.WorldPointDetailData"
WorldAllianceCityData = require "DataCenter.WorldPointDetail.WorldAllianceCityData"
CityManageDataManager = require "DataCenter.CityManageData.CityManageDataManager"
CityManageData = require "DataCenter.CityManageData.CityManageData"
HeroStationSkillTemplate = require "DataCenter.HeroStation.HeroStationSkillTemplate"


-- game config
-- LangUtil = require "Config.LangUtil"

-- ui base
PathUtil = require "Framework.Common.PathUtil"
UIBaseCtrl = require "Framework.UI.Base.UIBaseCtrl"
UIBaseComponent = require "Framework.UI.Base.UIBaseComponent"
UIBaseContainer = require "Framework.UI.Base.UIBaseContainer"
UIBaseView = require "Framework.UI.Base.UIBaseView"

-- ui component
UILayerComponent = require "Framework.UI.Component.UILayerComponent"
UICanvas = require "Framework.UI.Component.UICanvas"
UITextMeshProUGUI = require "Framework.UI.Component.UITextMeshProUGUI"
UITextMeshProUGUIEx = require "Framework.UI.Component.UITextMeshProUGUIEx"
UIText = require "Framework.UI.Component.UIText"
UIOutline = require "Framework.UI.Component.UIOutline"
UITweenNumberText = require "Framework.UI.Component.UITweenNumberText"
UITweenNumberText_TextMeshPro = require "Framework.UI.Component.UITweenNumberText_TextMeshPro"
UINewText = require "Framework.UI.Component.UINewText"
UIImage = require "Framework.UI.Component.UIImage"
UIRawImage = require "Framework.UI.Component.UIRawImage"
UIPlayerHead = require "Framework.UI.Component.UIPlayerHead"
CircleImage = require "Framework.UI.Component.CircleImage"
UISlider = require "Framework.UI.Component.UISlider"
UIInput = require "Framework.UI.Component.UIInput"
UITMPInput = require "Framework.UI.Component.UITMPInput"
UIButton = require "Framework.UI.Component.UIButton"
UIToggle = require "Framework.UI.Component.UIToggle"
UIUnlimitedScrollView = require "Framework.UI.Component.UIUnlimitedScrollView"
UIAnimator = require "Framework.UI.Component.UIAnimator"
UISimpleAnimation = require "Framework.UI.Component.UISimpleAnimation"
UIScrollRect = require "Framework.UI.Component.UIScrollRect"
UIEventTrigger = require "Framework.UI.Component.UIEventTrigger"
UIBoxCollider2D = require "Framework.UI.Component.UIBoxCollider2D"
UIScrollView = require "Framework.UI.Component.UIScrollView"
UIHorizontalOrVerticalLayoutGroup = require "Framework.UI.Component.UIHorizontalOrVerticalLayoutGroup"
UICanvasGroup = require "Framework.UI.Component.UICanvasGroup"
UIShadow = require "Framework.UI.Component.UIShadow"
UIDropdown = require "Framework.UI.Component.UIDropdown"
UILayoutElement = require "Framework.UI.Component.UILayoutElement"
UILoopListView2 = require "Framework.UI.Component.UILoopListView2"
UIButton_LongPress = require "Framework.UI.Component.UIButton_LongPress"
HorizontalInfinityScrollView = require "Framework.UI.Component.HorizontalInfinityScrollView"
GridInfinityScrollView = require "Framework.UI.Component.GridInfinityScrollView"
UIScrollPage = require "Framework.UI.Component.UIScrollPage"
UIExtraEffect_TextMeshPro = require "UI.UIExtraEffect.UIExtraEffect_TextMeshPro"
GetHDRIntensity = require "Framework.UI.Component.GetHDRIntensity"
UIEmpty4Raycast = require "Framework.UI.Component.UIEmpty4Raycast"
UIGridLayoutGroup = require "Framework.UI.Component.UIGridLayoutGroup"

-- ui window
UILayer = require "Framework.UI.UILayer"
UIWindow = require "Framework.UI.UIWindow"
UIManager = require "Framework.UI.UIManager"
UIWindowNames = require "UI.Config.UIWindowNames"
UIConfig = require "UI.Config.UIConfig"

-- res
-- ResourcesManager = require "Framework.Resource.ResourcesManager"
-- GameObjectPool = require "Framework.Resource.GameObjectPool"

-- update & time
Timer = require "Framework.Updater.Timer"
TimerManager = require "Framework.Updater.TimerManager"
UpdateManager = require "Framework.Updater.UpdateManager"
-- LogicUpdater = require "GameLogic.Main.LogicUpdater"

MsgDefines = require "Net.Config.MsgDefines"
SFSBaseMessage = require "Net.SFSBaseMessage"
SFSNetwork = require "Net.SFSNetwork"
SFSObject = require("Common.Data.SFSObject")
SFSArray = require("Common.Data.SFSArray")
LoadingView = require "Loading.LoadingView"

LuaDBInterface = require("Common.LuaDBInterface")
-- 聊天初始化
require "Chat.initChat"

-- 单例类初始化
EventManager:GetInstance()
UIManager:GetInstance()
UpdateManager:GetInstance()

-- util 类
--WriteLogUtil = require "Util.WriteLogUtil"--调试用
SoundUtil = require"Util.SoundUtil"
SeasonUtil = require "Util.SeasonUtil"
HeroUtils = require "UI.UIHero2.HeroUtils"
GoToUtil = require "Util.GoToUtil"
GoToResLack = require "Util.GoToResLack"
TimeBarUtil = require "Util.TimeBarUtil"
CommonUtil= require "Util.CommonUtil"
UIUtil = require "Util.UIUtil"
WebUtil = require 'Util.WebUtil'
MarchUtil = require "Util.MarchUtil"
PveUtil = require "Util.PveUtil"
WorldBuildUtil = require "Util.WorldBuildUtil"
CSharpCallLuaInterface = require "Util.CSharpCallLuaInterface"
BuildingUtils = require "Util.BuildingUtils"
WorldAllianceBuildUtil = require"Util.WorldAllianceBuildUtil"
SceneUtils = require "Util.SceneUtils"
CrossServerUtil = require "Util.CrossServerUtil"
SexUtil = require "Util.SexUtil"

DOTween = CS.DG.Tweening.DOTween
Screen = CS.UnityEngine.Screen
Setting = CS.GameEntry.Setting

HeroAdvanceController = require "UI.UIHero2.UIHeroAdvance.HeroAdvanceController"

PlaceAllianceCenterEffectManager = require "Scene.PlaceAllianceCenterEffect.PlaceAllianceCenterEffectManager"

WorldCityTipManager  = require "Scene.WorldCityTip.WorldCityTipManager"

WorldAlCenterSelectEffectManager = require "Scene.PlaceAllianceCenterEffect.WorldAlCenterSelectEffectManager"
WelfareController = require "DataCenter.WelfareData.WelfareDataMgr"

BuildFireEffectManager = require "Scene.BuildFireEffect.BuildFireEffectManager"

BuildBloodManager = require "Scene.BuildBloodTip.BuildBloodManager"

BuildLabelTipManager = require "Scene.BuildLabel.BuildLabelTipManager"
CityDomeProtectEffectManager =require "Scene.CityDomeProtectEffect.CityDomeProtectEffectManager"
DragonEffectManager = require "Scene.DragonEffectManager.DragonEffectManager"
WorldMarchTileUIManager = require "Scene.WorldMarchTileUI.WorldMarchTileUIManager"
WorldMarchEmotionManager = require "Scene.WorldMarchEmotion.WorldMarchEmotionManager"

TroopHeadUIManager = require "Scene.TroopHeadUI.TroopHeadUIManager"
WorldTroopTransIconManager = require "Scene.WorldTroopTransIcon.WorldTroopTransIconManager"
WorldTroopAttackBuildIconManager = require "Scene.WorldTroopAttackBuildIcon.WorldTroopAttackBuildIconManager"
TroopNameLabelManager = require "Scene.TroopNameLabel.TroopNameLabelManager"

WorldArrowManager = require "Scene.WorldArrow.WorldArrowManager"

WorldCanBuildEffectManager = require "Scene.WorldCanBuildEffect.WorldCanBuildEffectManager"
NoticeTipsManager = require "Scene.NoticeTipsManager.NoticeTipsManager"
AllianceBuildBloodManager = require "Scene.AllianceBuildBloodTip.AllianceBuildBloodManager"
MonsterRewardBoxEffectManager = require "Scene.MonsterRewardBoxEffect.MonsterRewardBoxEffectManager"
WorldBattleBuffManager = require "Scene.WorldBattleBuff.WorldBattleBuffManager"
WorldBattleSiegeEffectManager = require "Scene.WorldBattleSiegeEffect.WorldBattleSiegeEffectManager"
WorldBattleDamageDesManager = require "Scene.WorldBattleDamageDes.WorldBattleDamageDesManager"
WorldBattleMineDamageManager = require "Scene.WorldBattleMineDamage.WorldBattleMineDamageManager"
-- 砍伐相关
PveActorMgr = require "Scene.BattlePveModule.PveActorMgr"

WorldBuildHeadUIManager = require "Scene.WorldBuildHeadUI.WorldBuildHeadUIManager"
WorldBossBloodTipManager = require "Scene.WorldBossBloodTip.WorldBossBloodTipManager"
AllianceBossBloodTipManager = require "Scene.AllianceBossBloodTip.AllianceBossBloodTipManager"
WorldMonsterBloodTipManager = require "Scene.WorldMonsterBloodTip.WorldMonsterBloodTipManager"
WorldNewsTipsManager = require"Scene.WorldNewsTip.WorldNewsTipsManager"
WorldDesertEffectManager = require"Scene.WorldDesertEffect.WorldDesertEffectManager"
AllianceCityRangeEffectManager = require"Scene.AllianceCityRangeEffect.AllianceCityRangeEffectManager"
WorldDesertBattleManager = require"Scene.WorldDesertBattle.WorldDesertBattleManager"
AllianceActMineBloodManager = require"Scene.AllianceActMineBloodManager.AllianceActMineBloodManager"
ThroneBloodManager = require"Scene.ThroneBloodManager.ThroneBloodManager"
WorldDesertLevelUpManager = require"Scene.WorldDesertLevelUpManager.WorldDesertLevelUpManager"
WorldDesertSelectEffectManager = require"Scene.WorldDesertSelect.WorldDesertSelectEffectManager"
DragonRangeEffectManager = require"Scene.DragonRangeEffect.DragonRangeEffectManager"
Sound3DEffectManager = require"Scene.Sound3DEffectManager.Sound3DEffectManager"
WorldTroopStateBase = require"Scene.WorldTroopManager.TroopState.WorldTroopStateBase"
WorldTroopManager = require"Scene.WorldTroopManager.WorldTroopManager"
WorldTroopLineManager = require"Scene.WorldTroopLineManager.WorldTroopLineManager"
--lua DataTable
LuaDataTableDefine = require "LuaDatatable.Config"
-- PB配置
PBController = require "Net.Proto.PBController"
MailShowHelper = require "DataCenter.MailData.MailShowHelper"
Base64 = require "Framework.Common.base64"

-- LUA全局数据
LuaEntry = require "DataCenter.Global.LuaEntry"

PosConverse = require "Common.PosConverse"


ArrowTipTemplate = "DataCenter.ArrowTipManager.ArrowTipTemplate"

ApsRandom = require "Common.ApsRandom"
StringPool = require "Common.StringPool"
ObjectPool = require "Common.ObjectPool"

OpBase = require "DataCenter.DesertOperate.Ops.Base.OpBase"
OpMasterySkillBase = require "DataCenter.DesertOperate.Ops.Base.OpMasterySkillBase"
WorldPointObject = require "DataCenter.WorldPointManager.WorldPointObject"
WorldDetectEventItemObject = require "DataCenter.WorldPointManager.WorldDetectEventItemObject"
DecorationUtil = require "UI.UIDecoration.DecorationUtil"
EquipmentConst = require "DataCenter.EquipmentManager.EquipmentConst"
EquipmentUtil = require "DataCenter.EquipmentManager.EquipmentUtil"
HeroEvolveController = require "UI.UIActivityCenterTable.Component.HeroEvolve.HeroEvolveController"
MissileAttackEffectManager = require "Scene.MissileAttackEffect.MissileAttackEffectManager"
VitaDefines = require "DataCenter.Vita.VitaDefines"
VitaUtil = require "DataCenter.Vita.VitaUtil"
WayPointUtil = require "DataCenter.CityResident.WayPointUtil"
CityResidentDefines = require "DataCenter.CityResident.CityResidentDefines"

HeroEquipUtil = require "DataCenter.HeroEquipManager.HeroEquipUtil"
HeroEquipConst = require "DataCenter.HeroEquipManager.HeroEquipConst"

BuildTopBubbleManager = require "Scene.BuildTopBubble.BuildTopBubbleManager"