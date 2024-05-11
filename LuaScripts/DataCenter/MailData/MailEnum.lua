--[[
	邮件中一些常用的枚举
	
]]


MailType =
{
	MAIL_SYSTEM = 2,--系统邮件
	MAIL_SYSTEM_EXTRA = 3,--系统邮件附加
	MAIL_SCOUT_RESULT = 8,--侦察
	MAIL_SCOUT_ALERT = 9,--被侦察
	MAIL_WOUNDED = 11,--伤兵
	MAIL_GM = 13, -- GM
	MAIL_UPDATE = 16,
	MAIL_ALLIANCE_ALL = 20,--联盟全体邮件
	MAIL_SELF_SEND =21,--玩家自己发送的邮件
	MAIL_USER = 22,--收到的个人邮件
	GIFT_BUY_EXCHANGE =34,--礼包购买
	MAIL_BOSS_REWARD = 36, -- 集结boss奖励
	MAIL_PRESIDENT_SEND = 45,--总统发本要塞所有指挥官邮件
	VIP_REWARD = 66,--vip免费奖励
	NEW_FIGHT = 72,--战报
	NEW_COLLECT_MAIL =73,--采集邮件
	MAIL_FIRST_JOIN_ALLIANCE = 74, --联盟首次加入
	MAIL_JOIN_ALLIANCE = 75, -- 加入联盟
	MAIL_ALCOMPETE_REWARD = 77,--联盟军备周奖励
	MAIL_ALCOMPETE_WEEK_REPORT = 78,--联盟军备周结算
	ALLIANCE_CITY_OCCUPIED_REWARD = 79, -- 中立城市类型
	MAIL_ALLIANCE_MARK_ADD = 80,--联盟标记新增
	MAIL_PICK_GARBAGE = 81,--捡垃圾
	MAIL_EXPLORE = 82, --探险
	RESOURCE_HELP_FROM = 83,-- 收到资源帮助*/
	RESOURCE_HELP_TO = 84, --去资源帮助*/
	RESOURCE_HELP_FAIL = 85, --资源帮助失败*/
	MAIL_AL_LEADER_ELECT = 86,--参选盟主
	MAIL_AL_LEADER_VOTE = 87,--投票选择盟主
	MAIL_AL_AL_COMMON = 88,--联盟类型普通邮件（只有标题和文本）
	MAIL_AL_LEADER_CHANGE = 89,--盟主变更（当选盟主；盟主长期离线被顶掉）
	MONSTER_COLLECT_REWARD = 90,      --90 打怪奖励宝箱邮件 
	MARCH_DESTROY_MAIL = 91, --拆耐久邮件
	ELITE_FIGHT_MAIL = 93,   --冠军对决战斗邮件
	ALLIANCE_CITY_RANK = 94, --联盟城排行邮件
	MAIL_AL_ELECT_RESULT_R4 = 95,--联盟选举结果展示-R4
	MAIL_AL_ELECT_RESULT_LEADER = 96,--联盟选举结果展示-盟主
	MAIL_GOLLOES_TRADE_REWARDS = 97,--咕噜商队奖励
	MAIL_ALLIANCE_INVITE = 98,--联盟邀请
	COLLECT_ADDITION_REWARD = 100,--额外奖励邮件
	CHALLENGE_BOSS_REWARD = 101,--挑战boss邮件
	COLLECT_OVER_FLOW_MAIL = 102, --采集爆仓邮件
	MAIL_GIFT_RECEIVE = 103, --接受别人赠送礼物邮件
	PLACE_ALLIANCE_BUILD_MAIL = 104, --联盟中心放置邮件
	OFFICIAL_APPOINT_MAIL = 106, --官职任命邮件
	BE_KING = 107, --成为总统
	MIGRATE_APPLY = 108,--移民申请
	SHORT_KEEP_FIGHT_MAIL = 109, --只保留两天的战报
	NEW_FIGHT_EXPEDITIONARY_DUEL = 996,--远征对决
	NEW_FIGHT_BLACK_KNIGHT = 997,--黑骑士用
	NEW_FIGHT_ARENA = 998,--竞技场战报分享用
	NEW_FIGHT_MINECAVE = 999,--矿洞战报分享用
}

MailChannelType =
{
	Mail_Channel_System =0,
	Mail_Channel_Fight =1,
	Mail_Channel_Chat =2,
	Mail_Channel_Self =3
}

MailFightRoundReportType=
{
	DEFAULT =0,
	NORMAL_ATTACK =1,-- 普通攻击
	COUNTER_ATTACK = 2, -- 反击
	USE_SKILL =3, -- 使用技能
	DO_DAMAGE = 4, -- 造成伤害
	RECOVER_DAMAGE = 5, -- 恢复伤兵
	ADD_EFFECT = 6,-- 添加Buff
}


-- 邮件内置的类型，以后还可能增加
MailInternalGroup =
{
	MAIL_IN_system = 1,--系统
	MAIL_IN_report = 2,--打野  
	MAIL_IN_gather = 3,--采集邮件
	MAIL_IN_alliance = 4,--联盟
	MAIL_IN_favor = 5,	-- 收藏邮件
	MAIL_IN_scout = 6, 	--侦查
	MAIL_IN_resSupportFrom = 7,--邮件要放到一封里面，单独给一个group存数据，不参与显示
	MAIL_IN_resSupportTo = 8,--邮件要放到一封里面，单独给一个group存数据，不参与显示
	MAIL_IN_monsterReward = 9, -- 打怪奖励
	MAIL_IN_battle = 10,--战报
	MAIL_IN_blackKnight = 11,--黑骑士活动（极为特殊，不能通过邮件类型放置）
	MAIL_IN_expeditionaryDuel = 12,--远征对决活动（极为特殊，不能通过邮件类型放置）
	MAIL_IN_MAX = 12, -- 数量，必须要和最后一个有效值相同
}

-- 邮件类型到组类型
MailTypeToInternalGroup =
{
	[MailType.ALLIANCE_CITY_OCCUPIED_REWARD] = MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_GM]		= MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_UPDATE]		= MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_SYSTEM]		= MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_SYSTEM_EXTRA]		= MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_WOUNDED]		= MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_PICK_GARBAGE]		= MailInternalGroup.MAIL_IN_report,
	[MailType.MAIL_EXPLORE]		= MailInternalGroup.MAIL_IN_report,
	[MailType.MAIL_ALLIANCE_ALL] 		= MailInternalGroup.MAIL_IN_system,
	[MailType.GIFT_BUY_EXCHANGE] 	= MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_ALCOMPETE_WEEK_REPORT] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_ALLIANCE_MARK_ADD] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_AL_LEADER_ELECT] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_AL_LEADER_VOTE] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_AL_AL_COMMON] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_AL_LEADER_CHANGE] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_AL_ELECT_RESULT_R4] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_AL_ELECT_RESULT_LEADER] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_GOLLOES_TRADE_REWARDS] = MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_SCOUT_RESULT] 			= MailInternalGroup.MAIL_IN_battle,
	[MailType.RESOURCE_HELP_FROM] 			= MailInternalGroup.MAIL_IN_resSupportFrom,
	[MailType.RESOURCE_HELP_TO] 			= MailInternalGroup.MAIL_IN_resSupportTo,
	[MailType.RESOURCE_HELP_FAIL] 			= MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_SCOUT_ALERT] 			= MailInternalGroup.MAIL_IN_battle,
	[MailType.NEW_FIGHT] 			= MailInternalGroup.MAIL_IN_battle,
	[MailType.SHORT_KEEP_FIGHT_MAIL] 			= MailInternalGroup.MAIL_IN_battle,
	[MailType.MAIL_BOSS_REWARD]		= MailInternalGroup.MAIL_IN_report,
	[MailType.MONSTER_COLLECT_REWARD]		= MailInternalGroup.MAIL_IN_monsterReward,
	[MailType.NEW_COLLECT_MAIL] 	= MailInternalGroup.MAIL_IN_gather,
	[MailType.COLLECT_OVER_FLOW_MAIL] 	= MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_FIRST_JOIN_ALLIANCE] = MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_JOIN_ALLIANCE] 	= MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_FIRST_JOIN_ALLIANCE] 	= MailInternalGroup.MAIL_IN_alliance,
	[MailType.MARCH_DESTROY_MAIL] 	= MailInternalGroup.MAIL_IN_battle,
	[MailType.MAIL_ALLIANCE_ALL] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.ELITE_FIGHT_MAIL] 	= MailInternalGroup.MAIL_IN_battle,
	[MailType.ALLIANCE_CITY_RANK] 	= MailInternalGroup.MAIL_IN_alliance,
	[MailType.MAIL_ALCOMPETE_REWARD] = MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_ALLIANCE_INVITE] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.COLLECT_ADDITION_REWARD] 	= MailInternalGroup.MAIL_IN_system,
	[MailType.CHALLENGE_BOSS_REWARD]     = MailInternalGroup.MAIL_IN_report,
	[MailType.MAIL_GIFT_RECEIVE]     = MailInternalGroup.MAIL_IN_system,
	[MailType.PLACE_ALLIANCE_BUILD_MAIL] = MailInternalGroup.MAIL_IN_alliance,
	[MailType.NEW_FIGHT_BLACK_KNIGHT] = MailInternalGroup.MAIL_IN_report,
	[MailType.OFFICIAL_APPOINT_MAIL] = MailInternalGroup.MAIL_IN_system,
	[MailType.MAIL_PRESIDENT_SEND] = MailInternalGroup.MAIL_IN_system,
	[MailType.MIGRATE_APPLY] = MailInternalGroup.MAIL_IN_system,
	[MailType.BE_KING] = MailInternalGroup.MAIL_IN_system,
	[MailType.NEW_FIGHT_EXPEDITIONARY_DUEL] = MailInternalGroup.MAIL_IN_report,
	[MailType.VIP_REWARD]		= MailInternalGroup.MAIL_IN_system,
}

FightResult = {
	DEFAULT = -1,
	SELF_WIN = 0,
	OTHER_WIN = 1,
	DRAW = 2,	-- 平局
}

MailCombatUnitType = {
	ArmyCombatUnit = 1,
	CombineCombatUnit = 2,
	SimpleCombatUnit = 3,
	Unknow = 4
}

eMailSoldierAttr = {
	Total = "total",
	Lost = "lost",
	Wounded = "wounded",
	Injured = "injured",
	Dead = "dead",
	Cure = "cure",
}

eMailDetailItemType = {
	Title_Summary = 0,
	Title_Self = 1,
	Title_Other = 2,
	Content = 3,
	Title_Result = 4
}

eMailDetailTxtColor = {
	Green_Start = "<color=#228B22>",
	Red_Start = "<color=#CD2626>",
	End = "</color>"
}

eMailDetailTroopSide = {
	Self = 0,
	Other = 1
}
SpecialUnitType = {
	NONE = 0,
	ALLIANCE_CITY_NPC = 1, --联盟城守军
	BUILDING_STATION = 2, --建筑守军
	CITY_STATION = 3, --城市守军
	TEAM_LEADER = 4, --集结队长
	TEAM_MEMBER = 5, --集结成员
	PVE_MARCH = 6, --6 PVE行军
	PVE_MONSTER = 7, --7 PVE怪物
	ACT_BOSS = 8, --8 活动BOSS
	ARENA_NPC = 9, --9 竞技场NPC
	PUZZLE_BOSS = 10, --10 拼图BOSS
	CHALLENGE_BOSS = 11, -- 11 挑战BOSS
	DESERT_NPC = 12, --12 地块NPC
	ALLIANCE_CITY_POLICE_NPC = 13,--13 联盟城警备队
	ALLIANCE_BUILD_POLICE_NPC = 14,--14 联盟建筑警备队
	CITY_POLICE_NPC = 15,--玩家建筑守卫
	CROSS_WORM_STATION = 16,--跨服虫洞守军
	MONSTER_SIEGE = 17,--黑骑士
	TOWER = 18,--炮塔
	ALLIANCE_BOSS = 19,--联盟boss
	TRAP = 20,--陷阱
	ACT_ALLIANCE_MINE_GUARD = 21, --活动联盟矿守军
 }

GameEffectReason = 
{
	Science = 0, --科技
	Building = 1, --建筑
	Hero = 2, --英雄
	VIP = 3, --VIP
	MONTH_CARD = 4, --月卡
	PLAYER_LEVEL = 5, --玩家等级
	Hero_Station = 6, --英雄驻扎
	Science_Activity = 7, --科技活动（最强战区）
	Alliance_Science = 8, --联盟科技
	World_Alliance_City = 9, --联盟城市
	Status = 10, --buff
	Tank = 11,--车库改造
	Career = 12,--职业
	Alliance_Career = 13,--联盟职业
	Land = 14,--地块
	SERVER_EFFECT = 15,--服务器作用号
	BASE_TALENT = 16, --大本天赋
	HERO_OFFICIAL =17, --英雄官职
	ARTIFACT =18,--博物馆
	SKIN = 19,--皮肤
	SEASON_BATTLE_PASS = 20, --赛季battlepass
	SEASON_WEEK_CARD = 21, --赛季周卡
	HERO_INTENSIFY = 22, --英雄强化
	DESERT_TALENT = 23, --赛季天赋
	CAR_EQUIP = 24,--运兵车装备
	KINGDOM_POSITION = 25,--王座官职
	BUABLE = 26,--装饰建筑
	ARMY_SKILL = 27,--兵种技能
	HERO_PLUGIN = 28,--英雄插件
	FormationBuff = 100,--阵营buff --客户端用
	FormationRestraintValue = 101,--阵营克制 --客户端用
	ExtraAdd = 102,--额外加成 --客户端用
	Revenge = 103,--复仇
	EnemyDec = 104,--敌方提供的负面效果
}

AtkDefReason = {
	HERO = 0,
	SOLDIER_TOTAL = 1,
	--SOLDIER_NUM = 2,
	SCIENCE = 3,
	BUILDING = 4,
	--CAMP_VALUE = 5,
	FORMATION_STATUS = 6,
	TOWER_DMG = 7,
	TOWER_RANGE = 8,
}
BattleReportShowType =
{
	Total = 0,
	Atk =1,
	Def = 2,
	Soldier = 3,
	SoldierLevel = 4,
	HeroAtk = 5,
	HeroDef = 6,
	Health = 7,
	CampValue = 8,
	EdenSignal = 9,
}
BattleSubTitleShowType = 
{
	HeroAttack = 1,
	HeroDefence = 2,
	AttackAdd = 3,
	DefenceAdd = 4,
	HealthAdd = 5,
	MarchLimitAdd = 6,
	SkillHurtAdd = 7,
	NormalHurtAdd = 8,
	BackHurtAdd = 9,
	SkillHurtDec = 10,
	NormalHurtDec = 11,
	BackHurtDec = 12,
	Curve = 13,
}

ScoutMailTargetType = 
{
	DEFAULT = "DEFAULT",
	MAIN_BUILDING = "MAIN_BUILDING",
	STORAGE = "STORAGE",
	COLLECT_BUILDING = "COLLECT_BUILDING",
	TOWER = "TOWER",
	BUILDING = "BUILDING",
	MARCH = "MARCH",
	ALLIANCE_CITY = "ALLIANCE_CITY",
	DESERT = "DESERT",
	ALLIANCE_BUILD = "ALLIANCE_BULID",
	CROSS_WORM_HOLE = "CROSS_WORM_HOLE",
	DRAGON_BUILDING = "DRAGON_BUILDING",
}

--为了快速在数据库中查找和删除特定邮件（提高效率），把isReport改成枚举类型
MailIsReportType = 
{
	None = 0,--不需要特殊处理，正常的邮件
	Report = 1,--其他组中，需要显示在打野组的邮件（几千封战报中的邮件，只需找出几封）
	BlackKnight = 2,--黑骑士用（黑骑士属于战报，要显示在打野，按组删除效率爆炸，所以有了这个枚举）
	ExpeditionaryDuel = 3,--远征对决用（远征对决属于战报，要显示在打野，按组删除效率爆炸，所以有了这个枚举）
}

