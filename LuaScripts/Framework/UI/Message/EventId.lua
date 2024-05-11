

local EventId = {
	None = 0,
	ResourceUpdated = 1,
	OpenUIFormSuccess = 2,
	OpenUIFormFail = 3,
	CloseUIForm = 4,
	ElectricityLack = 5,
	PlayerInfoUpdated = 6,
	UpdateFiveStarReward = 7,
	UpdateBankruptcy = 8,
	DoneBankruptcy = 9,
	PlayerPowerInfoUpdated = 10,
	ServerError = 11,
	BuildPlace = 12,
	BuildUpgradeStart = 13,
	BuildUpgradeFinish = 14,
	TransportFinish = 15,
	CheckActivityRedPoint = 16,
	BuildResources = 17,
	PushCreateBuildingOneHeart = 18,
	TrainArmyData = 19,
	TrainingArmy = 20,
	TrainingArmyFinish = 21,
	ResourceTransport = 22,
	HeroicRecruitmentData = 23,
	WorldMarchFormatiomData = 24,
	WorldMarchCount = 25,
	WorldMarchChristmas = 26,
	HospitaiStart = 27,
	HospitalHelp = 28,
	HospitalFinish = 29,
	HospitalTimeEnd = 30,
	HospitalUpdate = 31,
	DesertHospitalShowSpeedBtn = 32,
	HospitalEffectEnd = 33,
	ModeReward = 34,
	RepairNeedMessage = 35,
	ArmyFormationSave = 36,
	ChapterTask = 37,
	QuestNoteBookRedCount = 38,
	LineSpine = 39,
	ActiveGuide = 40,
	BuyAndUseItemSuccess = 41,
	forgingSuccess = 42,
	UseItemSuccess = 43,
	AddSpeedSuccess = 44,
	AllianceHelpAddSpeed = 45,
	DailyQuestSuccess = 46,
	MainTaskSuccess = 47,
	AllianceChangeNameSuccess = 48,
	AllianceChangeAbbrSuccess = 49,
	SearchAllianceSuccess = 50,
	AllianceMember = 51,
	KingSearchPlayerList = 52,
	PlayerMessageInfo = 53,
	AllianceHelp = 54,
	AllianceHelpSever = 55,
	AllianceShopShow = 56,
	AllianceMemberRedPoint = 57,
	AllianceInfoRefresh = 58,
	AllianceApplySuccess = 59,
	AllianceCreateSuccess = 60,
	AllianceApplyCancel = 61,
	AllianceTechnology = 62,
	AllianceScienceDonate = 63,
	KickOutAllianceMember = 64,
	AllianceSettingUpdate = 65,
	AllianceAcceptInvite = 66,
	AllianceEvent = 67,
	AllianceWarUpdate = 68,
	ShowTruckIcon = 69,
	ShowMainUIPart = 70,
	RefreshPieceInterface = 71,
	CloseActiveSkillUseUI = 72,
	CloseGarrisonTip = 73,
	OpenInvestmentPanel = 74,
	MarchTimeSync = 75,
	ActiveSkillNode = 76,
	RefreshSkillUseUI = 77,
	RefreshActiveSkillUseUI = 78,
	PlayFragBuySuccessAnim = 79,
	PlayShopBuySuccessAnim = 80,
	ShopBuyAnimEnd = 81,
	MoveUpFragShopPanel = 82,
	ZombieUnLockAddTransporter = 83,
	NewUserAreaUnLock = 84,
	UserAreaUnLock = 85,
	CenterDailyReward = 86,
	CenterDailyRewardRedDot = 87,
	CargoReward = 88,
	CloseAlliancePanel = 89,
	MoveWorldCity = 90,
	WorldScoutDetail = 91,
	WorldPointDetail = 92,
	WorldOccupiedTroops = 93,
	WorldCollectPointDetail = 94,
	WorldOccupiedKick = 95,
	WorldMarchGetDetail = 96,
	RefreshBookmark = 97,
	ChangeBookmarkItemState = 98,
	GuidePreloadFinish = 99,
	RequestWorldMarchDetail = 100,
	ArmyUpgrade = 101,
	ArmyUpgradeStart = 102,
	ArmyFormatUpdate = 103,
	GetAllianceWarArrayEvent = 104,
	GetAllianceWarAtkInfoEvent = 105,
	GetAllianceWarDefInfoEvent = 106,
	AllianceWarCancelEvent = 107,
	AllianceWarIgnore = 108,
	AllianceWarLogEvent = 109,
	RefreshAllianceGift = 110,
	UpdateAllianceGiftNum = 111,
	UpdateAllianceHelpNum = 112,
	RetGetRewardEvent = 113,
	AllianceGiftShowChangeAni = 114,
	RetGiftInfoEvent = 115,
	TerritoryUpdateInfo = 116,
	TerritoryContri = 117,
	TerritoryStateChange = 118,
	ShowUseResTool = 119,
	TerritoryDetail = 120,
	OccupiedMarchKick = 121,
	AlliancebuildEditor = 122,
	ChangeTerritoryInfo = 123,
	GetAllianceComments = 124,
	AllianceSendComment = 125,
	TalentPointChange = 126,
	MsgDesertSkillUseRefresh = 127,
	EndStudyTalent = 128,
	HidePutWorldBuildUI = 129,
	RefreshUpdateStone = 130,
	DomainDefenceValue = 131,
	UpdateCrossServerPermission = 132,
	DomainFightRewardInfo = 133,
	DomainBuildInfo = 134,
	WBProductNeedTime = 135,
	WorldBuildInfoUpdate = 137,
	WorldBuildRepair = 138,
	WorldBuildFinishRepair = 139,
	WorldBuildRepairInfo = 140,
	WorldMarchRepeat = 141,
	EnemyInfoListChange = 142,
	CityDefend = 143,
	CityDefendIndex = 144,
	TroopAssistance = 145,
	UIRefreshAssistanceDetailInfo = 146,
	FightToMonster = 147,
	BuildingAppointhero = 148,
	UpdateMarchEntityInfo = 149,
	UpdateWorldMapInfo = 150,
	UpdateMarchSpeedUp = 151,
	BuyItemSuccess = 152,
	UpdateNewChatInfo = 153,
	FightReport = 154,
	RequestAllianceSoldier = 155,
	GetUserInfo = 156,
	PushWorldMarchInfo = 157,
	PaymentCompleted = 158,
	PaySuccess = 159,
	HeroGrowReward = 160,
	RequestWeekCardData = 161,
	WEEK_REFRESH_VIEW = 162,
	BattleStartOver = 163,
	BattleBeAttackPost = 164,
	BattleAddAttackEffect = 165,
	BattleAddBulletAttackEffect = 166,
	BattleAddMissileAttackEffect = 167,
	BattleAddPoisonEffect = 168,
	BattleUpdateSodierNum = 169,
	BattleAddMaraleEffect = 170,
	BattleWarningTipFinish = 171,
	BattleShackScreen = 172,
	BattleAddSkillState = 173,
	BattleAddSkillEffect = 174,
	BattleAddStateIdEffect = 175,
	BattleShowTroopSkill = 176,
	BattleMoveForward = 177,
	BattleOfficerCellShine = 178,
	BattleOfficerCellCancelShine = 179,
	BattleShowGlow = 180,
	BattleAddPoisonIcon = 181,
	MSG_ADD_STATE = 182,
	MSG_SHOW_AOE_EFFECT = 183,
	MSG_UPDATE_STATE = 184,
	MSG_SHOW_AOE_MASK = 185,
	MSG_SHOW_STATUS_EFFECT = 186,
	MSG_ADD_POISON_ICON = 187,
	AccountBindEvent = 188,
	AccountBindOKEvent = 189,
	AccountChangeEvent = 190,
	AccountChangePwdEvent = 191,
	AccountResendMailEvent = 192,
	AccountChangeMailEvent = 193,
	AccountNewEvent = 194,
	NickNameChackEvent = 195,
	NickNameChangeEvent = 196,
	MoodInfoChangeEvent = 197,
	PinInputReset = 198,
	PinInputClose = 199,
	PinInputNext = 200,
	PinForgetPwd = 201,
	PinInitFinish = 202,
	MSG_INIT_ACTIVITY_EVENT = 203,
	DayChange = 204,
	GetActivityDetail = 205,
	ActivityCellRefresh = 206,
	MsgFreshSingleScoreView = 207,
	MsgFreshSingleScoreRankView = 208,
	RefreshDataSingleScore = 209,
	RefreshRwdData = 210,
	RefreshSingleScoreUI = 211,
	MsgScoreRankHistoryView = 212,
	DesertMummyRankData = 213,
	GetRewardInfo = 214,
	MsgUpdateActivityEvent = 215,
	MsgAllianceMigrationRefreshData = 216,
	MsgAllianceMigrationPopupRefreshData = 217,
	MsgGetAllianceArmsDifficulty = 218,
	MsgUpdateAllianceArmsUI = 219,
	MsgUpdateAllianceArmsRankUI = 220,
	MsgRefreshChampBattleView = 221,
	EliteNewAddbet = 222,
	EliteNewBetInfo = 223,
	EliteNewAllocateUpdate = 224,
	MsgChampBattleAllocateCell = 225,
	MsgKingGiftUserList = 226,
	MsgKingGiftUpdateContact = 227,
	MsgOfficerPosition = 228,
	MsgOfficerCellUpdate = 229,
	MsgUpdateKingdomFlag = 230,
	MsgUpdatePresidentHistory = 231,
	MsgUpdateLaunchBoxHistory = 232,
	DRAW_VIEW_UPDATE = 233,
	DRAW_SELF_VIEW_UPDATE = 234,
	DRAW_RESULT_VIEW_UPDATE = 235,
	DRAW_RESULT_VIEW_UPDATE_1 = 236,
	ZONE_REWARD_RED_POINT = 237,
	DRAW_VS_VIEW_UPDATE = 238,
	ZONE_CONTRIBUTE_RANK_UPDATE = 239,
	CountryTodayViewcheckReward = 240,
	ZONE_INSIDE_RANK_VIEW = 241,
	ACTIVITY_THEME_CHANGE = 242,
	REFRESH_SINGLE_HEAD_VIEW = 243,
	ZONE_OUT_LOOK_REFRESH = 244,
	ZONE_WARMUPTODAT_RANK = 245,
	ZONE_WARMUPACCUMULATE_RANK = 246,
	ZONE_HISTORY_RANK = 247,
	ALLIANCE_ACTIVITY_INFO = 248,
	ALLIANCE_ACTIVITY_REWARD = 249,
	ALLIANCE_REWARD_RANK = 250,
	PERSONAL_REWARD_RANK = 251,
	DRAW_PIRZE_VIEW_UPDATE = 252,
	MSG_FRESH_SINGLE_SCORE_RANK_VIEW = 253,
	ZONE_GET_CHOOSE_REFRESH = 254,
	ZONE_GET_CHOOSEINFO_REFRESH = 255,
	ZONE_ACTIVITY_DETAIL_EXTEND = 256,
	ZONE_VIEW_CHOOSE_STATE = 257,
	ZONE_WARMUP_RANKING_PRIZE_REFRESH = 258,
	MsgKingdomOfficers = 259,
	MsgUpdateCommendationView = 260,
	MsgUpdateGiftSelectMemTop = 261,
	MsgUpdateGiftSelectMems = 262,
	MsgHeroLimitedRecruitBoxInit = 263,
	MsgHeroCardInfoEnd = 264,
	MsgHeroSelectHero = 265,
	UPDATE_CHRISTMAS_TREE = 266,
	INFO_CHANGE_COLORFUL_CHRISTMAS_TREE = 267,
	GET_COLORFUL_CHRISTMAS_TREE = 268,
	INFO_CHANGE_CHRISTMAS_GIFT = 269,
	INFO_CHANGE_CONGRATULATION_CRAD = 270,
	CONGRATULATION_CRAD_REWARD = 271,
	MsgServerListBack = 272,
	MsgRepayInfoInit = 273,
	MsgRepayViewShowDes = 274,
	MonthCardGetReward = 275,
	BuyMonthCardSucess = 276,
	MONTHCARD_REFRESH = 277,
	SelectMonthCardReward = 278,
	CLICK_WELFARE_CELL = 279,
	AccConsumeGetReward = 280,
	RefreshActivityCommonView = 281,
	RefreshActivity7View = 282,
	BattlePassChangeData = 283,
	MonthBattlePassChangeData = 284,
	SeasonBattlePassChangeData = 285,
	AllianceConsumeChangeData = 286,
	AllianceConsumeRankList = 287,
	MSG_HOLIDAY_AWARD_INFO = 288,
	NightChange = 289,
	LightChange = 290,
	SkillUpgradeEnd = 291,
	RefreshUnlockSkillCondition = 292,
	HeroMedalSelectEnd = 293,
	CloseHeroUnlockPanels = 294,
	UpdateHeroMedalPanel = 295,
	MsgHeroesInit = 296,
	MsgHeroesUpdate = 297,
	HeroBeDecomposedEnd = 298,
	HeroLevelUpgrade = 299,
	HeroRecruitRefreashFree = 300,
	HeroRecruitRefreashActivity = 301,
	OpenHeroPage = 302,
	CloseJiBanPanel = 303,
	HeroUnLockSkill = 304,
	MerchantItemRefresh = 305,
	MerchantBuyItemSucess = 306,
	ChipCollectSucces = 307,
	CR_UPDATE_SHOW = 308,
	DesertThroneDataBack = 309,
	CrossThroneDataBack = 310,
	ThroneFightInfoDataBack = 311,
	ThroneUIClose = 312,
	WorldTrebuchetAtt = 313,
	UpdateBuildingProtectTime = 314,
	UpdateBuildingResProtectTime = 315,
	UpdateMarchItem = 316,
	AllianceExchangeOptRefresh = 317,
	AllianceExchangeRefresh = 318,
	AllianceSetRankName = 319,
	AllianceDonateRankDay = 320,
	AllianceDonateRankWeek = 321,
	AllianceDonateRankAll = 322,
	GoldBoxRefresh = 323,
	ChangeWorldScene = 324,
	WorldMapCameraChangeZoom = 325,
	RefreshWorldMapUI = 326,
	PlayerRank = 327,
	AllianceRank = 328,
	ResetPositionCity = 329,
	UpdateClonceData = 330,
	UpdateCloneSoldier = 331,
	UpdateCloneDonate = 332,
	CloneDonateListBack = 333,
	CloseDonatePlayerInfoList = 334,
	SearchUserAlliance = 335,
	BuildLandscapeList = 336,
	BuildLandscapeUnLock = 337,
	BuildLandscapeUnDown = 338,
	MissleCostUpdate = 339,
	TrainMissile = 340,
	BeginTrainMissile = 341,
	MSG_FINISH_TRAINING_MISSILE = 342,
	FINISH_TRAINING_MISSILE = 343,
	MSG_MISSILE_DEFENCE_RECORD = 344,
	OpenMissleFromSilo = 345,
	EquipMaterialSceleted = 346,
	PartsEquipMakeStart = 347,
	BuildPartsEquipMakeStart = 348,
	BuildPartsMaterialMakeStart = 349,
	PartsEquipMakeFinished = 350,
	PartsMaterialMergeSuccess = 351,
	EquipMergeComplete = 352,
	Equip_Harvest = 353,
	Material_Harvest = 354,
	EquipPutOnMsg = 355,
	EquipDeleteMsg = 356,
	EquipTakeOffMsg = 357,
	EquipSplitMsg = 358,
	EquipSuitSkillUpdate = 359,
	DestroyMaterial = 360,
	SpineCarUpdate = 361,
	ActiveBg = 362,
	RefreshTruckInfo = 363,
	MailReceiveServerBack = 364,
	MailSaveBack = 365,
	MailPush = 366,
	GetStatusItemSuccess = 367,
	GetProtectBuffRecordSuccess = 368,
	ClashBattleStateUpdate = 369,
	ClashBattleBuildUpdate = 370,
	ClashInfoUpdate = 371,
	ClashBattleBuildUpdateClose = 372,
	ClashInfoPush = 373,
	MsgRefreshExploitShopView = 374,
	MsgRefreshFragmentShopView = 375,
	MsgRefreshOneFragmentInfo = 376,
	RefreshItems = 377,
	ChangeServer = 378,
	DesertSeasonDataBack = 379,
	FBVipUnlock = 380,
	FBVipSlotValue = 381,
	VipStoreRefrsh = 382,
	VipPrivilegeRefrsh = 383,
	MsgVipstoreUpdateExp = 384,
	UpdateVipUpdateLV = 385,
	MsgBuyConfirmOK = 386,
	ItemBuyConfirm = 387,
	ItemBuyAndUseConfirm = 388,
	ItemUseConfirm = 389,
	RefreshFBPrivelege = 390,
	RefreshFBStore = 391,
	ALContributionDataBack = 392,
	ALSetAvoidTimeBack = 393,
	ALGetAvoidTimeBack = 394,
	MSG_QUEUE_REMOVE = 395,
	MSG_UPDATE_MSG_BALL = 396,
	GetMemberPointBack = 397,
	HerolotterRewarInfo = 398,
	MsgAllianceBattleActInfo = 399,
	MsgFreshDoomsView = 400,
	DeclareWar_RefreshData = 401,
	DeclareWar_DeclareWarRetData = 402,
	DeclareWar_BeginDeclareWar = 403,
	DeclareWar_AlWarResult = 404,
	DeclareWar_History = 405,
	DeclareWar_Search = 406,
	materialCreateEnd = 407,
	TalentViewRefreshInfo = 408,
	MsgDomainGiveUpPointsBack = 409,
	MsgMapUpdate = 410,
	MsgDomainCollectEnd = 411,
	MsgMyDomainDataBack = 412,
	UIDesertTileRedDot = 413,
	MsgDomainMineArmyBack = 414,
	WBCrashStatus = 415,
	FBTileSeasonDeclareHisListViewNewData = 416,
	MsgDeclareWarDetail = 417,
	GetUserDomainWarHistory = 418,
	DesertRewardViewRefresh = 419,
	ALBattleEvent = 420,
	DomainForceRankDataBack = 421,
	RefreashBuildUpGrade = 422,
	PartsMaterialTimeDone = 423,
	MsgMakeProductEnd = 424,
	UnBuildUpgradeFinish = 425,
	MsgStopProductEnd = 426,
	MsgColloectProductEnd = 427,
	RelicBuildRebuildSuccess = 428,
	CountryFlagChanged = 429,
	BuyHeroCard = 430,
	AllianceCombineList = 431,
	alliance_combine_details_refresh = 432,
	MsgArmyUserRefresh = 433,
	ResetTreatNum = 434,
	GoToHealthing = 435,
	MsgQueueRemove = 436,
	MsgQueueAdd = 437,
	ArmyNumChange = 438,
	TreatNumChange = 439,
	MsgTroopsChange = 440,
	RefreshCarRepairInterface = 441,
	MsgSpecialSolderUpdate = 442,
	CollectSoldierAddPower = 443,
	UICommonHelpTipsClose = 444,
	UpdateTradingCenterData = 445,
	UpdateTradingCenterCallPlane = 446,
	GetHeadImgUrl = 447,
	UpdateHeadImg = 448,
	LoadGiftFinish = 449,
	GiftBoxRefresh = 450,
	SELECT_USER_GIVE = 451,
	SearchUserGiftBox = 452,
	GiftBoxPeopleSelected = 453,
	OnBuildQueueFinish = 454,
	OnScienceQueueFinish = 455,
	OnScienceQueueResearch = 456,
	Update_Alliance_Gift_Num = 457,
	Translate_Normal = 458,
	Translate_Mail = 459,
	UI_RESOURCE_VISIBLE = 460,
	CHANGE_UIRESOURCE_TYPE_PUSH = 461,
	CHANGE_UIRESOURCE_TYPE_POP = 462,
	CHANGE_UIRESOURCE_TYPE_ALLPOP = 463,
	BuildPowerAdd = 464,
	UpdateGold = 465,
	CLOSE_UIPOPGETHERO = 466,
	MSG_WORLD_BUILD_FREE_NUMBER_CHANGE = 467,
	ClickStateIcon = 468,
	BuildChangeState = 469,
	BUILD_PRODUCE_FAST = 470,
	BUILD_PRODUCE_FAST_BACK = 471,
	BUILD_PRODUCE_FAST_END = 472,
	BUILDING_TURBO_MODE_GET = 473,
	BUILDING_TURBO_MODE_USED = 474,
	BUILD_REPAIR = 475,
	ITEM_COMPOSE_SUCCESS = 476,
	MSG_ITME_STATUS_TIME_CHANGE = 477,
	MSG_FRESH_SURVIVAL_VIEW_GET = 478,
	MSG_FRESH_SURVIVAL_VIEW = 479,
	MSG_FRESH_SURVIVAL_VIEW_MARK = 480,
	MSG_RESPONSED3RDPLATFORM = 481,
	MSG_USER_BIND_CANCEL = 482,
	MSG_USER_BIND_OK = 483,
	RES_TOOL_EXCHANGE_MSG = 484,
	RES_SELL_MSG = 485,
	Immediately_Back_Carport = 486,
	ZOMBIE_CLICK_REWARD = 489,
	GOLDEXCHANGE_LIST_CHANGE = 490,
	GOLDEXCHANGE_LIST_CHANGE_RAND = 491,
	PAYMENT_COMMAND_RETURN = 492,
	CityBattleZombiePreloadFinish = 493,
	ResetMailState = 494,
	OtherPlayInfo = 495,
	GUIDE_INDEX_CHANGE = 496,
	BREAK_SOFT_GUIDE = 497,
	MergeChatMessage = 498,
	ShowMailChatTips = 499,
	Translate_Dialog = 500,
	GUIDE_GOTO_ATTACK_WORKER = 501,
	SendMailDone = 502,
	MailRemoveInChannel = 503,
	REFRESH_MONSTERACTIVITY = 504,
	REFRESH_BASEBUILD = 505,
	REFRESH_BROKEFENCE = 506,
	ShowDialogOriginallan = 507,
	WarTroppShowExplain = 508,
	LoadCityBuildingFinsh = 509,
	UpdateQuickSaveStr = 512,
	RunOutReousrceChipEnergy = 513,
	BackToBaseCar = 514,
	GetReward = 515,
	ClearPolt = 516,
	PLAY_MP4 = 517,
	GetRewardAniPlayEnd = 518,
	CloseUIBuilding = 519,
	PUSH_CLASHEVENT_COMMAND = 520,
	CHAT_TRANSLATE_COMMAND = 521,
	CHAT_BLOCK_COMMAND = 522,
	CHAT_UNBLOCK_COMMAND = 523,
	CHAT_RECIEVE_ROOM_MSG_COMMAND = 524,
	CHAT_UPDATE_ROOM_MSG_COMMAND = 525,
	CHAT_UPDATE_ALLIANCE_ROOM_COMMAND = 526,
	REDPACK_VIEWLOG_COMMAND = 527,
	REDPACK_SELECT_GP_COMMAND = 528,
	REDPACK_BUY_GP_SUCCESS = 529,
	CHAT_SHOW_CONTENT_TIPS_COMMAND = 530,
	CHAT_HIDE_CONTENT_TIPS_COMMAND = 531,
	GOTO_WORLD_POSITION = 532,
	CLOSE_CHAT_UI_COMMAND = 533,
	REDPACK_SHOW_COMMAND = 534,
	CHAT_KEYBOARD_ADJUST_COMMAND = 535,
	CHAT_REQUEST_HISTORY_MSG_RESULT = 536,
	CHAT_SEND_ROOM_MSG_COMMAND = 537,
	CHAT_SEND_ROOM_MSG_SUCCESS = 538,
	CHAT_SEND_ROOM_MSG_FAILURE = 539,
	CHAT_REQUEST_HISTORY_MSG_COMMAND = 540,
	CHAT_ROOM_CREATE_COMMAND = 541,
	CHAT_LEAVE_ROOM_MSG_COMMAND = 542,
	CHAT_ROOM_CHANGE_NAME_COMMAND = 543,
	CHAT_ROOM_OPEN_INVITE = 544,
	CHAT_ROOM_ENABLE_REMOVE = 545,
	CHAT_ROOM_UPDATE_MEMBER = 546,
	CHAT_ROOM_DELETE_MEMBER = 547,
	CHAT_ROOM_INVITE_SHOW_ALLIES_RANK = 548,
	CHAT_ROOM_INVITE_HIDE_ALLIES_RANK = 549,
	CHAT_ROOM_INVITE_USER_TOGGLE_ON = 550,
	CHAT_ROOM_INVITE_USER_TOGGLE_OFF = 551,
	CHAT_ROOM_INVITE_SEARCH_PLAYER_RESULT = 552,
	CHAT_ROOM_INVITE_PLAYER_RESULT = 553,
	CHAT_ROOM_OPEN_BY_GROUP = 554,
	CHAT_ROOM_OPEN_BY_ID = 555,
	CHAT_SEND_VOICE_MSG = 556,
	CHAT_VOICE_PLAY = 557,
	CHAT_VOICE_QUEUE = 558,
	CHAT_RESEND_ROOM_MSG_COMMAND = 559,
	CHAT_REMOVE_ROOM_MSG_COMMAND = 560,
	CloseUIBookMarkAlliance = 561,
	CloseWorldBuildMoving = 562,
	WORLD_MOVE_UP_EFFECT = 563,
	SCIENCECENTERNEW_CHANGE_INDEX = 564,
	CLOSE_SCIENCE_UPGRADE = 565,
	UpdateWorldMark = 566,
	MSG_DRAWRESULT_BACK = 567,
	MSG_AZ_TERRITORY_DETAIL = 568,
	ALLIANCE_ARMYGROUP_DOMAIN_CHECK = 569,
	CloseOtherTerritoryArmyInfoDetail = 570,
	OnEndGarrisonTroopCallBack = 571,
	UpdateTerritoryCenterBuildInfoPage = 572,
	UpdateLegionSettingPage = 573,
	SendChosenLegionTroopForSetting = 574,
	ARMYGROUP_LEADER_MEMBER_REFREH = 575,
	ARMYGROUP_DISPATCH_VIEW = 576,
	ALLIANCE_ARMYGROUP_SELECT_ARMYID = 577,
	ALLIANCE_ARMYGROUP_SELECT_ARMYID_EMPTY = 578,
	MSG_DOMAINSEASONREWARDCELLITEM = 579,
	UI_DOMAIN_PLAYER_RANK_SELECT = 580,
	UI_DOMAIN_PLAYER_RANK = 581,
	DESERTSENDREWARDLISTMESSAGE = 582,
	DECORATE_DRESSBASECITY_REFRESH = 583,
	DECORATE_INFONODE_REFRESH = 584,
	ScavengePointFinsh = 585,
	UIMissileLaunchItemSelect = 586,
	FbMissileAlliance = 587,
	Combine_Select_Index = 588,
	Close_Item_Combine_Panel = 589,
	Close_UIBuildMenu_Panel = 590,
	UPDATE_BUILD_DATA = 592,
	LOAD_COMPLETE = 594,
	COLLECT_OBJECT_SHOW = 595,
	COLLECT_OBJECT_HIDE = 596,
	UIMAIN_BOTTOM_SELECT_BUILD = 597,
	UIMAIN_BOTTOM_SELECT_BUILDTYPE = 598,
	UIMAIN_BOTTOM_SELECT_RESOURCE = 599,
	GOTO_BUILD = 600,
	UIMAIN_BOTTOM_RESET_BUILDTYPE = 601,
	UIMAIN_BOTTOM_RESET_BUILDTYPE_INFO = 602,
	REGET_MAIN_POSITION = 603,
	UPDATE_POINTS_DATA = 604,
	UIMAIN_VISIBLE = 605,
	UIMAIN_BOTTOM_CHANGE_BUILD_TYPE = 606,
	UIMAIN_BOTTOM_CHANGE_BUILD_SELECTS = 607,
	UIMAIN_BOTTOM_CHANGE_BUILD_TYPE_INFO = 608,
	UIMAIN_BOTTOM_CHANGE_BUILD_TYPE_SELECT = 609,
	UIMAIN_BOTTOM_CHANGE_MIDDLE_RESOURCE_STATE = 610,
	WORLD_CAMERA_CHANGE_POINT = 611,
	UIITEM_SELECT = 612,
	CLICK_MAIL_ITEM = 613,
	REFRESH_MAIL_TABLE = 614,
	REFRESH_RESOURCE_BAG = 615,
	CLICK_RESOURCE_ITEM = 616,
	UPDATE_SCIENCE_DATA = 617,
	CLICK_ALLIANCE_ITEM = 618,
	END_SEARCH = 619,
	ALLIANCE_WAR_DELETE = 620,
	CLICK_FORMATION_ITEM = 621,
	BUILD_IN_VIEW = 622,
	BUILD_OUT_VIEW = 623,
	QUEUE_TIME_END = 624,
	AddBuildSpeedSuccess = 625,
	AllianceQueueHelpNew = 626,
	AllianceBuildHelpNew = 627,
	MonsterMoveStart = 628,
	MonsterMoveEnd = 629,
	PUSH_NOTICE = 630,
	CLICK_ALLIANCE_SHOP_ITEM = 631,
	AllianceNameChange = 632,
	AllianceAbbrChange = 633,
	AllianceLanguage = 634,
	UIMAIN_CHANGE_BUILD_ENTER = 635,
	UIMAIN_CHANGE_BUILD_OUT = 636,
	CHAT_LOGIN_SUCCESS = 637,
	CHAT_REFRESH_CHANNEL = 638,
	ROOM_KICK_PLAYER_RESULT = 639,
	UPDATE_MSG_USERINFO = 640,
	CHAT_UPDATE_ROOM_LIST_LASTMSG = 641,
	CHAT_CHANGE_CURRENT_ROOM = 642,
	BuildResourcesStart = 643,
	BuildResourcesSecond = 644,
	DelayRefreshResource = 651,
	BuildUpgradeAnimationFinish = 652,
	EffectNumChange = 653,
	OnWorldInputDragBegin = 654,
	OnWorldInputDragEnd = 655,
	RefreshUIWorldTileUI = 656,
	ShowCapacity = 658,
	RewardItemAdd = 659,
	FarmDragEnd = 660,
	ChangeCameraLod = 661,
	ShowResourceUpdate = 662,
	ShowCapacitySecond = 663,
	OnMeteoriteHitGlass = 672,
	UIMainWarningShow = 673,
	UIMainWarningHide = 674,
	FoldUpBuilding = 675,
	LOAD_PLAY_VIDEO = 676,
	FarmSecondProduct = 677,
	Guide_video_Play = 678,
	AllianceAnnounce = 679,
	AllianceRestriction = 680,
	GET_INVITE_USERS_SUCCESS = 681,
	GOTO_SCIENCE = 682,
	LF_AccountListView_Close = 683,
	LF_AccountListView_Refresh = 684,
	LF_Account_History = 685,
	MessageBallChange = 686,
	LUA_BUILD_INIT_END = 690,
	CanGetProduct = 691,
	GetAllProduct = 692,
	RefreshUIBuildQueue = 693,
	RefreshFarmGatherUI = 694,
	HeroAdvanceSuccess = 695,
	HeroLvUpSuccess = 696,
	ShowMainUIExtraResource = 699,
	HideMainUIExtraResource = 700,
	HeroResetSuccess = 704,
	OnCancelHeroSelect = 705,
	AllianceInitOK = 706,
	AllianceQuitOK = 707,
	ReturnTimeFromCurPosToTargetPos = 708,
	Mail_DeleteMailDone = 709,
	Mail_DeleteBatchMailDone = 710,
	Mail_Select_Channel = 711,
	OnSelectHeroSelect = 712,
	UIResourceCostChangeState = 713,
	RecruitCampChange = 714,
	AllianceIntro = 715,
	AllianceMemberNeedHelp = 716,
	COLLECT_OBJECT_SHOWNew = 717,
	COLLECT_OBJECT_HIDENew = 718,
	ChangeNameIcon_Select = 719,
	UpdatePlayerHeadIcon = 720,
	UpdateCollectPos = 721,
	GetAssistanceData = 722,
	FakeBuildingSelectLocation = 723,
	UpdateFakeBuildingPos = 724,
	ShowIsOnFire = 725,
	UpdateRankPreview = 726,
	GetAllDetectInfo = 727,
	UpgradeDetectPower = 728,
	DetectInfoChange = 729,
	HeroMedalExchanged = 730,
	OnClickWorld = 731,
	OnClickMarch = 732,
	CheckDomeOpen = 733,
	CollectAnimEnd = 734,
	MailScoutReposition = 735,
	MailDetailReport_ClickItem = 736,
	RefreshArrow = 737,
	OnGoodsRedState = 738,
	LoginCommandError = 739,
	LoginInitError = 740,
	Net_Connect_Error = 741,
	Net_Server_Status = 742,
	CloseDisconnectView = 743,
	WorldTroopGameObjectCreateFinish = 744,
	CheckShowMainBuildLabel = 745,
	ShowTroopHeadNotBattle = 746,
	ShowTroopHeadInBattle = 747,
	ShowTroopBattleValue = 748,
	HideTroopHead = 749,
	DetectEventRewardGet = 750,
	Event_ShowBattleReportDetail = 751,
	BundleDownloadProgress = 752,
	RefreshDataPersonalArms = 753,
	CheckPubBubble = 754,
	AlGiftHideNameStateUpdate = 755,
	RefreshTopResByPickUp = 756,
	DailyQuestReward = 757,
	OnAdvanceSuccessClosed = 758,
	ShowTroopName = 760,
	HideTroopName = 761,
	CheckTroopStateIcon = 762,
	UpdateCityPoint = 763,
	Queue_Add = 764,
	OpenUI = 767,
	RefreshGuide = 768,
	QuestRewardSuccess = 769,
	Build_Time_End = 770,
	Nofity_Alliance_Battle_Week_Rusult_VS = 771,
	AllianceCompeteRankListUpdated = 772,
	AllianceCompeteRewardsReposition = 773,
	AllianceCompeteWeeklySummaryUpdated = 774,
	AllianceArms_OpenBox = 775,
	RefreshAllianceArmsUI = 776,
	StopSvAutoToCell = 777,
	PlayGetReward = 778,
	OnWorldInputPointDown = 781,
	TroopRotation = 782,
	SevenDayGetReward = 783,
	ShowDomeHideEffect = 785,
	ShowDomeShowEffect = 786,
	OpenFogSuccess = 787,
	OnTaskForceRefreshFinish = 788,
	OnSpecialTaskUpdate = 789,
	AttackExploreStart = 790,--攻击探索事件点开始
	AttackExploreEnd = 791,--攻击探索事件点结束
	WorldMarchDelete = 792,
	GuideTimelineMarker = 793,
	ContentLayoutReposition = 794,
	ShowExploreHeadInBattle = 795,
	ShowExploreBattleValue = 796,
	HideExploreHead = 797,
	CreateFormationUuid = 799,
	BuildMainZeroUpgradeSuccess = 801,
	FirstPayStatusChange = 802,
	GetSingleGarbageInfoSuccess = 804,
	ChapterTaskGetReward = 806,
	GarbageCollectStart = 807, --捡垃圾小人跑到位置
	SingleGarbageCollectStart = 808, --主城捡垃圾小人跑到位置
	GuideMoveArrowPlayAnim = 809, --引导移动的手指播放按下/抬起动画
	WorldArmyCollectAnimEnd = 810,
	VipDataRefresh = 812,
	VipRefreshFree = 813,
	VipRefreshPayGift = 814,
	ShowPower = 815,
	DailyQuestLs = 816,
	ShowAllGuideObject = 817,
	UnlockFogAnim = 818,--做解锁迷雾动画
	ReadOneMailRespond = 819,
	CloseUI = 821,--关闭UI
	UpdateGiftPackData = 822, --礼包数据更新
	ToggleRecruitScene = 823,
	BeginDownloadUpdate = 824,
	EndDownloadUpdate = 825,
	NetworkRetry = 826,
	ResourceFull = 827,
	UINoInput = 828,--禁止UI点击
	UIMainShowMailTips = 829, --显示主界面邮件提示
	AllianceWarNewStatusChanged = 830,
	ShowHeroIconByUseSkill=831,
	RefreshGuideAnim = 832,
	BuildRedDotRecord = 833,--建筑列表红点消失后的事件
	ShowHeroHitedUiEffect=834,
	BuildBoxOpenFinish = 835,
	ShowCanBuildEffect = 836,
	HideCanBuildEffect = 837,
	ShowUIMainSearch = 838,
	ShowDomeGlass = 841,
	ShowBuildTopUI = 842,
	HideBuildTopUI = 843,
	GuideNoOpenUI = 844,
	LowFps = 845,
	GuideWaitMessage = 846,
	OnAnyViewClosed = 850,
	OnPackageInfoUpdated = 851,
	WorldAllianceCityDetail = 852,
	UIPlaceBuildChangePos = 853,
	FormationInfoUpdate = 854,
	UICreateFakePlaceBuild = 855,--假建筑创建成功
	GetOneAllianceGift = 856,
	ShowAllianceCitySoldierBlood = 858,
	HideAllianceCitySoliderBlood = 859,
	WorldCityOwnerInfoReceived = 866,  --联盟所属信息初始化
	WorldCityOwnerInfoChanged = 867,   --联盟所属信息变更
	RefreshUIWorldPointView = 868,
	OnWorldInputPointClick = 869,--在世界上点击
	OnWorldInputPointDrag = 870,--在世界上拖拽移动一个点
	OnWorldInputPointUp = 871,--在世界上点击抬起
	RefreshTopResSuc = 872,
	AlLeaderElectStatusChange = 873,
	AlLeaderVoteStatusChange = 874,
	AlSysStateChange = 875,
	AlLeaderCandidateUpdate = 876,
	UserResSynNew = 878, --收资源
	RefreshUIGuideHeadTalk = 879, --刷新头像对话
	UnlockBuilding = 881,
	RefreshMonsterRewardBag = 882,
	MarchEndWithReward = 883,--战斗胜利，捡垃圾，采集获得奖励
	MarchFail = 884,--战斗失败
	RefreshActivityRedDot = 888,
	ShowUnlockBtn = 889,--显示解锁按钮
	UpdateDayActInfo = 890,
	HideMarchTip = 891,
	MonthCardInfoUpdated = 892,
	ShowGolloesMonthCardRewards = 893,
	GolloesNumChange = 894,--Obsolete
	GolloesFreeSpeedTimeChange = 895,--Obsolete
	GolloesExplorerRewardStateChange = 896,--Obsolete
	GolloesTraderRewardStateChange = 897,--Obsolete
	GolloesDataChange = 898,
	ScrollViewContentChange = 899,
	AllianceCityInView = 903,
	AllianceCityOutView = 904,
	UI_SHOWNOTICE = 905,--跑马灯
	RefreshAlertUI = 906,
	BuildLevelUp = 907,--建筑升级（包括建造）
	BuildMove = 908,--建筑移动（包括建造）
	GoTroopListShow = 909,

	CloseGuideMoveArrow = 913,--关闭移动指示手的界面
	UpdateMyAlCities = 915,
	MyAlCityListChanged = 916,
	UIPlaceBuildSendMessageBack = 917,--假数据刷新
	AllianceBaseDataUpdated = 918,
	GotoTime = 919,--跳转到timeline时间点
	CheckAccountPwdSuccess = 920,--验证密码正确
	AccountCheckSuccess = 922,--账号验证通过邮件发送
	RefreshDataAllianceArms = 923,--联盟军备活动数据
	ShowBattleRedName = 924,--战斗中以自己为目标的行军名字为红色
	HideSkillHeadEffect = 925,
	ShowPickGarbageResource = 926,
	--新增行军
	MarchAdd = 927,
	--删除行军
	MarchDelete = 928,
	ReInitLoadingLuaState = 929,
	IgnoreAllianceMarch = 930,
	IgnoreTargetForMineMarch = 931,
	MarchItemTargetMeUpdate = 932,--更新行军目标为自己
	ArrowShow = 933,--有箭头出现
	CloseChatView = 934,
	MarchItemUpdateSelf = 935,--自己的行军发生变化
	ShowTroopAtkBuildIcon = 936,
	HideTroopAtkBuildIcon = 937,
	ChapterTaskOrWarningBall = 938,--主界面消息球或任务箭头
	ShowFormationSelect = 939,
	HideFormationSelect = 940,
	--英雄驻扎
	HeroStationSave = 941,
	HeroStationUpdate = 942,
	HeroStationUseSkill = 943,

	OnUnlockViewClose = 946, -- 解锁弹窗关闭时
	RefreshGarbageTask = 947,--捡垃圾任务刷新
	-- 登陆状态
	LoadingState = 948,
	ShowArrowPlayerBtn = 949,--绑定账号指向头像
	OnGetNewAlJoinReq = 950,--收到加入联盟请求

	WORLD_BUILD_IN_VIEW = 958,--其他人建筑进入视野
	WORLD_BUILD_OUT_VIEW = 959,--其他人建筑离开视野
	

	CreateAccountMailFail = 964,--绑定邮箱发送失败
	AllianceCityNameCheck = 967,
	AllianceCityNameChange = 968,
	CheckFiveStar = 969,
	OnClaimRewardEffFinish = 970,--播完领奖动画后刷新
	MonsterRewardCreate = 971,

	RadarRallyGetBossCount = 972,--雷达集结获取打怪数据

	HeroRankUpSuccess = 973, --英雄军阶升级成功
	ToggleHeroPreviewScene = 974,
	
	PlayerChangeHeadRedPot = 979,


	BarterShopExchangeSucc = 980,

	NoticeMainViewUpdateMarch = 981,
	GrowthPlanGetInfo = 982, --成长计划获取信息
	GrowthPlanGetReward = 983, --成长计划领取奖励

	ChangeShowTranslatedStatus = 984,
	BuildFixStart = 985, --废墟修复开始
	BuildFixFinish = 986,--废墟修复结束
	AddBuildFixSpeedSuccess = 987,--废墟加速修改
	Build_Fix_Time_End = 988,--废墟时间结束
	AllianceBuildFixHelpNew = 989,--废墟联盟帮助成功
	RefreshWelfareRedDot = 990,

	ChampionBattleReceiveBoxBack = 992,
	ChampionBattleBetViewBack = 993,
	ChampionBattleFormationSaved = 994,
	ChampionBattleSingUpBack = 995,
	UpdateTask = 996,
	OnUpdateTeamDataEvent = 997,
	ChampionBattleRewardPreviewBack = 998,
	ChampionBattleEntranceNotice = 999,
	ChampionBattleDataRefresh = 1000,
	ShowBuildAttackHeadUI = 1002,
	HideBuildAttackHeadUI = 1003,
	AlWaitMergeStatusChange = 1004,
	AlInviteRecommendUserSucc = 1005,

	GetRedPacketUpdate = 1006,--领取到红包更新
	GetNewUserInfoSucc = 1007,--获取玩家信息

	GarageRefitUpdate = 1008, -- 车库改装
	GetPlayerPoliceStationData = 1009,--刷新玩家警察局数据
	QueueHeroFreeTime = 1010, --英雄加速
	UploadHead_Start = 1013, --头像开始上传
	UploadHead_End = 1014, --头像上传成功/失败
	AllianceLogUpdate = 1015, --联盟日志更新
	WorldTrendUpdate = 1016,--天下大势更新
	WorldTrendRedUpdate = 1017,--天下大势红点更新
	OnUpdateAlLeaderCandidates = 1019,--盟主选举候选人信息更新
	UpdateAlElectRed = 1020,--更新联盟主界面各功能入口
	OnUpdateActivityEventData = 1021,--更新活动event数据
	UpdateAlertData = 1022,--联盟警报

	MainLvUp = 1025, -- 大本升级
	ClickMainAccountBind = 1026,--点击了主界面账号绑定

	UpdateAlCanBeLeader = 1027,--是否可选成为盟主
	OnGetRecommendAlPoint = 1028,--获得推荐联盟迁城点

	OnUpdateAllianceTask = 1029,
	OnAllianceTaskRedChange = 1030,
	OnRewardGetPanelClose = 1032,
	OnKickAllianceMember = 1033,
	UpdateChatQuestRed = 1034,
	OnRecvAllianceStorageInfo = 1035,--获取联盟仓库信息
	OnClickPlaceBuild = 1036,
	OnClickMsgNew = 1037,
	UpdateTraderExtraRewardTimes = 1040,

	PointToAllianceMoveBtn = 1043,
	NoRefresh = 1044,--不用刷新，防止气泡刷新两次出现闪一下的问题

	CreatWormholeBuild = 1047,

	PveLevelEnter = 1048,
	PveLevelExit = 1049,
	ShowAllianceMemberRanks = 1050,
	ShowBattleBuff = 1051,
	HideBattleBuff = 1052,
	ShowWorldZoneChangeColor = 1053,
	SetMovingUI = 1054,
	PveLevelBeforeEnter = 1055,

	SetGoldStoreBtnVisible = 1057,

	CacheGoldStoreOpenType = 1058,
	RefreshGoldStoreRed = 1059,
	SetCityLabelShow = 1060,
	ShowDesertAttackHeadUI = 1061,
	DesertInView = 1062,
	DesertOutView = 1063,
	ShowActBossBattleValue= 1064,
	ShowActBossOpen = 1065,
	ShowActBossClose = 1066,
	ShowBuildDetail = 1067,
	HideBuildDetail = 1068,
	RefreshExpFromMessage = 1070,
	AddExpFromScene = 1071,
	
	AllianceInviteStatusChange = 1076,
	PVEHeroExpFly = 1077,
	WorldTrendRefresh = 1079,

	PveFinishOneTrigger = 1081,--pve完成一个触发点

	AllianceFlagChanged = 1082,
	PVEBattleSetLeftBuffData = 1083,
	PVEBattleSetRightBuffData = 1084,
	PVEBattleShowLeftBuff = 1085,
	PVEBattleShowRightBuff = 1086,
	AllianceCityLogUpdate = 1087, --联盟城日志更新
	WorldZoneChangeColorFinish = 1088,
	UpdateMineCaveInfo = 1089,

	OnRecvMineCavePlunderLog = 1090,
	PveMineCaveInfoUpdate = 1091,

	ResetQuestArrow = 1092,
	FormationStaminaUpdate = 1093,
	UserGoldCoverStamina = 1094,
	UserItemCoverStamina = 1095,

	RefreshResLackList = 1096,
	RefreshHeroEffectSkill = 1097,
	ShowMarchTrans= 1098,
	HideMarchTrans= 1099,
	RefreshNpcTalkBubbleActive = 1100,
	RefreshHeroEntrust = 1101,--刷新英雄委托数据
	AttackSpecialStateFlag = 1102,--出征特殊状态

	DesertForceRank = 1104,

	SelectBatchMail = 1105,
	SelectBatchAll = 1106,
	SelectCancelOne = 1107,
	RePlyChat = 1108,
	WorldTrendRefreshRank = 1109,

	GuideInitFinish = 1113,

	QuestionnaireRefresh = 1114,

	RolesRefresh = 1115,
	ServerListRefresh = 1116,

	OnHeroBountyTaskRefresh = 1117,
	OnHeroBountyOneTaskRefresh = 1118,
	OnSelectHeroSelectForBounty = 1119,
	OnCancelHeroSelectForBounty = 1120,
	OnSelectAccountServer = 1121,

	RefreshHeroBountyBubble = 1122,

	SetHeroOfficial = 1123,
	ShowWorldMarchByType= 1124,--显示行军模型
	HideWorldMarchByType= 1125,--隐藏行军模型
	SetCityPeopleAndCarVisible = 1126,--显示主城内人和车
	ChapterAnimHide = 1127,

	BuyItemAndRes = 1128,

	OnGetServerDataRefresh = 1129,

	OnEnterCrossServer= 1133,
	OnQuitCrossServer = 1134,

	PveStaminaUpdate = 1135,--刷新pve体力

	PveTaskGetReward = 1136,

	OnKeyCodeEscape = 1138,

	ClickAny = 1139,
	SetPveSkillVisible = 1140,--设置旋风斩按钮显示/隐藏
	RefreshUIPveMainVisible = 1141,--设置pve主界面显示/隐藏
	IDCardCheckSuccess =1142,
	IDCardCheckFail  =1143,
	FoldCrossWormHoleTimeUpdate = 1144,
	ShowCreateCrossWormHole = 1145,
	SetPveBuyBuffSShopEffectVisible = 1146,--设置pve购买Buff商店黑色遮罩显示/隐藏
	FreeWeeklyPackage = 1147,
	SetPveStopRefreshStamina = 1155,--设置pve停止刷新体力
	SetPveNoClickStamina = 1156,--设置pve不能点体力
	RefreshUIHeadTalk = 1157,--刷新头像对话
	CloseUIGuideHeadTalk = 1158,--关闭头像对话
	PingTest = 1159,--ping 测试
	CrossServerAlliancePoint = 1161,--跨服推荐点
	WorldCollectPointInView = 1162,--采集点进入视野
	WorldCollectPointOutView = 1163,--采集点离开视野
	OnGetBlockList = 1164,
	SetPveResetPositionVisible = 1165,--pve重置位置按钮，显示/消失
	HeroAdvanceGuide = 1166,--英雄进阶引导
	ShowCrossEffect = 1167,

	ActMonTowerGetInfo = 1170,
	ActMonTowerChoiceDiff = 1171,
	ActMonTowerCallBoss = 1172,
	ActMonTowerGetRank = 1173,
	ActMonTowerGetReward = 1174,
	ActMonTowerGetTask = 1175,
	ActMonTowerCallHelp = 1176,
	ActMonTowerBossKilled = 1177,
	GuidControlQuest = 1178,
	RefreshBuildUpgradeStock = 1179,--刷新建筑交材料数据
	OnEnterWorld = 1180,
	OnEnterCity = 1181,
	PveDropRewardAdd = 1182,--增加一个pve掉落奖励
	PveDropRewardRemove = 1183,--减少一个pve掉落奖励
	PveBattleBuffRefresh = 1185,

	GetNoticeList = 1188,
	RefreshNotice = 1189,
	NoticeItemClick = 1190,
	NoticeItemReward = 1191,

	ChapterArrow = 1192,

	ShowMiniMap = 1193,
	HideMiniMap = 1194,
	MiniMapDataRefresh =1195,
	ShowArrowSearchBtn = 1196,
	BattleMessageParsed =1197, -- 战斗消息解析完成

	RefreshTaskCell = 1198,

	RefreshMainTask = 1199,

	GetSeasonRewardData = 1200,
	GetSeasonAllianceSendMemberList = 1201,

	UserLostDesert = 1203,
	UserGetDesert = 1204,
	UserDismissDesert = 1205,
	UserCancelDismissDesert =1206,
	UserDesertResCollect = 1207,
	UICreateFakePlaceAllianceBuild = 1208,--假建筑创建成功
	UIPlaceAllianceBuildChangePos = 1209,
	InitSelfDesert = 1210,
	CheckAttackBoss = 1211,

	PveGetFakeItem = 1212,

	OnActBossDataRefresh = 1213,--活动boss数据刷新
	OnActBossRankRefresh = 1214,--活动boss排行榜刷新
	SetUIVisible = 1215,--引导设置UI隐藏
	HideDesertAttackHeadUI = 1216,
	FoldUpSeasonBuild = 1218,--收起赛季建筑
	ActGiftBoxGetInfo = 1219,
	ActGiftBoxOpen = 1220,
	UpdateGold = 1221,
	ActGiftBoxLottery = 1222,
	ActGiftBoxLotteryCount = 1223,

	ChangeShowTroopAttackEffectState = 1224,
	ChangeShowTroopBloodNumState = 1225,
	ChangeShowTroopDestroyIconState = 1226,
	ChangeShowTroopHeadState = 1227,
	ChangeShowTroopNameState = 1228,
	ChangeSex = 1229,--改变性别
	UserGetDesertAdd = 1230,
	DesertForceRefresh = 1231,
	RefreshUINoticeEquipTips = 1232,--刷新个人军备活动展示tips

	OnBeforeEnterWorld = 1233,
	OnBeforeEnterCity = 1234,
	RefreshDeadArmyRecord = 1235,--士兵死亡记录刷新
	RefreshDeadArmyRecordRedDot = 1236,--士兵死亡记录红点刷新
	GatherSeasonResTimeChange = 1237,
	ForceSelfRank = 1238,
	CheckGatherSeasonResRedDot = 1239,
	AllianceForceRankUpdate = 1240,
	RefreshGuideDetectEvent = 1241,
	WorldBuildQueueHeroFreeTime = 1242, --世界建筑英雄加速
	ResetUIBuildClickState = 1243, --建筑升级/交资源出错，重置升级页面连续点击状态

	AllianceFlagUpdate = 1244,--联盟旗帜变化
	ShowCreateAllianceFlag = 1245,
	ShowAllianceBuildAttackHeadUI =1246,
	HideAllianceBuildAttackHeadUI =1247,
	ChangeShowTroopGunAttackEffectState = 1248,
	ChangeShowTroopDamageAttackEffectState = 1249,
	GuideChangeFreeSpeedBtn = 1250,--引导改变加速按钮为免费
	ShowNPCBuildAttackHeadUI =1251,
	HideNPCBuildAttackHeadUI =1252,
	ChangeCameraInitZoom =1253,
	ChatDBInitFinish = 1254,
	FinishGuideDetectEvent = 1255,--完成引导假世界怪事件

	RefreshDailyCumulative = 1256,
	AllianceCenterUpdate = 1257,--联盟中心数据变化
	OnUpdateOneAllianceCenter = 1258,--联盟中心数据变化
	OnDeleteOneAllianceCenter = 1259,

	AllianceFrontUpdate = 1260,--联盟前线数据变化
	OnUpdateOneAllianceFront = 1261,--联盟前线数据变化
	OnDeleteOneAllianceFront = 1262,
	OnPveHeroCancel = 1263,
	--五星吐槽发送完毕
	FiveStarFeedbackComplete = 1264,

	BlackKnightUpdate = 1265,--黑骑士数据变化
	BlackKnightRank = 1266,--黑骑士排行榜变化
	BlackKnightWarning = 1267,--黑骑士警告变化
	AttackInfoForMinimap = 1268,
	AttackerInfoUpdate = 1269,--仇人数据发生变化
	DesertEffectInView = 1270,
	DesertEffectOutView =1271,
	MailGetMore =1272,--邮件显示更多
	MailBatchDelete = 1273,

	-- 联盟捐兵相关开始
	GetDonateArmyActivityInfo = 1274, -- 获取捐兵活动信息
	GetDonateArmyScoreInfo = 1275, -- 获取对决双方联盟成员积分信息
	ReceiveDonateArmyTaskReward = 1276, -- 领取捐兵活动任务奖励
	DonateSoldier = 1277, --捐兵
	ReceiveDonateArmyStageReward = 1278, --领取捐兵贡献奖励
	PushDonateArmyTaskUpdate = 1279, --捐兵任务数据推送
	PushArmyInfoEvent = 1280,
	UIDonateSoldierInfoDataUpdate = 1281,
	UIDonateSoldierRankDataUpdate = 1282,
	-- 联盟捐兵相关结束

	ActMainRefreshRed = 1283,
	
	ActDesertForceGroupRank = 1285,

	ColloesCaravanRecord = 1286,
	ColloesCaravanRed = 1287,

	ChangeShowTranslatedNotice = 1288,--公告翻译
	CloseGuideLoadMask = 1289,--关闭引导黑幕

	GovernmentPresentRefresh = 1300,--王座刷新礼物
	GovernmentPresidentRefresh = 1301,--王座国王刷新
	GovernmentPresentRecordRefresh = 1302,--王座刷新发奖记录
	GovernmentHistoryRecordRefresh = 1303,--王座刷新国王历史记录
	CheckShowGovPos = 1304, --官职标志刷新
	ShowThroneArmyHeadUI = 1305, --王座血量变化
	HideThroneArmyHeadUI = 1306, --
	CancelAllianceTeam = 1307,
	ActGiftBoxRankUpdate = 1308,

	DesertMineInView = 1309,
	DesertMineOutView = 1310,

	-- 刷新英雄勋章商店数据
	UpdateHeroMedalShop = 1311,
	-- 英雄勋章商店每日奖励同步
	UpdateHeroMedalShopDailyReward = 1312,
	-- 英雄勋章商店道具同步
	UpdateHeroMedalShopItem = 1313,

	ShowSiegeAttack = 1314,
	HideSiegeAttack = 1315,
	SetScreenResolution = 1316,
	SetGuideMoveArrowShow= 1318,--引导移动手指显示
	SetGuideMoveArrowHide= 1319,--引导移动手指隐藏

	-- 新联盟捐兵开始
	GetALVSDonateArmyActivityInfo = 1320,
	ReceiveALVSDonateArmyTaskReward = 1321,
	ALVSDonateSoldier = 1322,
	ReceiveALVSDonateArmyStageReward = 1323,
	PushALVSDonateArmyTaskUpdate = 1324,

	ALVSDeclareAllianceListReturn = 1325, --匹配联盟列表返回 刷新匹配联盟界面
	ALVSRandomMatchReturn = 1326, -- 随机匹配对手信息返回 刷新匹配对手界面
	PushALVSMatchSuccessReturn = 1327, --匹配到对手的推送 -- 收到后如果在界面里则发送 get.donate.army.activity.info.v2
	PushALVSDonateArmyBattleStartReturn = 1328, -- 盟主开启迎战后推送 --收到后如果在界面里发送 get.donate.army.battle.info 
	ALVSDonateArmyBattleInfoReturn = 1329, -- 获取对决信息返回
	PushDonateArmyDefenceResult = 1330, -- 新捐兵战斗联盟中心状态变化

	-- 新联盟捐兵结束

	GetMigrateList = 1331,
	GetMigrateServerDetail = 1332,
	GetMigrateApplyList = 1333,
	OnMigrateApplyToPresident = 1334,
	OnMigrateApprove = 1335,
	OnRefreshMigrateRedPot = 1336,
	OnGetMigratePoint = 1337,

	OnSetMigratingUI = 1338,
	CLICK_MIGRATE_SERVER_ITEM = 1339,

	PushPirateSiegeBattleStartEvent = 1340,

	GetAllianceBossActivityInfo = 1341, -- 获取 联盟boss数据的请求 返回
	AllianceBossDonate = 1342, -- 捐献 联盟boss的请求 返回
	CallAllianceBoss = 1343, -- 召唤联盟boss的请求 返回
	PushAllianceBossCreate = 1344, -- 收到联盟盟主召唤boss的推送
	PushAllianceBossDamageUpdate = 1345, -- 收到对联盟boss造成伤害变化推送
	ReceiveAllianceBossFreeReward = 1346, -- 领取联盟boss免费奖励请求 返回
	GetAllianceBossDonateRank = 1347, -- 获取联盟boss捐献排行榜
	GetAllianceBossDamageRank = 1348, -- 获取联盟boss伤害排行榜

	ShowAllianceBossRewardBoxByPosAndItemid = 1349, -- 获取联盟boss伤害排行榜

	ShowFormationBlood = 1351,--刷新行军血量
	ShowAllianceBossBattleValue = 1352,
	FoldSubWormHoleTimeUpdate = 1353,
	ControlTimelinePause = 1354,--控制timeline暂停/恢复

	OtherServerAlliancePowerRank = 1355,--其他服联盟战力排行榜
	PlayerNitrogenUpdate = 1356,--玩家氮气数据变化
	SetAnimVisible = 1357,--设置动物显示/隐藏

	ShowActAllianceBuildAttackHeadUI =1358,
	HideActAllianceBuildAttackHeadUI = 1359,

	AllianceActMineUpdate = 1360,
	AllianceActMemberUpdate = 1361,
	AllianceActMineResUpdate = 1362,
	ShowBattleDamageType = 1363,
	OnEnterDragonUI = 1364,
	OnQuitDragonUI = 1365,

	ShowDragonBuildAttackHeadUI =1366,
	HideDragonBuildAttackHeadUI = 1367,

	DragonMapDataRefresh = 1368,
	DragonBuildInView = 1369,
	DragonBuildOutView = 1370,
	ArenaCampEffectUpdate = 1371,
	GetDagonPlayerList = 1372,
	DragonScoreRefresh = 1373,
	RefreshTimelineJump = 1374,--刷新引导timeline跳过参数
	
	RefreshAlarm = 1403,--个人警报
	
	RefreshMigrateInfo = 1404,

	StoreEvaluateInfo = 1405,
	StoreEvaluateReward = 1406,

	DragonRewardInfo = 1410, --巨龙活动奖励信息
	RefreshHeroPlugin = 1420,--刷新英雄插件信息
	EnterDragonWorld = 1411,
	QuitDragonWorld = 1412,
	DragonInfoRefresh = 1413,--巨龙活动信息
	DragonBattleTimes = 1414,--查看报名可选时段
	DragonBattleHistory = 1415,--查看历史记录
	DragonBattleScoreInfo = 1416,--巨龙战斗详情
	DragonBattleResult = 1417,--巨龙战斗结果

	DragonSecretShow = 1418,
	StaminaBallData = 1419,
	RefreshMergeOrder = 1421,--刷新合成订单信息

	WorldPassOwnerInfoReceived = 1422,
	WorldPassOwnerInfoChanged = 1423,
	StrongHoldOwnerInfoReceived = 1424,
	StrongHoldOwnerInfoChanged = 1425,
	OnSetEdenUI = 1426,
	EdenUserRank = 1427,
	EdenCampScore = 1428,
	RefreshEquipAct = 1429,
	EdenMarchSignalPoint = 1430,
	UIGuideEdenWarTipsUpdate = 1431,
	UIEdenSubwayBuildUpdate = 1432,
	RefreshFirstChargeUI = 1433,
	UpdateFirstChargeUI = 1434,
	GetEdenCrossWarGroupData = 1446,
	
	DesertUpdateLevelInView = 1447,
	DesertUpdateLevelOutView = 1448,
	ShowTroopMineDamage = 1449,
	ChangeHeroCamp = 1450,--修改英雄阵营
	RefreshRadarBossDailyRewardCount = 1451,--刷新雷达boss每日领奖次数
	RefreshChangeNameAndPic = 1452,--改头换面活动数据变化
	
	
	GoogleAdsUserEarnedReward = 1453,
	GoogleAdsUserExitReward = 1454,
	GoogleAdsUserCreateRewardedAdFail = 1455,
	GoogleAdsUserCreateRewardedAdSuccess = 1456,
	GoogleAdsUserClickAd = 1457,
	RefreshHeroCampRed = 1458,--刷新英雄阵营红点

	UnityAdsUserEarnedReward = 1459,
	UnityAdsUserSkipReward = 1460,
	UnityAdsUserCreateRewardedAdFail = 1461,
	UnityAdsUserCreateRewardedAdSuccess = 1462,
	UnityAdsUserClickAd = 1463,

	GetEdenMineScoreRank = 1464,
	
	GetEdenMissileData = 1465,
	SU_PveReportDoSkill = 1466,
	RefreshFurniture = 1467,--刷新一个家具数据
	ShowFurniture = 1468,--显示家具
	HideFurniture = 1469,--隐藏家具
	RefreshStorm = 1470,--刷新暴风雪
	RefreshCityBuildModel = 1471,--刷新城内建筑模型
	SetPanelVisible = 1472,--隐藏家具升级界面
	RefreshCityBuildMark = 1473,--刷新城内建筑盖子
	RefreshUIMainBtn = 1474,--刷新主界面按钮
	NeedRefreshGuideArrow = 1475,--需要重新刷新引导手指向的节点
	ShowOneBuildBubble = 1476,--显示一个建筑气泡
	RemoveOneBuildBubble = 1477,--删除一个建筑气泡
	RefreshBubbleActive = 1478,--控制气泡节点显示/隐藏
	SecondArrow = 1479,--刷新连续箭头
	AllianceCityStaminaUpdate = 1480,
	CloseGuideWindEffect = 1481,--关闭风沙
	OnTroopDragonUpdatePos = 1482,--行军拖拽
	RefreshFurnitureProduct = 1483,--刷新一个家具生产数据
	PveGuideStartDrag = 1484,--pve引导开始拖拽屏幕
	LandBlockOnClickFire = 1485,
	ShowActBossHeadInBattle= 1486,
	HideActBossHead = 1487,
	ShowAllianceBossHeadInBattle= 1488,
	HideAllianceBossHead = 1489,
	ShowMonsterHeadInBattle = 1490,
	HideMonsterHead = 1491,
	ShowMonsterBattleValue = 1492,
	GuideRefreshVitaFireStateChange = 1493,--引导刷新点火数据
	-- 砍伐相关
	RefreshCutReward = 2000,
	WasteLand_ResetRes = 2001, -- 资源恢复,,,,貌似已经废弃

	ChampionBattleRankDataBack = 2002,

	ShowTalkBubble = 2003,
	HideTalkBubble = 2004,
	ChampionBattleReportDataBack = 2005,
	RefreshAllianceCareer = 2006,--刷新联盟职业
	UpdateWorldZoneNews = 2007,
	UpdateWorldNewsData =2008,
	WorldAreaNewsRedDot = 2009,
	WorldAlCityNewsRedDot = 2010,

	RefreshHeroMonthCardAll = 2011,--刷新英雄月卡整个界面
	RefreshHeroMonthCardSingle = 2012,--刷新英雄月卡单个cell

	ShowAlScienceCriticalHitRatio = 2013,--联盟科技捐献暴击

	BuildUpgradeRewardArmy = 2014,--建筑升级获得兵力奖励
	CumulativeReward = 2015,
	DeclareWar = 2016,
	BuildUpgradeBubbleReward = 2017,
	GoGiftPackagePop = 2018,

	ActLuckyRollUpdate = 2019,--幸运转盘信息更新
	ActLuckyRollChoiceItem = 2020,--幸运转盘选择道具
	ActLuckyRollGetReward  = 2021,

	StartAttackMonsterWithoutMsgTip = 2022,--不弹窗开始打野怪，引导用

	ActBattlePass = 2023,--战令信息更新
	ActBattlePassRefresh = 2024,--推送更新
	ActBattlePassTask = 2025,--战令任务更新
	ActBattlePassStage = 2026,--战令阶段更新
	ActBattlePassRed = 2027,
	ShowCollectBattleValue = 2028,
	CollectPointOut = 2029,
	GuideSaveId = 2030,

	ActGolloesCard = 2031,--咕噜翻卡
	ActGolloesCardRefresh    = 2032,
	ActGolloesCardRank = 2033,
	ActGolloesCardRed = 2034,
	ActGolloesCardFlipAll = 2035,
	ActGolloesCardRewardShow = 2036,
	ActGolloesCardFlip = 2037,

	ActSevenDay = 2038,
	ActSevenDayScore = 2039,
	ActRewardState = 2040,

	GetRankRefresh = 2041,
	-- 派遣今日次数更新
	DispatchTaskTodayNumUpdate = 2043,
	DispatchTaskUpdateSingle = 2044,
	DispatchTaskUpdateAlliance = 2045,
	
	ActLuckyRollRankUpdate = 2049,
	GetAllianceSeasonScoreRank = 2050,
	GetAllianceSeasonScoreRankReward = 2051,

	-- PVE相关
	PVE_Lineup_LoadOK = 2100,  -- 阵型加载完毕
	OnSelectPVEHeroSelect = 2101, --选中英雄
	OnCancelPVEHeroSelect = 2102, --取消选中
	OnEmBattleHeroChanged = 2103, --布阵改变
	PVE_TotalHp_Changed = 2104, --总血量变化
	PVE_Lineup_Init_End = 2105, --阵容初始化完成
	PVE_Exit = 2106, --退出pve
	PuzzleDataUpdate = 2107,--拼图信息刷新
	PuzzleTaskUpdate = 2108,--拼图任务完成

	HeroLotteryInfoUpdate = 2115,
	PveBattleBuffAdd = 2116, -- 已弃用，使用 1179

	OnPuzzleMonsterRankRefresh = 2117,
	OnPuzzleMonsterDataRefresh = 2118,
	HeroBeyondSuccess = 2119,

	CrossServerWar = 2120,

	OnRefreshSevenLogin = 2121,
	OnRefreshSeasonCard = 2122,
	SeasonWeekCardBuy = 2123,
	SeasonWeekCardReward = 2124,
	ColonizeWarAllianceRank = 2125,
	ColonizeWarPlayerRank = 2126,

	--  [[ MKMKMKMKMKMKMKMKMKMKMKMKMKMKMKMKMK
	OnDailyActivityNewStatusChange = 2193,
	OnClaimCollectRewardSucc = 2194,
	UpdateThemeActNoticeRewardInfo = 2195,
	UpdateOneThemeActivity = 2196,
	MineCaveShowDispatch = 2197,
	OnAlScienceRecommendChange = 2198,
	OnAllianceRecommendChange = 2199,
	UpdateOneCommonShopGoods = 2200,
	UpdateOneCommonShop = 2201,
	OnBuyCommonGoodsSucc = 2202,
	OnQuestRedCountChanged = 2203,
	UpdateAllianceAutoRallyInfo = 2204,
	OnUpdateArenaBaseInfo = 2205,
	OnUpdateArenaHistoryInfo = 2206,
	OnArenaBattleFinish = 2207,
	OnArenaRedChange = 2208,
	OnStorageSellToGolloes = 2209,
	OnChapterTaskBtnVisibleChange = 2210,
	OnMsgBallBtnVisibleChange = 2211,
	UpdateMainAllianceRedCount = 2212,
	OnGetAlMoveInvite = 2213,
	OnOneActivityOverviewRedChange = 2214,
	OnCommonShopRedChange = 2215,
	OnDragUICloseTip = 2216,
	AllianceCountryChanged = 2217,
	OnPassDay = 2218,
	OnGetNewAllianceAutoInvite = 2219,
	OnWeekCardInfoChange = 2220,
	OnAllianceOfficialPosChange = 2221,
	OnUpdateJigsawPuzzleInfo = 2222,
	OnJigsawPuzzleEnd = 2223,
	OnJigsawRankUpdate = 2224,
	SetMainEnergyVisible = 2225,
	OnTreasureInfoUpdate = 2226,
	OnTreasureSkillReady = 2227,
	OnDigActivityInfoUpdated = 2229,
	OnCurDigLevelUpdated = 2230,
	OnDigOneBlockSucc = 2231,
	OnGetAutoDigResult = 2232,
	OnDigActFinalResultUpdated = 2233,
	OnbuyPickaxeSucc = 2234,
	OnUnlockActivityViewClose = 2235,
	RefreshAlMoveInviteTip = 2236,
	RefreshPveAdditional = 2237,
	UpateAllAllianceMineList = 2238,
	OnAddOneAllianceMine = 2239,
	OnDelOneAllianceMine = 2240,
	OnRefreshAllianceMineMarch = 2241,
	OnRobotWarActivityUpdate = 2242,
	OnClaimSeasonRewardSucc = 2243,
	OnPaidLotteryInfoUpdate = 2244,
	OnClaimPaidLotteryTicketSucc = 2245,
	OnGetPaidLotteryRollResult = 2246,
	OnPaidLotteryScoreChange = 2247,
	OnSeasonPassInfoUpdate = 2248,
	OnSeasonPassTaskRewardUpdate = 2249,
	OnSeasonPassLevelRewardUpdate = 2250,
	OnHeroGrowthInfoUpdate = 2251,
	OnHeroGrowthScoreChange = 2252,
	OnHeroGrowthScoreBoxStatusUpdate = 2253,
	OnRecvNewActivityInfo = 2254,
	OnWeekCardCustomRewardUpdate = 2255,
	OnAllianceMergeListUpdate = 2256,
	OnMyApplyMergeListUpdate = 2257,
	OnWeekCardOneInfoChange = 2258,
	OnAlContributeBoxStatusChange = 2259,
	OnAlContributeRankInfoUpdate = 2260,
	OnAlContributeEventInfoUpdate = 2261,
	OnExploitMonthCardInfoUpdate = 2262,
	OnDigActivityRankInfoUpdate = 2263,
	OnMyLeagueMatchInfoUpdate = 2264,
	OnLeagueMatchGroupUpdate = 2265,
	OnLeagueMatchBaseInfoUpdate = 2266,
	OnLastLeagueMatchGroupInfoUpdate = 2267,
	OnLeagueMatchRewardInfoUpdate = 2268,
	OnLeagueMatchStageChange = 2269,
	RefreshHeroPluginRank = 2270,--刷新英雄插件排行榜
	ControlSeasonIntro = 2271,--引导控制赛季简介UI


	MK_End = 2300,
	--]] MKMKMKMKMKMKMKMKMKMKMKMKMKMKMKMKMK

	MainToWorldBtn = 2310,
	MainToDailyAct = 2311,

	OnOneKeyAdvanceSuccess = 2312,
	OnOneKeyAdvanceSuccessClosed = 2313,
	TalentDataChange = 2314,
	UpdateTrackingStatus = 2315,
	HeroExChange = 2318,
	HideAdvanceNew = 2319,
	UnlockArmy = 2320,
	ReceivePveTriggerRewardBack = 2322,
	DelayRefreshPVEStamina = 2323,
	PVEBuildingUpgradeBack = 2324,
	GatherEffectEnd = 2326,
	OnRemoveNewHeroFlag = 2327,
	HeroStarUpBack = 2328,
	UIBuildListScrollMove = 2332,--建造列表界面滚动
	SetGuideMask = 2335,--引导通用开启/关闭遮罩事件
	UIScrollToSomeWhere = 2340,--引导打开界面滑动到指定位置
	GuideEndNoShowQuest = 2341,--引导结束不打开主UI左侧任务
	SetBuildCanDoAnim = 2342,--控制建筑能否做动画
	SetBuildNoDoAnim = 2343,--控制建筑不能做动画
	OnTouchPinchStart = 2344,--开始双指缩放
	OnTouchPinchEnd = 2345,--结束双指缩放
	OnEditorTouchPinch = 2346,--电脑开始滑动滚轮
	SetBuildCanShowLevel = 2347,--控制建筑能显示等级条
	SetBuildNoShowLevel = 2348,--控制建筑不能显示等级条
	OnInputLongTapStart = 2349,--在长按地面开始
	OnInputLongTapEnd = 2350,--在长按地面结束
	PosterExchangeSuccess = 2351,--Poster兑换成功
	HeroIntensifyUpdate = 2353,--英雄阵营强化更新
	HeroIntensifyRandomEffect = 2354,--英雄阵营强化随机
	MasteryStatusUpdate = 2355,
	RefreshHeroPageList = 2356,
	UserSkinUpdate = 2360,--玩家皮肤信息刷新
	UserCitySkinUpdate = 2361,--玩家主城皮肤信息刷新

	FormStatusUpdate = 2363,
	KeepPayUpdate = 2364, -- 每日累充更新
	ChainPayGetInfo = 2365, -- 连续充值GetInfo
	ChainPayReceiveReward = 2366, -- 连续充值ReceiveReward
	ChainPayUpdateState = 2367, -- 连续充值UpdateState

	LuckShopDataUpdate = 2368,--幸运商店信息更新
	LuckShopRefresh = 2369,--幸运商店刷新
	GetLastSeasonHeroRecordInfoSuccess = 2370,--
	TaskInitFinish = 2371,--任务初始化完成
	ChainPayRefresh = 2372, -- 连续充值Refresh

	DecorationActivityDataUpdate = 2373,--皮肤活动信息变化
	SendContactGiftSearchBack = 2374,


	MasteryLearn = 2375,
	MasteryChangePlan = 2376,
	MasteryUseSkill = 2377,
	MasteryUpdate = 2378,
	MasteryReset = 2379,
	MasteryChangeName = 2398,
	PageNameCheckEvent = 2399,

	GloryGetWarData = 2380,
	GloryGetDeclareAlliance = 2381,
	GloryDeclareWar = 2382,
	GloryStart = 2383,
	GloryMatch = 2384,
	GlorySetAvoid = 2385,
	GloryGetMyHistory = 2386,
	GloryGetHistory = 2387,
	GloryGetMemberRecord = 2388,
	GloryGetOldMemberRecord = 2389,
	GloryGetBattleDetail = 2390,
	GloryGetAct = 2391,
	GloryGetContribution = 2392,

	SeasonWeekUpdate = 2393,
	CrossWormPlunderUpdate = 2394,
	CrossWormSaveArmy = 2395,
	CrossWormSaveHero = 2396,
	BuildStatusUpdate = 2397,

	EquipDataUpdate = 2400,
	EquipSuitDataUpdate = 2401,
	EquipSelect = 2402,
	EquipInfoClose = 2403,

	SearchSelectUser = 2404,
	KingdomPositionInfoUpdate = 2405,
	KingdomPresidentInfoUpdate = 2406,

	EquipExpUp = 2407,
	EquipQualityUp = 2408,

	HeroEvolveCellSelect = 2409,
	HeroEvolveChoose = 2410,
	HeroEvolveSkillIconSelect = 2411,
	HeroEvolveSuccess = 2412,

	DecorationIconSelect = 2413,

	-- 聊天室相关
	ChatRoomCreate = 2420,
	ChatRoomDismiss = 2421,
	ChatRoomChangeName = 2422,
	MasteryExpUpdate = 2423,--专精经验增加

	RefreshDesertActivityInfoUpdate = 2430,
	DispatchGetRealPoint = 2455,
	RefreshBuildDataArr = 2517,--刷新建筑数据（一组）
	DeleteBuildDataArr = 2518,--删除建筑数据（一组）

	--功勛
	UpdateSelfExploit = 2440,

	ScratchOffGameRankInfoUpdate = 2441,
	ScratchOffGameRewardRecordInfoUpdate = 2442,
	ScratchOffGameActivityParamUpdate = 2443,
	ScratchOffGameRewardLotteryInfoUpdate = 2444,
	ScratchOffGameGetExtraReward = 2445,
	BackToScratchOff = 2446,
	ScratchOffGameSelectedHeroUpdate = 2447,

	MiningLotteryResInfoUpdate = 2460,
	MiningActParamInfoUpdate = 2461,
	TakeMiningCarReward = 2462,
	MiningQueueSpeedUp = 2463,
	MiningCarCompleted = 2464,
	MiningQueueUnlock = 2465,

	MysteriousActParamUpdate = 2470,
	MysteriousRankInfoUpdate = 2471,
	MysteriousLotteryUpdate = 2472,
	GetMysteriousStageReward = 2473,

	MissileInfoUpgrade = 2450,
	ChampionBattleGroupDataBack = 2451,

	HeroEvolveHeroInfoBack = 2453,
	EquipmentToggleClick = 2454,

	UpdateRewardControlInfo = 2456,
	MainMapTerrainLoadFinish = 2457,

	CrossWonderGetInfo = 2525,
	CrossWonderGetUserRank = 2526,
	CrossWonderGetUserRankReward = 2527,
	CrossWonderGetAllianceRank = 2528,
	CrossWonderGetAllianceRankReward = 2529,

	EdenKillGetRank = 2530,
	EdenKillGetRankReward = 2531,

	TurfWarGetInfo = 2532,
	
	StoryGetInfo = 2533,
	StoryReceiveStageReward = 2534,
	StoryLevelReward = 2535,
	StoryUpdateHangupTime = 2536,
	StoryGetHangupReward = 2537,
	StoryReceiveHangupReward = 2538,
	StoryGetRank = 2539,
	
	CloseSelectHero = 2540,
	
	WatchAdReceive = 2541,
	WatchAdFail = 2542,
	
	FurnitureUpgrade = 2543,
	FurnitureCreateObject = 2544,
	VitaMatterChange = 2545,
	
	VitaSegmentChange = 2546,
	VitaDataUpdate = 2547,
	VitaSetResidentWork = 2548,
	VitaFireStateChange = 2549,
	VitaDayNightChange = 2550,
	VitaChangeTime = 2551,
	
	LandStartPve = 2552,
	LandFinishPve = 2553,
	LandUnlockBlock = 2554,
	LandUnlockZone = 2555,
	LandReceiveReward = 2556,
	LandDataRefresh = 2557,
	VitaDayNightChangeAnimUI = 2558,
	CityResidentInitFinish = 2560,
	FogLoadComplete = 2561,
	BuildLvUpChangeRange = 2562,
	CityResidentQueueTimeChanged = 2563,
	
	ForceSetPointLightRangeValueForGuide = 2564,
	ForceResetPointLightRangeValue = 2565,
	
	CityResidentEnterBuilding = 2566,
	CityResidentExitBuilding = 2567,
	CityResidentEnterFurniture = 2568,
	CityResidentExitFurniture = 2569,
	ForceSetLight1Value = 2570,
	
	VitaLevelUp = 2571,
	VitaSetResidentWorkBatch = 2572,
	VitaZombieAttackDead = 2573,
	
	BuildingStaminaChanged = 2574,
	CitySiegeTypeChanged = 2575,
	CityResidentMoveComplete = 2576,
	VitaZombieAttackSick = 2577,
	
	-- 合成
	MergeEnter = 2600,
	MergeExit = 2601,
	MergeProduct = 2602,
	MergeUse = 2603,
	MergeMerge = 2604,
	MergeSwap = 2605,
	MergeBag = 2606,
	MergeDelete = 2607,
	MergePopReady = 2608,
	MergePopBag = 2609,
	MergeFightMonster = 2610,
	MergeNewMonster = 2611,
	MergeUpdateItem = 2612,
	MergeUpdateSlot = 2613,
	MergeDeleteItem = 2614,
	MergeClearItemCd = 2615,
	MergePlaceHero = 2616,
	MergeRetractHero = 2617,
	MergeShowCellDetail = 2618,
	MergeFeed = 2619,
	MergeExitBackCity = 2620,--退出合成回到主城
	WaitMergeExit = 2621,--合成页面处于等待关闭状态
	MergeEnterAfterLoading = 2622,--完全进入合成loading关闭
	MergeLevelUpdate = 2623,
	MergeExpandBag = 2624,
	MergeGetLevelRewardInfo = 2625,
	MergeMainSetShowOrder = 2626,
	
	OpinionGetInfo = 2627,
	OpinionGetHistory = 2628,
	OpinionUpdate = 2629,
	OpinionChooseMail = 2630,
	
	PveHeroHpUpdate = 2631,
	PveHeroAngerUpdate = 2632,
	PveHeroUseSkill = 2633,
	PveHeroSkillCdUpdate = 2634,

	RefreshDrakeBoss = 2641,--德雷克boss活动数据变化
	OnTouchPinchCameraNear = 2642,--双指缩放镜头拉近
	OnTouchPinchCameraFar = 2643,--双指缩放镜头远离
	
	QualityChange = 2644,--品质调整
	ShowStoryRewardBubble = 2645,--显示挂机奖励气泡（25%）

	RefreshHeroMonthCard = 2646,
	DailyQuestGetAllTaskReward = 2647,

	GetDailyPackageInfos = 2650,
	DailyPackageSelectHero = 2651,

	CitySiegeUpdate = 2652,
	CitySiegeStateChange = 2653,
	CityResidentManagerInit = 2654,
	CityZombieInvadeChange = 2655,
	VitaResidentTaskUpdate = 2656,
	VitaResidentTaskFinish = 2657,
	CityWallBroken = 2658,
	
	SaveGuide = 2659,

	-- LW PVE
	ZombieBattleDestroy = 2700, -- 退出推图关卡
	LWBattleBuffStart = 2701, -- 战斗buff开始
	LWBattleBuffEnd = 2702, -- 战斗buff结束
	HidePVEFormationPanel = 2703, -- 隐藏PVE队伍界面
	PVEBuffAdded = 2704, -- PVE加速buff添加
	PVEBuffRemoved = 2705, -- PVE加速buff移除
	PVEWin = 2706, -- PVE胜利
	PVELose = 2707, -- PVE失败
	BossEnterBattle = 2708,
	BattleZombiesEnter = 2709, -- 僵尸涌入
	SquadSuperArmorStateChange = 2710, -- 小队霸体状态变更
	BarrageWinConditionRefresh = 2711,
	PlayPlotGroup = 2712,
	PlayPlotBubble = 2713,
	PlayPlotBubbleRandomly = 2714,
	PlotGroupStart = 2715,
	PlotGroupDone = 2716,
	ParkourBattleStart = 2717,
	ParkourBattleWin = 2718,
	ParkourWinConditionRefresh = 2719,
	ParkourBossEnterBattle = 2720,
	OnPVEBattleGetGoods = 2721,
	CountBattleReward = 2722,
	PVEBattleVictoryConfirmed = 2723,
	ParkourBattleEnterComplete = 2724,--战斗完全进入

	HeroEquipUpgrade = 2725,--装备升级
	HeroEquipPromotion = 2726,--装备晋升
	HeroEquipInstall = 2727,--穿装备
	HeroEquipUninstall = 2728,--脱装备
	HeroEquipStartProduct = 2729,--装备合成
	HeroEquipDecompose = 2730,--装备分解
	HeroEquipAdd = 2731,--新装备
	HeroEquipMaterialCompose = 2732,--装备材料合成
	HeroEquipMaterialDecompose = 2733,--装备材料合成

	HeroEquipModelUpdate = 2734,
	OnSelectMakePartEquip = 2735,
	OnSelectTakePartEquip = 2736,
	OnSelectEquipMaterialCompose = 2737,
	OnSelectEquipMaterialDecompose = 2738,
	HeroEquipQueueFinish = 2739,

	HeroStarStoryResult = 2740, -- 英雄背景故事奖励领取更新
	ActivityTipStateUpdate = 2741,-- 活动提示弹出限制状态更新

	OnPassWeek = 2742, -- 过周
	OnDailyMustBuyDataChanged = 2743, -- 每日必买数据变更
	RefreshResourceItem = 2744,

	WorldBuildTopBubblePlot = 2745, -- 世界建筑头顶显示对话
	HelpDetectEndEffectBubbleShow = 2746, -- 世界建筑帮助完成特效

	OnSelectWelfareTypeChange = 2747, -- 福利中心选择页签变化
	
	-- LW PVE end
	NeedMailIdentify = 4997,
	SDK_PermissionRecv = 4998,
	PUSH_INIT_OK = 4999,
	SU_ForceDestroyLoadingListener = 5000,
	
}
return ConstClass("EventId", EventId)
