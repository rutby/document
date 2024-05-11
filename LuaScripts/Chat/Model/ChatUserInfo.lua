--[[
    这个类是聊天用户信息
    自定义头像大小 90 * 90

    这个数据结构需要请求服务器然后服务器再去捞数据可能有点慢
    所以需要把该数据类型的数据都存在数据里
]]

local ChatUserInfo = BaseClass("ChatUserInfo")
local rapidjson = require "rapidjson"

--构造函数
function ChatUserInfo:__init()
	self._id  = 0
	self.userName = "" -- 名字
	self.allianceSimpleName = "" -- 联盟简称，显示在()里面的
	self.allianceRank = 0       -- 联盟排名 决定禁言权限，只有本玩家有
	self.headPic      = ""      --头像文件名字
	self.headPicVer   = 0       --头像版本
	self.monthCard     = 0      --月卡
	self.chooseState =  0   --
	self.uid = ""           --uid
	self.lang = ""          --语言
    self.serverId = 0       --服务器id
    self.crossFightSrcServerId = 0  --跨服战时的原服id，若为-1表示没有跨服
    self.allianceId = ""    --联盟id
    self.allianceName = ""  --联盟名字
    self.vipLevel = 0       --vip等级，至少为1，由vip points决定，只升不降
    self.vipframe = 0
    self.svipLevel = 0
    self.chatFrameId = ""   --头像框

    self.vipEndTime = 0     --vip时间，单位为s，有时区，过期则vip暂时失效（等级保留）
    self.chatSkinId = 0     --聊天皮肤id
    self.careerId  = ""     --职业id
	self.monthCardEndTime = -1		--月卡到期时间
	self.mainBuildingLevel = 0 --大本等级
	self.nation = "UN"--国家

    self.power = 0          --战力
    --[[
     当为mod时名字颜色为(65,119,41)，如果为gm时名字颜色为(33,111,169),否则名字颜色为(111,26,0)
     GM=1    设置出切换服务器功能
     GM=2    普通MOD，聊天频道可以看到MOD标记，MOD可使用禁言功能
     GM=3    GM标记，聊天频道可以看到GM标记
     GM=4    超级MOD，聊天频道可以看到SMOD标记，可禁言，可任命MOD
     GM=5    实习MOD，聊天频道可以看到TMOD标记，可禁言
     GM=10    内部人标记，可禁言（可以的话，超哥那不能把GM=10的禁言功能去掉，不应该给他们这个功能的）
     GM=11    名人认证标记，世界地图、领主详情处有蓝V标记。
    ]]
    self.gmFlag = 0
   
    self.chatBantime = 0          -- 禁言时间

     --挖地目前改名字，换头像，换联盟会改变
    self.lastUpdateTime = 0     --上次更新时间
 
    self.customHeadImageName      = "" -- 自定义头像名字
    self.headimageurl         = "" -- 自定义头像获取地址 
    self.customHeadImageFullPath       = "" -- 自定义头像名字的完整路径
	
	-- 玩家职业
	self.careerType = CareerType.None
	self.careerLv = 0

	self.info_ok = false		-- 表示信息是否已经从服务器返回ok了
	self.headSkinId = nil
	self.headSkinET = nil
	self.sex = SexType.None--性别
	self.positionId = 0--官职
	self.titleSkinId = 0--称号
	self.titleSkinET = 0--称号到期时间
end

local function maskMsg ( text, set, repl )
    if #text <= 0  then
        return text
    end
    local function maskor ( str )
        return repl or string.rep( "*", #str )
    end
    for k, str in pairs(set) do
        text = string.gsub( text, str, maskor(str) )
    end
    return text
end

function ChatUserInfo:setUid(uid)
    self.uid = uid
end

function ChatUserInfo:getServerId()
    return self.crossFightSrcServerId < 0 and self.serverId or self.crossFightSrcServerId
end

function ChatUserInfo:IsGmUser()
	local userId = tonumber(self.uid)
	for i = 0, ChatGMUserCnt do	
		local tmpUserId = tonumber(ChatGMUserId)+i
		if (userId == tmpUserId) then
			return true
		end
	end
	return false;
end

function ChatUserInfo:GetGMIcon()
	return ChatGMUserIcon
end

---设置数据
function ChatUserInfo:onParseServerData(tabData)
    if type(tabData) ~= "table" then 
        return
    end 
	
	-----------------------------------------------------
	-- 人物相关的一些基础信息
    if tabData.uid then 
        self.uid = tabData.uid
	end
	self.userName = tabData.name or ""
	self.careerId = tabData.careerId or ""
	self.monthCardEndTime = checknumber(tabData.monthCardEndTime)
	self.mainBuildingLevel = checknumber(tabData.mainBuildingLevel)
	self.nation = tabData.countryflag or ""
	self.serverId = checknumber(tabData.serverId)
	-- 跨服id，有些地方发的是server
	if tabData.crossFightSrcServerId then
		self.crossFightSrcServerId = checknumber(tabData.crossFightSrcServerId)
	end
	self.crossFightSrcServerId = checknumber(tabData.server)
	-- 这个理论上不应该处理；否则截取消息包就暴露拖的身份了！
	if tabData.gmFlag then
		self.gmFlag = checknumber(tabData.gmFlag)
	end
	
	-- 用户系统改头像及自定义头像
	self.headPic = tabData.pic or ""
	if tabData.picVer then
		self.headPicVer = checknumber(tabData.picVer)
	end

	-- 人物信息修改的最后时间；单位秒；就是unix时间戳
    if tabData.lastUpdateTime then 
        self.lastUpdateTime = checknumber(tabData.lastUpdateTime)
    end 

	-- 有些消息会把战力返回来
	self.power = checknumber(tabData.power)
	-- 返回语言字符串；譬如zh_CN
	self.lang = tabData.lang or ""

	-----------------------------------------------------
	-- 联盟相关信息
	if tabData.allianceId then
		self.allianceId = tabData.allianceId
	else
		self.allianceId = ''
		self.allianceSimpleName = ''
		self.allianceName = ''
	end
	
	if tabData.abbr then
		self.allianceSimpleName =  tabData.abbr
	end
	-- 有些消息返回的是allianceAbbrName，服务器没统一
	if tabData.allianceAbbrName then
		self.allianceSimpleName = tabData.allianceAbbrName
	end
	self.allianceName = tabData.allianceName or ""
	self.allianceRank = checknumber(tabData.rank)
	-----------------------------------------------------
	-- 聊天禁聊时间
	local chatBantime = checknumber(tabData.chatBantm)
	if chatBantime then
		--董军杰说 9223372036854775807是禁言时间的最大值，都属于永久禁言
		if chatBantime == 9223372036854775807 or chatBantime == -1 then
			chatBantime = -1
		else
			chatBantime = math.floor(chatBantime/1000)
		end
		self.chatBantime = chatBantime
		ChatManager2:GetInstance().Restrict:chatBanOrUnBan(tabData.uid,tabData.banGMName,self.chatBantime,1)
		ChatManager2:GetInstance().User:updateBanTime(tabData.uid,self.chatBantime)
	end
	
	-----------------------------------------------------
	-- 下面这几个都是聊天皮肤相关的
	self.chatSkinId = checknumber(tabData.chatSkinId)
	self.chatFrameId = tabData.chatFrameId or ""
	self.monthCard = checknumber(tabData.bubble)
	-----------------------------------------------------
	-- VIP等级等尊贵信息！！
	self.vipLevel = checknumber(tabData.vipLevel)
	self.vipframe = checknumber(tabData.vipframe)
	self.vipEndTime = checknumber(tabData.vipEndTime)
	self.svipLevel = checknumber(tabData.svipLevel)
	
	-- 玩家职业
	self.careerType = checknumber(tabData.careerType)
	self.careerLv = checknumber(tabData.careerLv)
	self.headSkinId = checknumber(tabData.headSkinId)
	self.headSkinET = checknumber(tabData.headSkinET)

	if tabData.sex and SexUtil.IsUnLockSex() then
		self.sex = tabData.sex
	end
	self.positionId = checknumber(tabData.positionId)
	self.titleSkinId = checknumber(tabData.titleSkinId)
	self.titleSkinET = checknumber(tabData.titleSkinET)
	
	self.info_ok = true
end 

function ChatUserInfo:GetHeadBgImg()
	--local headBgImg = nil

	local serverTimeS = UITimeManager:GetInstance():GetServerSeconds()
	--if self.monthCardEndTime and self.monthCardEndTime > serverTimeS then
	--	headBgImg = "Common_playerbg_golloes"
	--end
	local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.headSkinId, self.headSkinET, self.monthCardEndTime and self.monthCardEndTime > serverTimeS)
	return headBgImg
	--if headBgImg and headBgImg ~= "" then
	--	return string.format(LoadPath.CommonNewPath,headBgImg)
	--end
end

function ChatUserInfo:CheckIfShowStorageBtn()
	if self.uid == LuaEntry.Player.uid then
		return false
	end
	local minLv = LuaEntry.DataConfig:TryGetNum("tradingbank_para", "k17")
	return self.mainBuildingLevel >= minLv
end

function ChatUserInfo:setChatBantime(banTime)
    self.chatBantime = banTime
end

-- 设置为最终解析过的数据
function ChatUserInfo:SetInfoOK()
	self.info_ok = true
end

-- 获取用户名称
-- 如果数据已经准备好，直接返回真实的信息
-- 如果没有准备好，先返回一个字符串标识
function ChatUserInfo:GetUserName()
	if self.info_ok then
		return self.userName
	end
	
	if self.userName ~= "" then
		return self.userName
	end

	local msgOwner = self.uid
	if self.uid == "system" then
		msgOwner = CS.GameEntry.Localization:GetString("310002")
	end
	return msgOwner
end


-- 设置用户的最后更新时间
function ChatUserInfo:SetLastUpdateTime(time, name)
	if tonumber(time) > tonumber(self.lastUpdateTime) then
		ChatPrint("time update!!")
		self.info_ok = false
	end
	
	if type(name) == "string" and name ~= "" then
		self.userName = name
	end
end


return ChatUserInfo

