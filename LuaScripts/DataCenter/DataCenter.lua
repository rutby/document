

local Managers =
{
    WorldMarchDataManager = "DataCenter.WorldMarchDataManager.WorldMarchDataManager",
    WorldMarchBattleManager = "DataCenter.WorldMarchDataManager.WorldMarchBattleManager",
    SeasonDataManager = "DataCenter.SeasonManager.SeasonDataManager",
    AccountListManager = "DataCenter.AccountData.AccountListManager",
    AccountManager = "DataCenter.AccountData.AccountManager",
    ActivityController = "DataCenter.ActivityListData.ActivityController",
    ActivityListDataManager = "DataCenter.ActivityListData.ActivityListDataManager",
    DailyActivityManager = "DataCenter.ActivityListData.DailyActivityManager",
    ActPersonalArmsInfo = "DataCenter.ActivityListData.ActPersonalArmsInfo",
    ActLuckyRollInfo = "DataCenter.ActivityListData.ActLuckyRollInfo",
    ActBattlePassData = "DataCenter.ActivityListData.ActBattlePassData",
    ActGolloesCardData = "DataCenter.ActivityListData.ActGolloesCardData",
    ActBattlePassTemplateManager = "DataCenter.ActivityListData.ActBattlePassTemplateManager",
    ActSevenDayData = "DataCenter.ActivityListData.ActSevenDayData",
    ActMonsterTowerData = "DataCenter.ActivityListData.ActMonsterTowerData",
    ActSevenLoginData = "DataCenter.ActivityListData.ActSevenLogin.ActSevenLoginData",
    ActGiftBoxData = "DataCenter.ActivityListData.ActGiftBoxData",
    ActSeasonWeekCardData = "DataCenter.ActivityListData.SeasonWeekCard.ActSeasonWeekCardData",
    AllianceCityTipManager = "DataCenter.AllianceCityTip.AllianceCityTipManager",
    AllianceCityTemplateManager = "DataCenter.AllianceCity.AllianceCityTemplateManager",
    WorldDesertRefreshTemplateManager = "DataCenter.WorldDesertRefresh.WorldDesertRefreshTemplateManager",
    DesertTemplateManager = "DataCenter.DesertData.DesertTemplateManager",
    AllianceDeclareWarManager = "DataCenter.AllianceCity.AllianceDeclareWarManager",
    AllianceCompeteDataManager = "DataCenter.AllianceCompete.AllianceCompeteDataManager",
    LeagueMatchManager = "DataCenter.AllianceCompete.LeagueMatchManager",
    AllianceMergeManager = "DataCenter.AllianceData.AllianceMergeManager",
    AllianceBaseDataManager = "DataCenter.AllianceData.AllianceBaseDataManager",
    AllianceAutoInviteManager = "DataCenter.AllianceData.AllianceAutoInviteManager",
    AllianceLeaderElectManager = "DataCenter.AllianceData.AllianceLeaderElectManager",
    AlLeaderElectManager = "DataCenter.AllianceData.AlLeaderElectManager",
    AllianceLeaderManager = "DataCenter.AllianceData.AllianceLeaderManager",
    AllianceTaskManager = "DataCenter.AllianceData.AllianceTaskManager",
    AllianceStorageManager = "DataCenter.AllianceData.AllianceStorageManager",
    AllianceDonateRankDataManager = "DataCenter.AllianceData.AllianceDonateRankDataManager",
    AllianceGiftDataManager = "DataCenter.AllianceData.AllianceGiftDataManager",
    AllianceHelpDataManager = "DataCenter.AllianceData.AllianceHelpDataManager",
    AllianceMemberDataManager = "DataCenter.AllianceData.AllianceMemberDataManager",
    AllianceScienceDataManager = "DataCenter.AllianceData.AllianceScienceDataManager",
    AllianceShopDataManager = "DataCenter.AllianceData.AllianceShopDataManager",
    AllianceTempListManager = "DataCenter.AllianceData.AllianceTempListManager",
    AllianceWarDataManager = "DataCenter.AllianceData.AllianceWarDataManager",
    AllianceAlertDataManager = "DataCenter.AllianceData.AllianceAlertDataManager",
    AllianceHelpVirtualMarchManager = "DataCenter.AllianceHelpVirtualMarchManager.AllianceHelpVirtualMarchManager",
    AllianceMainManager = "DataCenter.AllianceData.AllianceMainManager",
    AllianceCityLogManager ="DataCenter.AllianceData.AllianceCityLogManager",
    AllWorldsManager = "DataCenter.AllWorldsData.AllWorldsManager",
    ArmyFormationDataManager = "DataCenter.ArmyFormationData.ArmyFormationDataManager",
    CommonShopManager = "DataCenter.CommonShop.CommonShopManager",
    WeekCardManager = "DataCenter.WeekCard.WeekCardManager",
    ArmyManager = "DataCenter.ArmyManager.ArmyManager",
    ArmyTemplateManager = "DataCenter.ArmyManager.ArmyTemplateManager",
    ArrowManager = "DataCenter.ArrowManager.ArrowManager",
    BirthPointTemplateManager = "DataCenter.BirthPointManager.BirthPointTemplateManager",
    BookMarkManager = "DataCenter.BookMarkManager.BookMarkManager",
    MineCaveManager = "DataCenter.ActivityListData.MineCaveManager",
    DigActivityManager = "DataCenter.ActivityListData.DigActivityManager",
    AlContributeManager = "DataCenter.AlContribute.AlContributeManager",
    HeroGrowthActivityManager = "DataCenter.ActivityListData.HeroGrowthActivityManager",
    JigsawPuzzleManager = "DataCenter.ActivityListData.JigsawPuzzleManager",
    ThemeActivityManager = "DataCenter.ActivityListData.ThemeActivityManager",
    RobotWarsManager = "DataCenter.ActivityListData.RobotWarsManager",
    PaidLotteryManager = "DataCenter.PaidLottery.PaidLotteryManager",
    SeasonPassManager = "DataCenter.ActivityListData.SeasonPassManager",
    BuildBubbleManager = "DataCenter.BuildBubbleManager.BuildBubbleManager",
    BuildUpgradeEffectManager = "DataCenter.BuildEffectManager.BuildUpgradeEffectManager",
    BuildManager = "DataCenter.BuildManager.BuildManager",
    BuildTemplateManager = "DataCenter.BuildManager.BuildTemplateManager",
    BuildQueueManager = "DataCenter.BuildQueueManager.BuildQueueManager",
    BuildQueueTemplateManager = "DataCenter.BuildQueueManager.BuildQueueTemplateManager",
    BuildQueueTalkManager = "DataCenter.BuildQueueTalkManager.BuildQueueTalkManager",
    UavDialogueTemplateManager = "DataCenter.BuildQueueTalkManager.UavDialogueTemplateManager",
    ChapterTaskManager = "DataCenter.ChapterTaskData.ChapterTaskManager",
    ChapterTemplateManager = "DataCenter.ChapterTaskData.ChapterTemplateManager",
    ChapterTaskCellManager = "DataCenter.ChapterTaskData.ChapterTaskCellManager",
    CityManageDataManager = "DataCenter.CityManageData.CityManageDataManager",
    DailyTaskManager = "DataCenter.DailyTaskData.DailyTaskManager",
    DefenceWallDataManager = "DataCenter.DefenceWallDataManager.DefenceWallDataManager",
    DecResourceEffectManager = "DataCenter.FlyEffectManager.DecResourceEffectManager",
    DropResourceEffectManager = "DataCenter.FlyEffectManager.DropResourceEffectManager",
    FlyResourceEffectManager = "DataCenter.FlyEffectManager.FlyResourceEffectManager",
    FormationAssistanceDataManager = "DataCenter.FormationAssistanceDataManager.FormationAssistanceDataManager",
    GotoMoveBubbleManager = "DataCenter.GotoMoveBubbleManager.GotoMoveBubbleManager",
    GuideCityAnimManager = "DataCenter.GuideCityManager.GuideCityAnimManager",
    GuideCityManager = "DataCenter.GuideCityManager.GuideCityManager",
    GuideManager = "DataCenter.GuideManager.GuideManager",
    GuideTemplateManager = "DataCenter.GuideManager.GuideTemplateManager",
    HeroDataManager = "DataCenter.HeroData.HeroDataManager",
    LotteryDataManager = "DataCenter.HeroData.LotteryDataManager",
    HospitalManager = "DataCenter.HospitalData.HospitalManager",
    ItemData = "DataCenter.ItemData.ItemData",
    ItemManager = "DataCenter.ItemManager.ItemManager",
    ItemTemplateManager = "DataCenter.ItemManager.ItemTemplateManager",
    PveHeroTemplateManager = "DataCenter.PveHero.PveHeroTemplateManager",
    StatusManager = "DataCenter.ItemManager.StatusManager",
    MailDataManager = "DataCenter.MailData.MailDataManager",
    MailTranslateManager = "DataCenter.MailData.MailTranslateManager",
    MonsterManager = "DataCenter.MonsterManager.MonsterManager",
    MonsterTemplateManager = "DataCenter.MonsterManager.MonsterTemplateManager",
    PayManager = "DataCenter.PayManager.PayManager",
    PinManager = "DataCenter.AccountData.PinManager",
    PlayerInfoDataManager = "DataCenter.PlayerData.PlayerInfoDataManager",
    PushNoticeManager = "DataCenter.PushNoticeManager.PushNoticeManager",
    PushUtil = "DataCenter.PushNoticeManager.PushUtil",
    PushSettingData = "DataCenter.PushSettingData.PushSettingData",
    QuestTemplateManager = "DataCenter.QuestManager.QuestTemplateManager",
    QueueDataManager = "DataCenter.QueueData.QueueDataManager",
    RadarAlarmDataManager = "DataCenter.RadarAlarmData.RadarAlarmDataManager",
    DetectEventTemplateManager = "DataCenter.RadarCenterDataManager.DetectEventTemplateManager",
    FakeCollectGarbageMarchManager = "DataCenter.RadarCenterDataManager.FakeCollectGarbageMarchManager",
    FakeHelperMarchManager = "DataCenter.RadarCenterDataManager.FakeHelperMarchManager",
    FakeRescueMarchManager = "DataCenter.RadarCenterDataManager.FakeRescueMarchManager",
    RadarCenterDataManager = "DataCenter.RadarCenterDataManager.RadarCenterDataManager",
    RankDataManager = "DataCenter.RankData.RankDataManager",
    ResLackManager = "DataCenter.ResLackTips.ResLackManager",
    ResourceManager = "DataCenter.ResourceManager.ResourceManager",
    ResourceTemplateManager = "DataCenter.ResourceManager.ResourceTemplateManager",
    RewardManager = "DataCenter.RewardManager.RewardManager",
    ScienceManager = "DataCenter.ScienceData.ScienceManager",
    ScienceDataManager = "DataCenter.ScienceData.ScienceDataManager",
    ScienceTemplateManager = "DataCenter.ScienceData.ScienceTemplateManager",
    StrongestCommanderDataManager = "DataCenter.ActivityListData.StrongestCommanderDataManager",
    ActivityPuzzleDataManager = "DataCenter.ActivityListData.ActivityPuzzleDataManager",
    TaskManager = "DataCenter.TaskData.TaskManager",
    NationTemplateManager = "DataCenter.NationTemplateManager.NationTemplateManager",
    UINoInputManager = "DataCenter.UINoInputManager.UINoInputManager",
    UnlockDataManager = "DataCenter.UnlockData.UnlockDataManager",
    UserBindManager = "DataCenter.UserBindManager.UserBindManager",
    WelfareDataManager = "DataCenter.WelfareListData.WelfareListDataManager",
    WorldFavoDataManager = "DataCenter.WorldFavoData.WorldFavoDataManager",
    WorldPointDetailManager = "DataCenter.WorldPointDetail.WorldPointDetailManager",
    WorldPointManager = "DataCenter.WorldPointManager.WorldPointManager",
    MonthCardNewManager = "DataCenter.MonthCardNewManager.MonthCardNewManager",
    GolloesCampManager = "DataCenter.GolloesCampManager.GolloesCampManager",
    AllianceMineManager = "DataCenter.AllianceMine.AllianceMineManager",
    ArenaManager = "DataCenter.ArenaManager.ArenaManager",
    WorldAllianceCityDataManager = "DataCenter.WorldAllianceCityData.WorldAllianceCityDataManager",
    VIPManager = "DataCenter.VIPData.VIPManager",
    VIPTemplateManager = "DataCenter.VIPData.VIPTemplateManager",
    CollectRewardDataManager = "DataCenter.CollectRewardData.CollectRewardDataManager",
    UnlockBtnManager = "DataCenter.UnlockBtnManager.UnlockBtnManager",
    UnlockBtnTemplateManager = "DataCenter.UnlockBtnManager.UnlockBtnTemplateManager",
    CityPointManager = "DataCenter.CityPointManager.CityPointManager",
    ArrowTipTemplateManager = "DataCenter.ArrowTipManager.ArrowTipTemplateManager",
    FlyController = "DataCenter.FlyController.FlyController",
    HeroStationManager = "DataCenter.HeroStation.HeroStationManager",
    HeroStationSkillTemplateManager = "DataCenter.HeroStation.HeroStationSkillTemplateManager",

    -- 砍伐管理器
    CityNpcManager = "DataCenter.CityNpcManager.CityNpcManager",

    BattleLevel = "Scene.PVEBattleLevel.BattleLevel",

    ActChampionBattleManager = "DataCenter.ActChampionBattleManager.ActChampionBattleManager",
    UIPopWindowManager = "DataCenter.UIPopWindowManager.UIPopWindowManager",
    LoginPopManager = "DataCenter.LoginPopManager.LoginPopManager",
    SecondConfirmManager = "DataCenter.SecondConfirmManager.SecondConfirmManager",
    DailyTaskTemplateManager = "DataCenter.DailyTaskTemplateManager.DailyTaskTemplateManager",
    AllianceRedPacketManager = "DataCenter.AllianceRedPacketManager.AllianceRedPacketManager",
    GarageRefitManager = "DataCenter.GarageRefit.GarageRefitManager",
    WorldTrendManager = "DataCenter.WorldTrendManager.WorldTrendManager",
    WorldTrendTemplateManager = "DataCenter.WorldTrendManager.WorldTrendTemplateManager",
    AllianceCareerManager = "DataCenter.AllianceCareerManager.AllianceCareerManager",
    AllianceCareerTemplateManager = "DataCenter.AllianceCareerManager.AllianceCareerTemplateManager",
    WorldNewsDataManager = "DataCenter.WorldNewsData.WorldNewsDataManager",
    HeroMonthCardManager = "DataCenter.HeroMonthCardManager.HeroMonthCardManager",
    QNManager = "DataCenter.QuestionnaireManager.QNManager",
    ActBossDataManager = "DataCenter.ActBossDataManager.ActBossDataManager",
    WorldLodManager = "DataCenter.WorldLod.WorldLodManager",
    PveZombieTemplateManager = "DataCenter.PveZombie.PveZombieTemplateManager",
    CumulativeRechargeManager = "DataCenter.CumulativeRechargeManager.CumulativeRechargeManager",
    WoundedCompensateManager = "DataCenter.WoundedCompensate.WoundedCompensateManager",
    WoundedCompensateData = "DataCenter.WoundedCompensate.WoundedCompensateData",

    HeroEffectSkillManager = "DataCenter.HeroEffectSkill.HeroEffectSkillManager",
    ActivityPuzzleMonsterTemplateManager = "DataCenter.ActivityListData.ActivityPuzzleMonsterTemplateManager",
    HeroEntrustManager = "DataCenter.HeroEntrustManager.HeroEntrustManager",
    HeroEntrustTemplateManager = "DataCenter.HeroEntrustManager.HeroEntrustTemplateManager",
    HeroEntrustBubbleManager = "DataCenter.HeroEntrustBubbleManager.HeroEntrustBubbleManager",

    HeroOfficialManager = "DataCenter.HeroOfficial.HeroOfficialManager",
    HeroIntensifyManager = "DataCenter.HeroIntensify.HeroIntensifyManager",

    TalentTemplateManager = "DataCenter.TalentManager.TalentTemplateManager",
    TalentTemplate = "DataCenter.TalentManager.TalentTemplate",
    TalentDataManager = "DataCenter.TalentManager.TalentDataManager",
    TalentData = "DataCenter.TalentManager.TalentData",
    TalentTypeTemplateManager = "DataCenter.TalentManager.TalentTypeTemplateManager",
    TalentTypeTemplate = "DataCenter.TalentManager.TalentTypeTemplate",

    GuideNeedLoadManager = "DataCenter.GuideCityManager.GuideNeedLoadManager",
    HeroBountyDataManager = "DataCenter.HeroBountyDataManager.HeroBountyDataManager",
    ShaderEffectManager = "DataCenter.ShaderEffectManager.ShaderEffectManager",
    WorldBuildBubbleManager = "DataCenter.BuildBubbleManager.WorldBuildBubbleManager",
    WorldNoticeManager = "DataCenter.WorldNoticeManager.WorldNoticeManager",
    MineRootPlaceEffectManager = "Scene.MineRootPlaceEffect.MineRootPlaceEffectManager",
    MineCanNotPutRoadEffectManager = "Scene.MineCanNotPutRoadEffect.MineCanNotPutRoadEffectManager",
    DesertDataManager = "DataCenter.DesertData.DesertDataManager",
    HeroLackTipTemplateManager = "DataCenter.HeroLackTipManager.HeroLackTipTemplateManager",
    HeroLackTipManager = "DataCenter.HeroLackTipManager.HeroLackTipManager",
    CityLabelManager = "DataCenter.CityLabelManager.CityLabelManager",
    DecorationTemplateManager = "DataCenter.DecorationDataManager.DecorationTemplateManager",
    DecorationDataManager = "DataCenter.DecorationDataManager.DecorationDataManager",
    FormStatusManager = "DataCenter.FormStatus.FormStatusManager",
    BuildStatusManager = "DataCenter.BuildStatus.BuildStatusManager",
    KeepPayManager = "DataCenter.KeepPay.KeepPayManager",
    ChainPayManager = "DataCenter.ChainPay.ChainPayManager",
    DetectEventBubbleManager = "DataCenter.RadarCenterDataManager.DetectEventBubbleManager",
    WorldBuildTimeManager = "DataCenter.BuildTimeManager.WorldBuildTimeManager",
    LuckyShopManager = "DataCenter.LuckyShopManager.LuckyShopManager",
    CampEffectManager = "DataCenter.CampEffect.CampEffectManager",
    DeadArmyRecordManager = "DataCenter.ArmyManager.DeadArmyRecordManager",
    DecorationGiftPackageManager = "DataCenter.DecorationGiftPackageManager.DecorationGiftPackageManager",
    SeasonWeekManager = "DataCenter.SeasonWeek.SeasonWeekManager",
    PveAnimationTemplateManager = "DataCenter.PveAnimation.PveAnimationTemplateManager",
    PveActVFXTemplateManager = "DataCenter.PveVFX.PveActVFXTemplateManager",
    PveVFXTemplateManager = "DataCenter.PveVFX.PveVFXTemplateManager",
    PveRolePartTemplateManager = "DataCenter.PveRolePart.PveRolePartTemplateManager",
    CityCameraManager = "DataCenter.CityCameraManager.CityCameraManager",
    WorldCameraManager = "DataCenter.WorldCameraManager.WorldCameraManager",
    GloryManager = "DataCenter.Glory.GloryManager",
    SeasonGroupManager = "DataCenter.SeasonGroup.SeasonGroupManager",
    MasteryManager = "DataCenter.Mastery.MasteryManager",
    DesertOperateManager = "DataCenter.DesertOperate.DesertOperateManager",
    DesertAnnexManager = "DataCenter.DesertAnnex.DesertAnnexManager",
    CrossWormManager = "DataCenter.CrossWorm.CrossWormManager",
    StoryManager = "DataCenter.Story.StoryManager",

    EquipmentDataManager = "DataCenter.EquipmentManager.EquipmentDataManager",
    EquipmentTemplateManager = "DataCenter.EquipmentManager.EquipmentTemplateManager",
    EquipmentSuitTemplateManager = "DataCenter.EquipmentManager.EquipmentSuitTemplateManager",

    ActBlackKnightManager = "DataCenter.ActivityListData.ActBlackKnightManager",
    ActivityDonateSoldierManager = "DataCenter.ActivityDonateSoldier.ActivityDonateSoldierManager",
    GovernmentTemplateManager = "DataCenter.GovernmentManager.GovernmentTemplateManager",
    GovernmentManager = "DataCenter.GovernmentManager.GovernmentManager",
    GovernmentWorldBubbleManager = "DataCenter.GovernmentManager.GovernmentWorldBubbleManager",
    WonderGiftTemplateManager = "DataCenter.WonderGiftTemplateManager.WonderGiftTemplateManager",
    WorldGotoManager = "DataCenter.WorldGotoManager.WorldGotoManager",
    WorldAllianceCityRecordManager = "DataCenter.WorldAllianceCityRecord.WorldAllianceCityRecordManager",
    HeroEvolveActivityManager = "DataCenter.HeroEvolveActivityManager.HeroEvolveActivityManager",
    HeroMedalShopDataManager = "DataCenter.HeroMedalShop.HeroMedalShopDataManager",
    EffectTemplateManager = "DataCenter.EffectTemplateManager.EffectTemplateManager",
    PresidentMineRefreshManager = "DataCenter.PresidentMineRefreshManager.PresidentMineRefreshManager",
    StatusTemplateManager = "DataCenter.StatusTemplateManager.StatusTemplateManager",
    ActivityALVSDonateSoldierManager = "DataCenter.ActivityALVSDonateSoldier.ActivityALVSDonateSoldierManager",
    MissileManager = "DataCenter.ActivityListData.MissileManager",
    MigrateDataManager = "DataCenter.MigrateDataManager.MigrateDataManager",
    StaminaBallManager = "DataCenter.StaminaBallManager.StaminaBallManager",
    AllianceBossManager = "DataCenter.ActivityListData.AllianceBossManager",
    OfficerListTemplateManager = "DataCenter.OfficerListManager.OfficerListTemplateManager",
    ScratchOffGameManager = "DataCenter.ScratchOffGame.ScratchOffGameManager",
    MiningManager = "DataCenter.Mining.MiningManager",
    MysteriousManager = "DataCenter.Mysterious.MysteriousManager",
    ScratchOffGameManager = "DataCenter.ScratchOffGame.ScratchOffGameManager",
    HeroPluginManager = "DataCenter.HeroPluginManager.HeroPluginManager",
    EdenPassTemplateManager = "DataCenter.EdenPassTemplate.EdenPassTemplateManager",
    EdenAreaTemplateManager = "DataCenter.EdenAreaTemplate.EdenAreaTemplateManager",
    RandomPlugTemplateManager = "DataCenter.HeroPluginManager.RandomPlugTemplateManager",
    RandomPlugCostTemplateManager = "DataCenter.HeroPluginManager.RandomPlugCostTemplateManager",
    ActDragonManager = "DataCenter.ActDragonManager.ActDragonManager",
    DragonBuildTemplateManager = "DataCenter.DragonBuildData.DragonBuildTemplateManager",
    HeroPluginRankManager =  "DataCenter.HeroPluginManager.HeroPluginRankManager",
    HeroMedalRedemptionManager =  "DataCenter.HeroMedalRedemptionManager.HeroMedalRedemptionManager",
    HeroLevelUpTemplateManager =  "DataCenter.HeroLevelUpTemplateManager.HeroLevelUpTemplateManager",
    ActFirstChargeData =  "DataCenter.FirstChargeData.ActFirstChargeData",
    SteamPriceTemplateManager = "DataCenter.SteamPriceTemplate.SteamPriceTemplateManager",
    RadarBossManager = "DataCenter.RadarBossManager.RadarBossManager",
    ChangeNameAndPicManager = "DataCenter.ActivityListData.ChangeNameAndPic.ChangeNameAndPicManager",
    WatchAdManager = "DataCenter.WatchAd.WatchAdManager",
    GoogleAdsManager = "DataCenter.GoogleAdsManager.GoogleAdsManager",
    UnityAdsManager = "DataCenter.UnityAdsManager.UnityAdsManager",
    CountryRatingData = "DataCenter.ActivityListData.CountryRatingData",
    VitaManager = "DataCenter.Vita.VitaManager",
    OpinionManager = "DataCenter.Opinion.OpinionManager",
    FurnitureManager = "DataCenter.FurnitureManager.FurnitureManager",
    StormManager = "DataCenter.StormManager.StormManager",
    CityHudManager = "DataCenter.CityHud.CityHudManager",
    FurnitureObjectManager = "DataCenter.FurnitureManager.FurnitureObjectManager",
    CityResidentManager = "DataCenter.CityResident.CityResidentManager",
    CityResidentMovieManager = "DataCenter.CityResident.CityResidentMovieManager",
    CitySiegeManager = "DataCenter.CitySiege.CitySiegeManager",
    CityWallManager = "DataCenter.CityWall.CityWallManager",
    FurnitureEffectManager = "DataCenter.BuildEffectManager.FurnitureEffectManager",
    BuildCityBuildManager = "DataCenter.BuildManager.BuildCityBuildManager",
    BuildCanCreateManager = "DataCenter.BuildEffectManager.BuildCanCreateManager",
    ZeroTreeManager = "DataCenter.BuildEffectManager.ZeroTreeManager",
    BuildWallEffectManager = "DataCenter.ShaderEffectManager.BuildWallEffectManager",
    LandManager = "DataCenter.Land.LandManager",
    FogManager = "DataCenter.Fog.FogManager",
    ActDrakeBossManager = "DataCenter.ActivityListData.ActDrakeBossManager.ActDrakeBossManager",
    BuildEffectManager = "DataCenter.BuildEffectManager.BuildEffectManager",
    WaitTimeManager = "DataCenter.WaitTimeManager.WaitTimeManager",
    BuildFogEffectManager = "DataCenter.BuildEffectManager.BuildFogEffectManager",
    DailyPackageManager = "DataCenter.DailyPackageManager.DailyPackageManager",
    -- LW PVE
    LWSoundManager = "DataCenter.LWSound.LWSoundManager",
    LWBattleManager = "DataCenter.LWBattle.LWBattleManager",
    LWTriggerItemTemplateManager = "DataCenter.LWTriggerItem.LWTriggerItemTemplateManager",
    LWBuffTemplateManager = "DataCenter.LWBuff.LWBuffTemplateManager",
    ZombieBattleManager = "DataCenter.ZombieBattle.ZombieBattleManager",
    PveLevelTemplateManager = "DataCenter.PveLevel.PveLevelTemplateManager",
    PveMonsterTemplateManager = "DataCenter.PveMonster.PveMonsterTemplateManager",
    PveHeroEffectTemplateManager = "DataCenter.PveHeroEffect.PveHeroEffectTemplateManager",
    PveSkillEffectTemplateManager = "DataCenter.PveSkillEffect.PveSkillEffectTemplateManager",
    PveBulletTemplateManager = "DataCenter.PveBullet.PveBulletTemplateManager",
    AppearanceTemplateManager = "DataCenter.HeroData.AppearanceTemplateManager",
    HeroSkillTemplateManager = "DataCenter.HeroSkillTemplateManager.HeroSkillTemplateManager",
    BellManager = "DataCenter.BellManager.BellManager",
    EffectSceneManager = "DataCenter.BuildEffectManager.EffectSceneManager",
    WaitUpdateManager = "DataCenter.WaitTimeManager.WaitUpdateManager",
    HeroStarStoryManager = "DataCenter.HeroStarStoryDataManager.HeroStarStoryManager",
    -- LW PVE end
	HeroEquipManager = "DataCenter.HeroEquipManager.HeroEquipManager",
    HeroEquipTemplateManager = "DataCenter.HeroEquipManager.HeroEquipTemplateManager",
    HeroEquipMaterialConfigManager = "DataCenter.HeroEquipManager.HeroEquipMaterialConfigManager",
    HeroEquipUpgradeTemplateManager = "DataCenter.HeroEquipManager.HeroEquipUpgradeTemplateManager",
    HeroEquipPromoteTemplateManager = "DataCenter.HeroEquipManager.HeroEquipPromoteTemplateManager",
    FurnitureProductManager = "DataCenter.FurnitureManager.FurnitureProductManager",
    ActivityTipManager = "DataCenter.ActivityTipManager.ActivityTipManager",
    TaskFlipManager = "DataCenter.TaskData.TaskFlipManager",
    ActDispatchTaskFakeMarchManager = "DataCenter.ActivityListData.ActDispatchTaskFakeMarchManager",
    ActDispatchTaskDataManager = "DataCenter.ActivityListData.ActDispatchTaskDataManager",
    DailyMustBuyManager = "DataCenter.DailyMustBuy.DailyMustBuyManager",
}


return setmetatable({}, { __index = function(t, k)
    local manager = Managers[k]
    if manager ~= nil then
        local type = require(manager)
        local inst = type.New()
        t[k] = inst
        return inst
    end
    return nil
end})