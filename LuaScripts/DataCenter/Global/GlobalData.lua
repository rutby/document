--[[
	游戏全局数据，这里面的数据是和用户不相关的
	譬如系统数据，全局配置数据等
	注意不要把和账号相关的全局数据放到这里，那个数据放到PlayerInfo中！
]]

local GlobalData = BaseClass("GlobalData")
local util = require "Common.Tools.cjson.util"
function GlobalData:__init()
	self:ctor()
end

function GlobalData:ctor()
	self.lastChatInput = ""
	
	self.db_timezone_offset = 0;
	self.db_utc_timestamp = 0;
	
	self.download_video_url = "";
	self.download_video_url2 = "";
	self.downloadurlcdn = "";
	self.downloadurl = "";
	
	self.eu_state = 0;
	
	self.force_merge = 0;
	self.force_use_downloadxml = 0;
	self.isCN = false;
	self.isArab = false;
	self.lua = "";
	self.luaCode = "";
	self.luaCode_v3 = "";
	self.luaSize = 0;
	self.luaVersion = "";
	self.luaVersion_v3 = "";
	self.luazipSize = 0;
	self.randKey = 0;
	self.reduce_init_data = 0;
	self.serverVersion = ""; --最新客户端版本号
		
	self.updateType = 0; --0: 不更新；1:建议更新apk；2：强制更新apk; 3:更新xml 15s内下载不完也直接进游戏  4强更xml,必须下载完才能进入游戏。
	self.upload_video_url = "";
	self.xmlVersion = ""; --最新xml版本号


	self.gcmRegisterId = "";--GCM注册ID
	self.referrer = "";--广告来源数据
	self.deeplinkParams = "";--deep link params
	self.AndroidID = "";--android_id
	
	self.analyticID = ""; -- 渠道标志：mycard 发布平台 91 google 360.
	self.s_isGooglePlayAvailable = false;  -- 谷歌服务是否可用 是否支持谷歌支付
	self.platformUID = "";--平台UID
	self.parseRegisterId = "";--Parse注册ID
	self.fromCountry = "US";--国家
	self.gaid = "";--adjust 发奖依据

	self.isLoginFlag = 0;       --登陆login：true
	self.isInitFlag = 0;        --是否解析PUSHINIT完成
	self.isPause = 0;
	self.isAuthenticate = false
	
	self.isTodayFirstLogin = false; --是否今日第一次登陆
	self.isClickMonthCardPop = 0;--月卡相关
	self.isBind = 0;--绑定状态
	self.isPayBind = 0;--绑定状态

	self.isXMLInitFromServerFlag = false;--是否初始化过下载的xml文件
	self.isFirstLoginGame = false; -- 是否是新用户登录！
	self.translation = false;--是否开启自动翻译
	self.mail_translation = false;--是否开启邮件的自动翻译
	self.showFaceBookUi = false;--是否显示facebook入口
	self.isBindAcount = false; --是否绑定了账号
	self.fbIsUpLoadImg = false;--facebook 是否上传过图片

	self.version = "";--前台版本号
	self.usingXmlVersion = "";--正在使用的xml版本号
	self.lang = "";--语言
	self.uuid = "";-- uuid
	self.platform = "";--系统平台 ios ad
	
	self.GPPlayerID = "";--google的games的玩家登陆ID
	self.GPPlayerName = "";--google的games的玩家登陆name
	self.platformChannel = "";--warz渠道登陆平台
	self.gaidCache = "";--android读取到gaid以后缓存起来
	self.deeplinkPostUid = "";--deep link post uid
	self.pauseTime = 0;--暂停时间

		
	self.freshRechargeTotal = 0;--新手累积充值
	self.bFreshRechargeOpen = false;--新手累积充值开关
	self.activityPop = 0;  -- 弹出活动标记
	self.isInDataParsing = false;
	self.isUploadPic = false;--是否在上传照片
	self.isOpenTaiwanFlag = 0;--大陆看台湾国旗开关1开0关

	self.isOpenElvaChat = false;--是否在智能客服聊天中
	self.isFAQVoteResp = false;--是否在回答问卷调查
	self.cityTileCountry = 0;   -- 当前城市地块的类型。

	self.accFlag = false
	self.serverType = 0;--是否是跨服
	self.serverMax = 999;
	self.accFlagNow = false
	self.statNewGame = false
	self.chinaSwitchFlag = 0;--大陆显示国旗开关 0不变 1为将五星红旗显示为纯红色旗子 2为不显示国旗

	

		--public int commonRecover;//普通修复扳手用过的次数
		--public int goodRecover;//优良修复扳手用过的次数
		--public int superRecover;//超级修复扳手用过的次数

		--public List<GotoUtilsInfo> gotoUtilsInfos = new List<GotoUtilsInfo>();//云打开之后调用
		--public List<GotoUtilsInfo> gotoUtilsInfosBefore = new List<GotoUtilsInfo>();//云打开之前调用

		--public int[] fire = new int[3];
		--public int[] fire1 = new int[4];

	self.nowGameCnt = 0; --当前设备创建的新账号的数量
	self.freeSpdT = 0
	self.fileDataTableVersion = ""
end

-- 初始化网络消息
function GlobalData:InitFromNet(dict)
	
	self.db_utc_timestamp = dict["db_utc_timestamp"] or 0
	self.db_timezone_offset = dict["db_timezone_offset"] or 0
	
	-- 明天的时间，单位秒
	self.tomorrow = dict["tomorrow"]
	
	self.gaid = dict["gaid"] or ""
	if dict["identification"] ~= nil then
		local temp = dict["identification"]
		self.isCN = temp["isCN"]
		self.isArab = temp["isArab"]
		self.isAuthenticate = temp["authenticate"]
	end
	self.isCN = CS.GameEntry.GlobalData:isChina()

	local path = util.GetPersistentDataPath()
	local curServerVersion = CS.GameEntry.Sdk.Version
	
	local name = path.."/ZipDocument/getnewlua/VERSION.txt"
	local str = util.file_load(name)
	if str~=nil and str~="" then
		self.fileDataTableVersion = str
	end
end

function GlobalData:IsChina()
	return self.isCN
end

function GlobalData:GetIsAuthenticate()
	return self.isAuthenticate
end

function GlobalData:GetFileVersion()
	return self.fileDataTableVersion
end

return GlobalData
