
--[[
-- 只读数据类
--]]

--为使一些在页面中使用的固定值不反复注册，把这些值写在这里（例如 颜色值，缩放默认值）

Const_Color_Green = Color32.New(211/255.0, 245/255.0, 93/255.0, 1)
Const_Green_Outline = Color32.New(79/255.0, 110/255.0, 19/255.0, 1)
Const_Color_Red = Color32.New(1, 126/255.0, 78/255.0, 1)
Const_Red_Outline = Color32.New(152/255.0, 17/255.0, 17/255.0, 1)
Const_Color_Gray = Color32.New(124/255.0, 124/255.0, 124/255.0, 1)

CityLabelTextColor_Green = Color.New(181/255,248/255,49/255,255/255)
CityLabelTextColor_Blue = Color.New(84/255,196/255,242/255,255/255)
CityLabelTextColor_White = Color.New(228/255,228/255,228/255,255/255)
CityLabelTextColor_Yellow = Color.New(255/255,133/255,39/255,255/255)
CityLabelTextColor_Red = Color.New(252/255,81/255,77/255,255/255)
CityLabelTextColor_Purple = Color.New(167/255,108/255,240/255,255/255)

ResetScale = Vector3.New(1, 1, 1)
ResetPosition = Vector3.New(0, 0, 0)
ResetRotation = Quaternion.Euler(0, 0, 0)
WhiteColor = Color.New(1,1,1,1)
RedColor = Color.New(239/255.0, 87/255.0, 87/255.0, 1)
BlackColor = Color.New(0,0,0,1)
BrownColor = Color.New(0.4196,0.2980,0.2393,1)
GrayColor = Color.New(0.45,0.45,0.45,1)
OrangeYellowColor = Color.New(1,0.5,0,1)
LightGreenColor =Color.New(164/255.0, 249/255.0, 42/255.0, 1)
GreenColor = Color.New(90/255.0, 145/255.0, 66/255.0, 1)
FalseVisiblePos = Vector3.New(10000, 1000, 0)
OrangeColor = Color.New(0.63,0.44,0.12,1)
BlueColor = Color.New(0.1529,0.7464,0.5490,1)
DarkBlueColor = Color.New(0.24,0.42,0.71,1)
PinkColor = Color.New(1, 0.8902, 0.7922, 1)
MessageBarLackColor = Color.New(0.5647,0.1529,0.1529,1)
MessageBarCostColor =  Color.New(1,0.8666,0.6745,1)
MessageBarGetColor = Color.New(1,0.8666,0.6745,1)
YellowBtnShadowLightColor = Color.New(0.5568628,0.2470588,0.09411765,1)
GreenBtnShadowLightColor = Color.New(0.3098039,0.4313726,0.07450981,1)
YellowBtnShadowGrayColor = Color.New(0.372549,0.372549,0.372549,1)
description1_color = Color.New(0.9176471,0.5764706,0.372549,1)
DetectEventWhiteColor = Color.New(0.74509,0.71764,0.75294,1)
DetectEventGreenColor = Color.New(30/255.0, 155/255.0, 97/255.0, 1)
DetectEventBlueColor = Color.New(0.37254,0.63921,0.92941,1)
DetectEventPurpleColor = Color.New(0.65098,0.42352,0.94117,1)
DetectEventOrangeColor = Color.New(0.98039,0.53333,0.26274,1)
DetectEventGoldenColor = Color.New(0.98823,0.80392,0.21960,1)
DetectEventRedColor = Color.New(239/255.0, 87/255.0, 87/255.0, 1)
YellowColor = Color.New(1,0.909,0)

WorldGreenColor32 = Color32.New(181,248,49,255)
WorldWhiteColor32 = Color32.New(253,255,248,255)
WorldRedColor32 = Color32.New(239,87,87,255)
WorldYellowColor32 = Color32.New(255,133,39,255)
WorldBlueColor32 = Color32.New(84,196,242,255)
WorldPurpleColor32 = Color32.New(167,108,240,255)

ScienceNameUnlockColor = Color.New(0.72, 0.4, 0.19)
ScienceNameLockColor = Color.New(0.8, 0.87, 0.92)

WorldGreenColor = Color.New(164/255.0, 249/255.0, 42/255.0, 1)
WorldWhiteColor = Color.New(0.99215, 1, 0.972549,1)
WorldRedColor = Color.New(239/255.0, 87/255.0, 87/255.0, 1)
WorldBlueColor = Color.New(0.3294, 0.768627, 0.949,1)
WorldYellowColor = Color.New(1, 0.5215, 0.1529,1)
WorldPurpleColor = Color.New(0.65098,0.42352,0.94117,1)

ChatColorAlliance = Color.New(0.42745, 0.84313, 1,1)
ChatColorNormal = Color.New(1, 1, 1,1)
AllianceColor = "#6DD7FF"

NilValue = "nilValue" --用于保存nil 但是直接写会出错 (灰色材质使用)
TipDefaultTime = 3
HospitalItemImageName= "Assets/Main/Sprites/SoldierIcons/SoldierIcons_injuried_1"
DragDuring = 100 --用来判断循环滑动是否是新一轮滑动
SelectTextColor = Color.New(0,0.15,0.37,1)
ButtonRedTextColor = Color.New(251/255, 59/255, 59/255, 1)
LeftEulerAngles = Vector3.New(0, 0, -90)
RightEulerAngles = Vector3.New(0, 0, 90)
FlipEulerAngles = Vector3.New(0, 0, 180)
ResetEulerAngles = Vector3.New(0, 0, 0)
WorldRightEulerAngles = Vector3.New(0, -90, 0)
WorldLeftEulerAngles = Vector3.New(0, 90, 0)
WorldUpEulerAngles = Vector3.New(0, 180, 0)
WorldDownEulerAngles = Vector3.New(0, 0, 0)
BuildGrayColor = Color.New(0.72,0.72,0.72,1)
AllianceHelpSelfTabColor = Color.New(0.9528302,0.7125727,0.3280972,0.8)
MIN_NAME_CHAR = 3
MAX_NAME_CHAR = 12
ITEM_RENAME = 200021
OneWeekTime = 604800
OneDayTime = 86400 --24 * 3600
OneHourTime = 3600 --24 * 3600
OneMinTime = 60 --24 * 3600
LevelMod = 100 --取配置中去掉等级的基础值

Max_Build_Level = 25
TextShowInterVal = 0.2 --文字增加间隔
SliderShowTime = 800--动画逐渐达到数量

DefaultUserHead = "Assets/Main/Sprites/UI/Common/New/Common_icon_player_head_big";
DefaultImage = "Assets/Main/Sprites/BuildIconOutCity/pic401000_2_free.png";
Item_default = "Assets/Main/Sprites/UI/CommonDefault/item_default";

LongMaxValue = 9223372036854775807
LongMinValue = -9223372036854775808
IntMaxValue = 2147483647
IntMinValue = -2147483648
ShortMaxValue = 32767
ShortMinValue = -32768
ByteMaxValue = 127
ByteMinValue = -128

EffectScreenToWorldDis = 15
EffectFlyResourceTime = 1
BlockPos = Vector3.New(0, -1.2, 1)
WorldUIScale = Vector3.New(0.01,0.01,0.01)
WorldUIEuler = Vector3.New(30,0,0)
LookAtFocusTime =  0.4
MoveCityCameraHeight = 53
SecToMilSec = 1000
FlyMoneyCount = 3
DefaultScreen = Vector2.New(1920, 1080)
VecZero = Vector3.zero
VecOne = Vector3.one
FlyGetResourceDelta = Vector3.New(0,2,0)

LargestWarningBallCount = 1
Color32Max = 255

FormationMaxNum = 4
InvestigateTroopMaxNum = 3
QuestRoomId = "questroom_virtualdata"
E_CHAT_COUNTRY_ROOMID = "e_chat_country_roomid"
E_CHAT_ALLIANCE_ROOMID = "e_chat_alliance_roomid"
SaveGuideId = "saveGuideId"
GuideEndId = -1
SaveGuideDoneValue = "1"
GuideStartId = 300001
RadarRoomId = "radarroom_virtualdata"
AlAutoInviteRoomId = "alAutoInvite_roomId"
QuestRoomGroup = "quest"
RadarRoomGroup = "radar"
MaxChapterId = 6
ChatTempPrivateRoomId = "chattemp_privateRoomId"
ChatGMRoomId = "chatGmRoomId"
ChatGMUserId = "10000"
ChatGMUserIcon = "player_head_2"
ChatGMUserCnt = 20
FinalGarbageRewardItemId = "SaveFinalGarbageRewardItemId"
PushIdResourceBuildingFull = 4100003
PushStaminaFull = 4100100
PushTrainArmyFinish = 4100105
PushPlayerBuildFinish = 4100103
PushScienceFinish = 4100104
PushRegisterSecondDay = {[1] = {4100106,4100111,4100116},[2] = {4100107,4100112,4100117},[3] ={4100108,4100113,4100118},[4] = {4100109,4100114,4100119},[5] = {4100110,4100115,4100120}}
FREE_ITEM_ID = 200031
HERO_ADVANCE_BUBBLE_QUALITY = 1
MessageBallShowAfterChapterId = 1
DefaultBackTime = 6500
DefaultBackTime_1 = 5200
HumanPic = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_icon_troop_human"
GuluPic = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_icon_gulu"
RadarPic = "Assets/Main/Sprites/UI/UIMain/UIMainNew/UIMain_btn_radar"
ResSupportPathFindingId = 4020002400000
warFeverAttackInit = 5
GuideCityShowUIMainTop = 3
GuideCityShowUIMainBuildBtn = 1
GuideCanShowBuild = "GuideCanShowBuild"
FirstJoinAllianceValue = "1"
SaveGuideRecommendShow = "SaveGuideRecommendShow"
FreeSpeed = "FreeSpeed"

BindAccountReward = 100

UIRecommendShowShowTime = "showTime"
UIRecommendShowHideTime = "hideTime"
AllianceBornPoint = "allianceBornPoint"--主城迁世界城市聚集点
MaxShowBuildBlockRange = 20

CityTileCount = 100
WorldTileCount = 1000
TileSize = 2
BlockSize = 100
LodArray =
{
    [0] = 0,    --0
    [1] = 150,  --0
    [2] = 250,  --0
    [3] = 400,  --0
    [4] = 600,  --1
    [5] = 1200, --2
    [6] = 2200, --2
    [7] = 5000, --2
}

CityLodArray =
{
    [0] = 0,
    [1] = 25,
    [2] = 30,
    [3] = 50,
    [4] = 60,
    [5] = 65,
    [6] = 70,
    [7] = 150,
    [8] = 300,
    [9] = 1050,
}



GuideClickAutoStopTime = 15
SaveNoShowGarbage = "SaveNoShowGarbage"
SeverErrorCode = "E000000"
InsideOutCityFlag = 0 --0是城外 非0是城内
SpeedUpItemId = 200103
PVECodeItem = 200400
GuideMovieCameraTimeDelta = 0.1
TouchTerrainEffect = "Assets/Main/Prefabs/World/TouchTerrainEffect.prefab"
GuideJumpUnlockBtnChapterId = 1
GuideJumpUnlockBtnType =
{
    UnlockBtnType.Quest,
    UnlockBtnType.Build,
    UnlockBtnType.Resource,
}

FakeBuildUuid = -999
CareerEffect_10302 = 10302--灌溉
ForceTypeTrainAndUpgrade = "ForceTypeTrainAndUpgrade"
ForceTypeInjured = "ForceTypeInjured"
FiveStarTaskId = "2900101"

ScreenAllianceBirthCount = 3
SaveNoSendPlaceBuild = "SaveNoSendPlaceBuild"


DelayCreateTime = 0.02--延时创建
ShowGreenMaxNum = 6
BeforePrologue = "BeforePrologue" --展示序章
ScienceId_301700 = 301700--现代农业
ScienceId_303000 = 303000--现代化加工
ScienceId_200193 = 200193--现代化畜牧业

AllianceCareerSelfColor = Color.New(0.3607843,0.8156863,0.6509804,1)
SaveErrorProloguePara = "SaveErrorProloguePara" --展示序章发生错误做的引导参数

SliderMaxImage = "Assets/Main/Sprites/UI/Common/Common_pro_green"
SliderNormalImage = "Assets/Main/Sprites/UI/Common/Common_pro_yellow"
SpaceManExtraNum = "SpaceManExtraNum"
MaxPuzzlePerStage = 9

DefaultPveLevelType = PveLevelType.NormalLevel

AllianceFlagBgChoiceCount = 9
AllianceFlagFgChoiceCount = 9

DefaultNation = "UN"
CreateAllianceCostGold = 500
AllianceInviteTipDefault = "391091"
AllianceAbbrLength = 3

BuildLevelCap = 1000
ScienceLevelCap = 100

AllianceMemberRankCount = 4

MineCavePveLevelId = 25001
TestPveBattleLevelId = 10002
BattlePlayBackLevelId = 26001

ActivitySummaryPveActId = 320001
ArenaTicketId = "210157"
ArenaSetTeamLevelId = 25002--25001--已废弃
ArenaBattleLevelId = 25003--25001--已废弃
SceneTouchDistance = 1000
GuideNoShowRadarBubble = "GuideNoShowRadarBubble"
GuideNoShowCollectPoint = "GuideNoShowCollectPoint"--引导控制不显示世界上采集垃圾点
--GUIDE_OPEN_BUBBLE_MAIN_CITY_LEVEL = 8
Purple_Poster_Hero_Show_AdvanceFlag_Need_Master_Level = 9 --紫色英雄本地9级前，海报不显示提示箭头和红点
GuideNeedLoadScene = "GuideNeedLoadScene" --引导重登需要加载的场景表现
Poster_Show_Bubble_Quality = 2
SearchMonsterInGarbage = "SearchMonsterInGarbage" --第一次搜索怪在车库附近
SearchMonsterInGarbageRange = 4

local ConstDefine = {

}

ThemeActivityNoticeDays = 3
ChristmasCelebrateActivityId = "70006"
ChristmasCumulateRechargeId = "100025"

LeagueMatchGroupAllianceCount = 16

LINEUP_DEFAULT_MONSTER = 106000
PveBuyAttackShopArrowShowTime = "PveBuyAttackShopArrowShowTime" --pve中购买商店显示手的次数
GuideBgmName = "GuideBgmName" --引导播放特殊的Bgm
DirectionLeft = Vector3.New(-1,0,0)
DirectionRight = Vector3.New(1,0,0)
DirectionTop = Vector3.New(0,0,1)
DirectionDown = Vector3.New(0,0,-1)
RightQuaternion = Quaternion.AngleAxis(90, Vector3.up)
LeftQuaternion = Quaternion.AngleAxis(-90, Vector3.up)
HeroBagCellNumPerLine = 6

BuildPutType =
{
    Default = 0,
    Lv0 = 1,
}

MasteryLvCap = 100

BlackFogColor = Color.New(0.04313726,0.01176471,0.003921569,1)
WhiteFogColor = Color.New(1,1,1,1)

AlContributeItemId = "222020"

LackHeroExpPerRow = 5
FakeAttackPos = Vector3.New(100, 0, 100)
RadarDetectEventFillFullItemId = 200068
RadarDetectEventFillFullPackage = "230115001"
ScoutMailShowTime = 1800000--侦查邮件1800秒内可以跳转
HeroExpLevelPromoteHeroId = 1003
HeroIntensifyLevelCap = 1000
GotoWorldLodOneMaxZoom = 55--世界lod第一层最大高度
SevenAllianceCityWorldPos = Vector3.New(1000,0,1000)--世界七级城右上点
SevenAllianceCityCenterWorldPos = Vector3.New(993,0,993)--世界七级城中心点
SpecialRankNum = 3

TabNoMoveSelectColor= Color.New(0.7176492,0.3764706,0.07843138,1)--通用不移动Toggle未选中颜色
TabNoMoveUnSelectColor= Color.New(0.5490196,0.6980392,0.9764706,1)--通用不移动Toggle选中颜色


TextColorStr = "<color=%s>%s</color>"
TextColorRed = "#fb3b3b"
TextBtnColorRed = "#fb3b3b"
TextColorGreen = "#5A9142"
TextColorGreenLight = "#a4f92a"

TextQualityColorWhite = "#bca396"
TextQualityColorGreen = "#91ba2e"
TextQualityColorBlue = "#4fa7f8"
TextQualityColorPurple = "#f265ff"
TextQualityColorOrange = "#ff7e30"
TextQualityColorGold = "#ffde46"

MarchSpeedItemId = 251113

TabUnSelectColor= Color.New(0.7176492,0.4000111,0.1882272,1)--通用Toggle未选中颜色
TabSelectColor= Color.New(1,1,1,1)--通用Toggle选中颜色
TabSelectShadow= Color.New(0.5019544,0.2196068,0.09411807,1)--通用Toggle未选中阴影颜色
TabUnSelectHeightVec = Vector2.New(0, 0)--通用Toggle未选中位移
TabSelectHeightVec = Vector2.New(0, 7)--通用Toggle选中位移

THRONE_ID = 48 --王座Id

GolloBoxItemId = 23000

QualityColorWhite= Color.New(0.7372549, 0.6392157, 0.5882353, 1)--蓝色品质颜色
QualityColorBlue= Color.New(0.3098039, 0.654902, 0.972549, 1)--蓝色品质颜色
QualityColorGreen= Color.New(0.6431373, 0.9764706, 0.1647059, 1)--绿色品质颜色
QualityColorPurple= Color.New(0.9490196, 0.3960784, 1, 1)--紫色品质颜色
QualityColorYellow= Color.New(1, 0.4941176, 0.1882353, 1)--橙色品质颜色
QualityColorGold= Color.New(1, 0.8705882, 0.2745098, 1)--金色品质颜色

MoveTabColorSelect = Color.New(0.8156863, 0.4078431, 0.1960784, 1)--可移动通用Tab选中颜色
MoveTabColorUnSelect = Color.New(0.8431373, 0.572549, 0.3294118, 1)--可移动通用Tab选中颜色
UseOmitBtnStr = "..."
HeroPluginUpgradeShowAnimTime = 0.2
HeroPluginUpgradeShowMaxAnimTime = 0.4
NextFrameTime = 0.000001--下一帧时间
HeroMaxLevel = 100--英雄最大等级
MarchEffectDefaultPD = "WorldTroopEffect_PD_Default"--炮弹特效名字
MarchEffectDefaultPK = "WorldTroopEffect_PK_Default"--炮口特效名字
MarchEffectDefaultHit = "WorldTroopEffect_Hit_Default"--被攻击特效名字
MarchEffectDefaultHeight = 7--炮弹飞行高度
ShowLevelMax = 100--突破最大等级
MarchPrefabDefaultNameSelf = "WorldTroop"--运兵车默认预制体(绿色)
MarchPrefabDefaultNameAlliance = "WorldTroopAlliance"--运兵车默认预制体(蓝色)
MarchPrefabDefaultNameCamp = "WorldTroopYellow"--运兵车默认预制体(黄色)
MarchPrefabDefaultNameOther = "WorldTroopOther"--运兵车默认预制体(红色)
TrainFreeSpeed = "TrainFreeSpeed"--造兵免费加速
TrainFreeSpeedSecond = 3 --第一次造兵写死3秒
FurnitureIndex = 1 --家具初始index
NormalPanelAnim =  { anim = true, UIMainAnim = UIMainAnimType.LeftRightBottomHide }
NormalBlurPanelAnim =  { anim = true, UIMainAnim = UIMainAnimType.LeftRightBottomHide, isBlur = true}
HideBlurPanelAnim =  { anim = true, UIMainAnim = UIMainAnimType.AllHide, isBlur = true}
DefaultBuildModelName = "building_401000"
TimePositionDelta = Vector3.New(0, 0, 1.3)
CityBuildHideMarkLod = 2--建筑不显示盖子lod等级
CityBuildShowMarkLod = 4--建筑显示盖子lod等级
GuideTopTipAutoCloseTime = 5--顶部文字提示自动关闭时间
NoShowRandomZombie = "NoShowRandomZombie"--不显示随机僵尸
BuildEnterTime =  0.4
BuildEnterMinTime =  0.4
BuildEnterMaxTime =  0.6
BuildQuitTime =  0.4
BuildEnterMovePerZoomTime = 0.02
BuildEnterMoveZoom = 14
ScreenDefaultWidth = 750
FreeLeaseSecondBuildQueue = "FreeLeaseSecondBuildQueue"--免费租赁第二建造队列
ModfRange =  0.01
HeroExpResFlag = 100002
LackItemDefaultBg = "Assets/Main/Sprites/UI/Common/New/Common_bg_item_supple1"
WaitStartNextStorm = "WaitStartNextStorm"--等待召唤下一个暴风雪
PanelArrowTime =  0.4--有动画导致取位置不对
BuildAutoMoveEnterTime = 0.45
DefaultAlphaIcon = "Assets/Main/Sprites/UI/Common/Common_alpha.png"--透明图片，解决一切白图问题
DrakeBossDistance = 50 --半径超50格，在召唤一个
ArrowAutoCloseTime = 3--手指自动关闭时间
HireHeroUuid = -1
CanShowLand = "CanShowLand"--显示地块
GearItemId = 200034--齿轮id
WaitTipsTime = 2--

-- LW PVE
PUNCH_CD = 0.3
-- LW PVE end
SaveWaitTrigger = "SaveWaitTrigger"--保存等待触发的引导
GuideMaxTime = 999999--引导最大时间
ResidentModelEmojiHeight = 0.6--小人表情和说话偏移
TimelineCameraRotation = Quaternion.Euler(48.8, -10, 0)--timeline镜头旋转角度
TimelineCameraRotationY = -10--timeline镜头旋转角度
AllianceScienceShowRedCount = 10--联盟科技可以显示红点
HeroRecruitTenCount = 3--剩余抽数不足N连抽时，改为等于剩余抽数的连抽

BuildRepairTime = 5

PrintSpeed = 0.04--正常打印速度
PrintAddSpeed = 0.008--加速打印速度

SpeedLackType = 100003

--地块表现
LandZoneFlipPerBlockTime = 0.3--地块翻转每一个地格间隔时间
CityWallFallInterval = 0.08--栅栏动画出现间隔时间
--

CameraZoomCotY = 0.875 --cot(48.8)
CameraSensitivity = 50

BuildBubbleBgScale = Vector3.New(0.43, 0.43, 0.43)

CityWallRepairGroupIds =
{
    [1] = { 9, 10, 11, 15, 16, 17 },
    [2] = { 21, 22 },
    [3] = { 24, 25, 26, 27, 28, 29, 30, 31 },
}

return ConstClass("ConstDefine", ConstDefine)