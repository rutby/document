--[[
	发送聊天的类型
	根据不同的聊天类型来显示不同显示形式
]]

PostType = {
	Text_Normal 			= 0,   		-- 普通聊天消息
	Text_AllianceCreated 	= 1, 	-- 联盟创建消息 
	Text_AllianceAdded		   = 2, 	-- 加入联盟系统邮件
	Text_AllianceInvite    	= 3,  -- 联盟邀请的系统邮件
	Text_FightReport 		= 4,  --战报分享 
	Text_InvestigateReport  = 5,  --侦查战报分享
	Text_Loudspeaker 		= 6,  -- 喇叭消息
	Text_EquipShare 		= 7,  -- 装备分享
	Text_SayHello 			= 8,  -- 打招呼
	Text_AllianceRally   = 9,  -- 联盟集结
	Text_TurntableShare     = 10, -- 轮盘分享
	Text_AllianceTask 		= 11, --联盟任务
	RedPackge      			= 12, -- 红包
	Text_PointShare			= 13, -- 坐标分享
	Text_AllianceTaskHelper = 14, -- 联盟宝藏求助
	Text_Media 				= 15, -- 语音消息 这个C++层也没定义 不知道有没有用了
	Text_Alliance_MonthCardBox = 18, -- 月卡随机宝箱分享
	Text_SevenDayShare  	= 19, -- 七日分享
	Text_MissileShare       = 20, --导弹分享
	Text_AllianceGroupBuyShare = 21, -- 联盟团购分享
	Text_Create_EquipShare  = 22, --打造装备分享
	Text_Create_New_EquipShare = 23,--新打造装备分享
	Text_Use_Item_Share  		= 24, --使用道具分享
	Text_Gift_Mail_Share 		= 25, -- 赠送礼品邮件分享
	Text_Favour_Point_Share     = 26, -- 收藏坐标点
	Text_GoTo_Wounded_Share 	= 27, -- 治疗伤病分享
	Text_GoTo_Medal_Share		= 28, -- 装备勋章分享
	Text_Shamo_Inhesion_Share   = 29, -- 沙漠天赋分享
	Text_Formation_Fight_Share  = 30, -- 新的地块战斗战报分享
	Text_FBScoutReport_Share    = 31, -- 新的侦查邮件分享
	Text_FBActivityhero_Share   = 32, -- 自由城建积分兑换英雄的分享
	Text_FBFormation_Share		= 33, -- 自由城建编队分享


	Text_ScienceMaxShare 		= 34, -- 科技MAX分享
	Text_AllianceCommonShare 	= 35, -- 新联盟转盘分享
	Text_SevenDayNewShare 		= 36, -- 新末日投资分享
	Text_AllianceAttackMonsterShare = 37, --  联盟集结BOSS
	Text_AllianceArmsRaceShare  = 38, -- 联盟军备竞赛活动分享
	Text_EnemyPutDownPointShare = 39, -- 敌方在本方放下集结点分享
	Text_FBAlliance_missile_share = 41,--分享联盟导弹攻击信息

	Text_Dommsday_Missile_Share = 42,  --末日导弹
	Text_Audio_Message 			= 43,  -- 语音消息
	Text_Visit_Base_Message 	= 44,  --参观基地建设
	Text_Send_Flower 			= 45,  --送花界面

	Text_ChatRoomSystemMsg 		= 100, -- 聊天室系统消息
	Text_ChatWarnningSysMsg 	= 110, --世界频道i政治敏感信息警告系统消息
	Text_AD_Msg 				= 150, --个人信息邮件广告友情提示
	Text_AreaMsg  				= 180, --竞技场伪造的消息
	Text_ModMsg 				= 200, --mod邮件
	Text_Alliance_ALL_Msg       = 250,

	Text_StartWar 				= 260, -- 世界战争开打，联盟消息 集结
	Text_EndWar 				= 261, -- 世界战争结束，世界频道 点赞

	Text_AllianceRedPack 		= 265, -- 联盟红包
	Text_AllianceWelcome 		= 266, -- 联盟欢迎新人
	Text_AllianceMemberInOut 	= 267, -- 进退盟 1 加入 2 离开 3 被请离
	Text_AllianceTransfer 		= 268, -- 盟主转让

	Text_AllianceRankChange 	= 269, -- 权限调整 R1 R2
	Text_AllianceOfficialChange = 270, -- 官职调整
	Text_AllianceOfficialSet 	= 271, -- 官职任命
	Text_AllianceOfficialCancel = 272, -- 官职罢免

	Text_AllianceGather 		= 273, -- 联盟集结消息

	Text_AllianceMark 			= 274, -- 联盟标记消息

	Text_NewServerActivity      = 275, --开服活动

	Text_ShareHeroTenGet      	= 276, --英雄十连抽分享

	Text_NewServerActivity_New  = 277, --新开服活动分享

	Text_AllianceProduceMine = 301, --联盟领地刷矿

	NotCanParse 				= 300,

	Text_MemberJoin = 320,--新玩家加入联盟
	Text_MemberQuit = 321,--玩家离开联盟
	Text_Formation_Share = 322,--玩家编队分享

	Text_MailScoutResultShare = 323,--侦查结果分享
	Text_MsgShare = 324,--信息分享
	Text_ChampionBattleReportShare = 325,--冠军对决战报分享
	Text_AllianceTaskShare = 326,--联盟任务进度分享
	Text_AllianceRecruitShare = 327,--联盟招募
	Text_BattleReportContentShare = 328,--战报分享（战报完整信息）
	Text_ActMonsterTowerHelp = 329,--怪物爬塔联盟帮助分享
	Text_ScoutReportContentShare = 330,--侦查分享（战报完整信息）
	Text_ScoutAlertContentShare = 331,--被侦查分享（战报完整信息）
	Text_MsgGm = 332,
	Text_Missile_Attack = 333,--导弹攻击
}
return ConstClass("PostType", PostType)
