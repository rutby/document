--[[
	邮件数据库管理器
	把C#中的SQLite挪到LUA端，这样代码相对整洁
]]

local MailDBManager = BaseClass("MailDBManager")
local util = require "Common.Tools.cjson.util"
function MailPrint(fmt, ...)
	--local arg= {...}
	--if #arg == 0 then
		--print("[mail]" .. tostring(fmt))
		--return
	--end

	--print("[mail]" .. string.format(fmt, ...))
	return
end


function MailDBManager:__init()

	self.isInit = false
	self.sql_count = 0
end
--isReport 改成枚举 MailIsReportType
-- 邮件表结构
local tblMailData =
{
	-- name						type		notnull	dflt_value	pk
	{"uid", 					"varchar", 	1,		"",			1 },
	{"toUser", 					"varchar", 	0,		"",			0 },
	{"fromUser", 				"varchar", 	0,		"",			0 },
	{"fromName", 				"varchar", 	0,		"",			0 },
	{"title", 					"varchar", 	0,		"",			0 },
	{"subTitle", 				"varchar", 	0,		"",			0 },
	
	{"contents", 				"blob", 	0,		"",			0 },
	{"rewardId", 				"blob", 	0,		"",			0 },
	
	{"itemIdFlag", 				"integer",	0,		"",			0 },
	{"status",					"integer",	0,		"",			0 },
	{"type",					"integer",	0,		"",			0 },
	{"rewardStatus", 			"integer",	0,		"",			0 },
	{"saveFlag", 				"integer",	0,		"",			0 },
	{"createTime",				"bigint",	0,		"",			0 },

	{"reply",					"integer",	0,		"",			0 },
	{"replyText", 				"varchar",	0,		"",			0 },
	{"translationId",			"varchar",	0,		"",			0 },
	{"mbLevel", 				"integer",	0,		"",			0 },
	{"rewardTime", 				"bigint",	0,		"",			0 },

	{"extParam1", 				"string",	0,		"",			0 },
	{"extParam2", 				"blob",		0,		"",			0 },
	{"translateMsg", 				"string",	0,		"",			0 },
	{"translatedLang", 				"string",	0,		"",			0 },
	{"expireTime", 				"bigint",	0,		"",			0 },
	{"isReport", 			"integer",	0,		"",			0 }
}

-- 插入MailData模板
local Insert_MailData_SQL = [[INSERT OR REPLACE INTO MailData (
"uid",
"toUser",
"fromUser",
"fromName",
"title",
"subTitle",
"contents",
"rewardId",
"itemIdFlag",
"status",
"type",
"rewardStatus",
"saveFlag",
"createTime",
"reply",
"replyText",
"translationId",
"mbLevel",
"rewardTime",
"extParam1",
"extParam2",
"translateMsg",
"translatedLang",
"expireTime",
"isReport"
) VALUES ]]

-- 更新MailData模板
local Update_MailData_SQL = [[UPDATE MailData
SET type='%d'
WHERE uid='%s']]


-- 单条邮件sql insert value 字符串
local function GetSingleMailDataValue(mail)

	local v = "("
	.. "'" .. mail.uid .. "', "
	.. "'" .. mail.toUser .. "', "
	.. "'" .. (mail.fromUser or "") 	.. "'" .. ", "
	.. "'" .. LuaDBInterface.escape(mail.fromName or "") 	.. "'" .. ", "
	.. "'" .. LuaDBInterface.escape(mail.title or "") 		.. "'" .. ", "
	.. "'" .. (mail.subTitle or "") 	.. "'" .. ", "
	.. "'" .. LuaDBInterface.escape(mail.contents or "") 	.. "'" .. ", "
	.. "'" .. (mail.rewardId or "") 	.. "'" .. ", "
	.. "'" .. (mail.itemIdFlag or 0) 	.. "'" .. ", "
	.. "'" .. (mail.status or 0) 		.. "'" .. ", "
	.. "'" .. (mail.type or 0) 			.. "'" .. ", "
	.. "'" .. (mail.rewardStatus or 0) 	.. "'" .. ", "
	.. "'" .. (mail.saveFlag or 0) 		.. "'" .. ", "
	.. "'" .. (mail.createTime or 0) 	.. "'" .. ", "
	.. "'" .. (mail.reply or 0) 		.. "'" .. ", "
	.. "'" .. (mail.replyText or "") 	.. "'" .. ", "
	.. "'" .. (mail.translationId or "") .. "'" .. ", "
	.. "'" .. (mail.mbLevel or 0) 		.. "'" .. ", "
	.. "'" .. (mail.rewardTime or 0) 	.. "'" .. ", "
	.. "'" .. (mail.extParam1 or "") 	.. "'" .. ", "
	.. "'" .. (mail.extParam2 or "") 	.. "'" .. ", "
	.. "'" .. (mail.translateMsg or "") .. "'" .. ", "
	.. "'" .. (mail.translatedLang or "") .. "'" .. ", "
	.. "'" .. (mail.expireTime or 0) .. "'" .. ", "
	.. "'" .. (mail.isReport or 0) .. "'"
	.. ")"

	return v
end

-- 制作批量插入邮件数据到数据库的SQL
-- 暂时应该不需要优化：https://www.jianshu.com/p/faa5e852b76b?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
-- single表示到底是1条还是多条，不要去用代码判断了，手动传入
local function MakeInsertMailDatas(mailDatas, single)

	if single then
		local sql = Insert_MailData_SQL .. GetSingleMailDataValue(mailDatas)
		return sql
	end

	local sqls = {}
	for k,v in pairs(mailDatas) do
		table.insert(sqls, Insert_MailData_SQL .. GetSingleMailDataValue(v))
	end

	return sqls
end

-- 创建表
local function CreateMailTable(sqlTable)
	LuaDBInterface.CreateOneTable(sqlTable, "MailData", tblMailData)
	table.insert(sqlTable, "CREATE INDEX index_maildata_uid on MailData (toUser)")
end

-- 处理ChatUserInfo的数据
-- 理论上可以从ParseResultToLuaTable解析成通用数据再赋值，但是会产生额外开销
local function ParseResultToMailDatas(result)
	local tbl = {}

	-- 数据不存在或者查询出错了
	if result == nil or result.error ~= 0 or result.cols == nil then
		MailPrint("userinfo error!!")
		return tbl
	end

	if result.values == nil or #result.values <= 0 then
		MailPrint("mail result.values error")
		return tbl
	end

	-- cols列名, values是数值（注意是一个Array，所以我们只取第一行即可）
	local col_count = result.col_count
	local cols = result.cols

	if col_count <= 0 then
		MailPrint("col_count error")
		return tbl
	end

	local MailMgr = DataCenter.MailDataManager
	for rowidx=1,#result.values do
		local row = MailMgr:CreateMailData()
		for i=1,col_count do
			local k = cols[i].name
			local v = result.values[rowidx][i]
			row[k] = v
		end

		-- 从数据库读出来的UserInfo就算info_ok = true
		--row:SetInfoOK()
		table.insert(tbl, row)
	end

	return tbl
end


-- 处理一下邮件数据
local function processCacheFirstMail(result1)
	-- 分类的邮件数据
	if result1.error ~= 0 and table.IsNullOrEmpty(result1.values) then
		MailPrint("no datas 1")
	else
		local mailDatas = ParseResultToMailDatas(result1)
		if not table.IsNullOrEmpty(mailDatas) then
			DataCenter.MailDataManager:OnGetDBMails(mailDatas)
		else
			-- 没有邮件这里就直接返回了，后面的肯定也都是0；没必要去处理了
			return
		end
	end
end

-- 处理一下邮件数据
local function processCacheMailDatas (result1, result2)
	-- 分类的邮件数据
	if result1.error ~= 0 and table.IsNullOrEmpty(result1.values) then
		MailPrint("no datas 1")
	else
		local mailDatas = ParseResultToMailDatas(result1)
		if not table.IsNullOrEmpty(mailDatas) then
			DataCenter.MailDataManager:OnGetDBMails(mailDatas)
		else
			-- 没有邮件这里就直接返回了，后面的肯定也都是0；没必要去处理了
			return
		end
	end
	
	-- 数量及未读的数量
	if result2.error ~= 0 and table.IsNullOrEmpty(result2.values) then
		MailPrint("no datas 2")
	else
		local t2 = LuaDBInterface.ParseResultToMultiLuaTables(result2)
		if not table.IsNullOrEmpty(t2) then
			DataCenter.MailDataManager:OnDBGroupUnreadCount(t2)
		else
			MailPrint("get count error")
		end
	end
	EventManager:GetInstance():Broadcast(EventId.MailPush)
end


-- 有表修改，无表创建
-- FIXME: 这里的逻辑不是很严谨
local function onCreateOrAlterTable(self, result)

	-- 最终需要处理的sql语句集合
	-- 其中result[1]表示UserInfoData;result[2]表示ChatData
	local sqls = {}

	if result == nil then
		CreateMailTable(sqls)
	else
		if #result > 0 then
			if (result[1].col_count == 0 or #result[1].values == 0) then
				CreateMailTable(sqls)
			else
				LuaDBInterface.MigrateOneTable(sqls, "MailData", result[1], tblMailData)
			end
		end
	end

	-- 处理一下邮件信息
	if #result >= 2 then
		processCacheFirstMail(result[2])
	end

	-- 没啥需要处理的
	if #sqls == 0 then
		self:__Callback("ok", "table")
		return
	end

	-- 创建表或者修改表
	LuaDBInterface.ExecuteMultiSQL(sqls,

		function (r2)
			if r2 == nil then
				ChatPrint("create error??")
				self:__Callback("error", "internal")
				return
			end

			local allisok = true
			table.walk(r2, function(k,v)
					if v.error ~= 0 then
						ChatPrint("error on sql: " .. sqls[k])
						allisok = false
					end
				end)

			self.isInit = true
			self:__Callback(allisok and "ok" or "error", "create")

		end)

end


local function onInitMailGet(self,result)
	if result ~= nil then
		if #result >= 2 then
			processCacheMailDatas(result[2],result[3])
		end
	end
end

-- 获取每种group分组的sql条件：MailChannelType
-- 譬如：个人邮件，包含哪几种type
-- 大类型主要分成：系统，联盟，战报，个人
-- 这个类型是逻辑意义上的类型，和MailChannelType还不是很相同
function MailDBManager:__getGroupCondSQL(groupId, exclude)

	local tbl = {}
	for k, v in pairs(MailTypeToInternalGroup) do
		if v == groupId and exclude ~= k then
			table.insert(tbl, k)
		end
	end
	if groupId == MailInternalGroup.MAIL_IN_report then
		table.insert(tbl,MailType.NEW_FIGHT)
		table.insert(tbl,MailType.SHORT_KEEP_FIGHT_MAIL)
		table.insert(tbl,MailType.MAIL_SCOUT_RESULT)
		table.insert(tbl,MailType.MARCH_DESTROY_MAIL)
	elseif groupId == MailInternalGroup.MAIL_IN_blackKnight then
		table.insert(tbl,MailType.NEW_FIGHT)
	elseif groupId == MailInternalGroup.MAIL_IN_expeditionaryDuel then
		table.insert(tbl,MailType.NEW_FIGHT)
	end

	return "type in (" .. table.concat(tbl, ",") .. ")"
end


function MailDBManager:__Callback(status, reason)
	if (self.callback) then
		self.callback(status, reason)
	else
		ChatPrint("db : " .. status .. "," .. reason)
	end
end


-- 初始化取createTime前20条数据
local SQLGroupPageFormat = [[
SELECT %d as groupId, * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND %s ORDER BY createTime DESC LIMIT %d, %d)
]]

local SQLGroupPageFormatForReport = [[
SELECT %d as groupId, * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND (`isReport` is NULL OR `isReport` == 1  OR `isReport` == 2 OR `isReport` == 3) AND %s ORDER BY createTime DESC LIMIT %d, %d)
]]

--黑骑士钻用拉取邮件
local SQLGroupPageFormatForBlackKnight = [[
SELECT %d as groupId, * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND (`isReport` == 2) AND %s ORDER BY createTime DESC LIMIT %d, %d)
]]

--远征钻用拉取邮件
local SQLGroupPageFormatForExpeditionaryDuel = [[
SELECT %d as groupId, * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND (`isReport` == 3) AND %s ORDER BY createTime DESC LIMIT %d, %d)
]]

-- 初始化取收藏夹数据，这个比较特殊
local SQLFavorPageFormat = [[
SELECT %d as groupId, * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1 ORDER BY createTime DESC LIMIT %d, %d)
]]

-- 邮件的未读数量和总数
-- SaveFlag = 0 表示没有收藏，收藏的专门有一个分类
-- 返回一个table = { groupId = ?, total = ?, unread = ? }
local SQLGroupUnreadAndCountFormat = [[
SELECT %d as `groupId`, x as `total`, y as `unread` FROM 
(SELECT count(*) as x FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND %s),
(SELECT count(*) as y FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND status = 0 AND %s)
]]

local SQLGroupUnreadAndCountFormatForReport = [[
SELECT %d as `groupId`, x as `total`, y as `unread` FROM 
(SELECT count(*) as x FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND (`isReport` = 1) AND %s),
(SELECT count(*) as y FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND status = 0 AND (`isReport` = 1) AND %s)
]]

local SQLGroupUnreadAndCountFormatForBattle = [[
SELECT %d as `groupId`, x as `total`, y as `unread` FROM 
(SELECT count(*) as x FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND `isReport` == 0 AND %s),
(SELECT count(*) as y FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND status = 0 AND `isReport` == 0 AND %s)
]]

local SQLGroupPageFormatForBattle = [[
SELECT %d as 'groupId', * FROM 
(SELECT * FROM MailData WHERE `toUser` = '%s' AND saveFlag = 0 AND(`isReport` is NULL OR `isReport` == 0) AND %s ORDER BY createTime DESC LIMIT %d, %d)
]]

-- 收藏邮件的未读数量和总数
-- 收藏邮件肯定是全部已读的
local SQLFavorUnreadAndCountFormat = [[
SELECT %d as groupId, x as `total`, y as `unread` FROM 
(SELECT count(*) as x FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1),
(SELECT count(*) as y FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1 AND status = 0)
]]

-- 获取分组所有的uid
local SQLGroupAllUidFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND %s ORDER BY createTime DESC LIMIT 0, 300)
]]

local SQLGroupAllUidForBattleFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND `isReport` == 0 AND %s ORDER BY createTime DESC LIMIT 0, 300)
]]

local SQLGroupAllUidIsReportFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND (`isReport` = 1 OR `isReport` = 2 OR `isReport` = 3) AND %s ORDER BY createTime DESC LIMIT 0, 300)
]]

local SQLGroupAllUidBlackKnightFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND `isReport` = 2 AND %s ORDER BY createTime DESC LIMIT 0, 300)
]]

local SQLGroupAllUidExpeditionaryDuelFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND `isReport` = 3 AND %s ORDER BY createTime DESC LIMIT 0, 300)
]]

-- 获取收藏分组所有的uid
local SQLFavorAllUidFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 1 LIMIT 0, 300)
]]

-- 获取分组未领奖的uid
local SQLGroupNotRewardFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND %s AND `rewardStatus` = 0 ORDER BY createTime DESC LIMIT 0, 300)
]]

local SQLGroupNotReadFormat = [[
SELECT %d as groupId, uid FROM
(SELECT * FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND %s AND `status` = 0 ORDER BY createTime DESC LIMIT 0, 300)
]]


-- 数据库加载完毕，获取最新的一封邮件
function MailDBManager:__MailDBInitRequest()
	local playerUid = ChatInterface.getPlayerUid()
	local sqlStr = string.format("SELECT * FROM MailData WHERE `toUser` = '%s' ORDER BY createTime DESC LIMIT %d, %d",playerUid,0,1)
	local tbl = {
		"pragma table_info ('MailData')",
		sqlStr
	}
	
	LuaDBInterface.ExecuteMultiSQL(tbl,
		function(r)
			onCreateOrAlterTable(self, r)
		end)
end

-- 数据库加载完毕，之后初始化各种表数据
function MailDBManager:__MailDBInit()
	local playerUid = ChatInterface.getPlayerUid()

	-- 邮件启动的时候，获取几个东西
	-- 1。每个分组的前20条邮件
	-- 2。未读的邮件数量和总数（显示红点可能需要）
	local t20 = {}
	local tCount = {}

	-- 循环处理一下
	-- 第一波先取前20条
	for i=1,MailInternalGroup.MAIL_IN_MAX do
		local sql1 = ""
		local sql2 = ""
		if i == MailInternalGroup.MAIL_IN_favor then
			sql1 = string.format(SQLFavorPageFormat, i, playerUid, 0, 20)
			sql2 = string.format(SQLFavorUnreadAndCountFormat, i, playerUid, playerUid)
			table.insert(t20, sql1)
			table.insert(tCount, sql2)
		elseif i == MailInternalGroup.MAIL_IN_report then
			local cond = self:__getGroupCondSQL(i)
			sql1 = string.format(SQLGroupPageFormatForReport, i, playerUid, cond, 0, 20)
			sql2 = string.format(SQLGroupUnreadAndCountFormatForReport, i, playerUid, cond, playerUid, cond)
			table.insert(t20, sql1)
			table.insert(tCount, sql2)
		elseif i == MailInternalGroup.MAIL_IN_battle then
			local cond = self:__getGroupCondSQL(i)
			sql1 = string.format(SQLGroupPageFormatForBattle, i, playerUid, cond, 0, 20)
			sql2 = string.format(SQLGroupUnreadAndCountFormatForBattle, i, playerUid, cond, playerUid, cond)
			table.insert(t20, sql1)
			table.insert(tCount, sql2)
		elseif i == MailInternalGroup.MAIL_IN_blackKnight or i == MailInternalGroup.MAIL_IN_expeditionaryDuel then
			
		else
			local cond = self:__getGroupCondSQL(i)
			sql1 = string.format(SQLGroupPageFormat, i, playerUid, cond, 0, 20)
			sql2 = string.format(SQLGroupUnreadAndCountFormat, i, playerUid, cond, playerUid, cond)
			table.insert(t20, sql1)
			table.insert(tCount, sql2)
		end
	end

	local t20SQL = table.concat(t20, " UNION ALL ")
	local tCountSQL = table.concat(tCount, " UNION ALL ")

	local tbl = {
		"pragma table_info ('MailData')",
		t20SQL,
		tCountSQL,
	}

	LuaDBInterface.ExecuteMultiSQL(tbl,
			function(r)
				onInitMailGet(self, r)
			end)
end


-- 随机一些邮件
local function RandMails(max_count)
	local format = [[
	INSERT OR REPLACE INTO MailData (
		"uid",
		"toUser",
		"fromUser",
		"fromName",
		"title",
		"subTitle",
		"contents",
		"rewardId",
		"itemIdFlag",
		"status",
		"type",
		"rewardStatus",
		"saveFlag",
		"createTime",
		"reply",
		"replyText",
		"translationId",
		"mbLevel",
		"rewardTime",
		"extParam1",
		"extParam2",
		"translateMsg",
		"translatedLang",
		"expireTime",
		"isReport"
	) VALUES (abs(RANDOM()), '%s', '', '', '310309', "", '310311', '', '1', '0', '%d', '1', '0', strftime('%%s','now')*1000 + abs(random() %% 1000) - abs(random() %% 86400000*5), '0', '', '', '0', '0', '', '')
	]]
	
	local t = {}
	local playerUid = ChatInterface.getPlayerUid()
	
	for i=1,max_count do
		local type = MailType[table.randomKey(MailType)] or 0
		if type == 10000 then
			type = 2
		end
		
		local sql = string.format(format, playerUid, type)
		table.insert(t, sql)
	end

	LuaDBInterface.ExecuteMultiSQL(t,
		function(r)
			local a = 0
		end)
end

-- 数据库处理；主要是处理返回uid列表的情况
local function __doDBCallback(result, callback)
	if callback ~= nil then
		local mailUids = {}
		if result.error ~= 0 and table.IsNullOrEmpty(result.values) then
			MailPrint("result error~~!")
		else
			local t = LuaDBInterface.ParseResultToMultiLuaTables(result)
			for _,v in ipairs(t) do
				table.insert(mailUids, v.uid)
			end
		end
		callback(mailUids)
	end
end

-- 上面都是一些私有方法！
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- 初始化数据库注意是一个异步过程
-- 数据库初始化好了之后去创建表，也是异步过程
-- callback回调函数，每个步骤处理都会有一次通知

function MailDBManager:Init(callback)
	ChatPrint("MailDBManager:Init")
	self.callback = callback
	self.curPlayerUid = LuaEntry.Player.uid
	
	-- 所有邮件未读
	--LuaDBInterface.ExecuteSQL("UPDATE MailData Set status = 0")
	--RandMails(100)
	if CS.SDKManager.IS_UNITY_ANDROID() then
		local sqlTemp  ="PRAGMA temp_store_directory ='"..util.GetPersistentDataPath().."'"
		LuaDBInterface.ExecuteSQL(sqlTemp,
				function (result)
				end)
	end
	self:__MailDBInitRequest()
end

function MailDBManager:Uninit()
	ChatPrint("MailDBManager:Uninit")
	self.callback = nil
	self.self.curPlayerUid = ""
end


-- 插入某个用户数据
-- 这个callback(bool) 有个参数，标志true or false
function MailDBManager:InsertMailData(mailData, callback)

	if string.IsNullOrEmpty(mailData.uid) or string.IsNullOrEmpty(mailData.toUser) then
		MailPrint("mailData error!!!")
		return
	end

	local sql = MakeInsertMailDatas(mailData, true)
	LuaDBInterface.ExecuteSQL(sql, 
		function (result)
			if callback ~= nil then
				local ret = (result.error == 0 and result.change_rows == 1) and true or false
				callback(ret)
			end
		end)
end

-- 插入多个用户数据
function MailDBManager:InsertMailDatas(mailDatas, callback)

	if table.IsNullOrEmpty(mailDatas) then
		MailPrint("mailDatas error!!!")
		return
	end

	local sqls = MakeInsertMailDatas(mailDatas, false)
	LuaDBInterface.ExecuteMultiSQL(sqls, 
		function (result)
			if callback ~= nil then
				local allisok = true
				for _,v in ipairs(result) do
					if v.error ~= 0 then	-- 这里先不判断change_rows了
						allisok = false
					end
				end

				callback(allisok)
			end
		end)
end

-- 获取某个邮件数据
-- callback(mailData)，如果存在返回mailData，否则是nil
function MailDBManager:QueryMailData(mailId, callback)

	local sql = string.format("SELECT * FROM MailData WHERE uid = '%s'", mailId)
	LuaDBInterface.ExecuteSQL(sql, 
		function (result)
			if callback ~= nil then
				local mailData = ParseResultToMailDatas(result)
				if mailData then
					callback(mailData[1])
				end
			end
		end)
end

-- 更新邮件的领取状态
-- mailIds 是一个用,号分割的id列表；或者是单个uid
function MailDBManager:UpdateMailData_Claim(mailIds, callback)
	
	local cond = ""
	if type(mailIds) == "table" then
		for _,v in ipairs(mailIds) do
			if _ > 1 then
				cond = cond .. " or "
			end
			cond = cond .. "`uid` = '" .. v .. "'"
		end
	else
		cond = "`uid` = '" .. mailIds .. "'"
	end
	
	local Update_Read_SQL = "UPDATE MailData SET `status`=1, `rewardStatus`=1 WHERE "
	--local sql = string.format(Update_Read_SQL, mailIds)

	local sql = Update_Read_SQL .. cond
	MailPrint("UpdateMailData_Read : " .. cond)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			if callback ~= nil then
			end
		end)
end

-- 更新邮件的领取状态
-- 收藏的邮件算不算当前组？
function MailDBManager:UpdateMailData_ClaimAll(groupId, callback)
	--
	--local playerUid = self.curPlayerUid
	--local groupTypes = self:__getGroupCondSQL(groupId)
	--
	--local sql = string.format(
	--	"UPDATE MailData SET rewardStatus=1 WHERE `toUser` = '%s' and %s", 
	--	playerUid, groupTypes)
	--
	--MailPrint("UpdateMailData_ClaimAll : " .. groupId)
	--LuaDBInterface.ExecuteSQL(sql,
	--	function (result)
	--		if callback ~= nil then
	--		end
	--	end)
end

-- 更新邮件的已读状态
function MailDBManager:UpdateMailData_Read(mailId, callback)
	
	local Update_Read_SQL = "UPDATE MailData SET status=1 WHERE `uid`='%s'"
	local sql = string.format(Update_Read_SQL, mailId)
	
	MailPrint("UpdateMailData_Read : " .. mailId)
	LuaDBInterface.ExecuteSQL(sql, 
		function (result)
			if callback ~= nil then
			end
		end)
end

function MailDBManager:UpdateMailData_Translate(mailId, translateMsg, translatedLang)
	local Update_Read_SQL = "UPDATE MailData SET translateMsg='%s',translatedLang='%s' WHERE `uid`='%s'"
	local sql = string.format(Update_Read_SQL, translateMsg, translatedLang, mailId)

	MailPrint("UpdateMailData_Translated : " .. mailId)
	LuaDBInterface.ExecuteSQL(sql,
			function (result)
				if callback ~= nil then
				end
			end)
end

-- 更新邮件的已读状态
function MailDBManager:UpdateMailData_ReadAll(groupId, callback)
	local playerUid = self.curPlayerUid
	local groupTypes = self:__getGroupCondSQL(groupId)

	local sql = string.format(
		"UPDATE MailData SET `status`=1 WHERE `toUser` = '%s' AND %s",
		playerUid, groupTypes)
	if groupId == MailInternalGroup.MAIL_IN_battle then
		--战报在数据库剔除特殊邮件
		local extra = "AND `isReport` == 0"
		sql = sql..extra
	elseif groupId == MailInternalGroup.MAIL_IN_report then
		--把在打野的战报额外已读
		local extra = "AND (`isReport` == 1 OR `isReport` == 2 OR `isReport` == 3)"
		sql = sql..extra
	end
	MailPrint("UpdateMailData_ReadAll : " .. groupId)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			if callback ~= nil then
			end
		end)
end

-- 更新战报的分组标识
function MailDBManager:SetMailData_IsReport(mailId, value,callback)

	local Update_Read_SQL = "UPDATE MailData SET `isReport` = %s WHERE `uid`='%s'"
	local sql = string.format(Update_Read_SQL,value, mailId)

	MailPrint("UpdateMailData_Read : " .. mailId)
	LuaDBInterface.ExecuteSQL(sql,
			function (result)
				if callback ~= nil then
				end
			end)
end

-- 删除邮件数据
function MailDBManager:RemoveMailData(mailId)
	
	local playerUid = self.curPlayerUid
	local sql = string.format("DELETE FROM MailData WHERE `toUser` = '%s' AND `uid` = '%s'", 
		playerUid, mailId)

	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			local t = 0
		end)
end

function MailDBManager:RemoveAllMailData()
	local sql = "DELETE FROM MailData"

	LuaDBInterface.ExecuteSQL(sql,
			function (result)
				local t = 0
			end)
end

-- 删除指定的邮件数据
function MailDBManager:RemoveMailDatas(mailIds)

	if table.IsNullOrEmpty(mailIds) then
		MailPrint("RemoveMailDatas null!")
		return
	end
	local cond = ""
	if type(mailIds) == "table" then
		cond = table.concat(mailIds, "','")
	else
		cond = mailIds
	end
	local sql1 = "DELETE FROM MailData WHERE `uid` in ('" .. cond .. "')"

	LuaDBInterface.ExecuteSQL(sql1,
			function (result)
				local t = 0
			end)
end


-- 一键删除所有已读邮件和已领奖邮件
function MailDBManager:RemoveMailDataAll(groupId)
	
	-- 如果是favor组的话，就得特殊处理一下
	if (groupId == MailInternalGroup.MAIL_IN_favor) then
		self:RemoveFavorMails()
		return
	end
	
	local playerUid = self.curPlayerUid
	local groupTypes = self:__getGroupCondSQL(groupId)
	
	-- 分组里，没有收藏的，已经读取的，和已经领奖的，这几个标记
	local sql1 = string.format(
		"DELETE FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND %s", 
		playerUid, groupTypes)

	if groupId == MailInternalGroup.MAIL_IN_battle then
		--排除掉打野里的战报
		local extra = " AND `isReport` == 0"
		sql1 = sql1..extra
	elseif groupId == MailInternalGroup.MAIL_IN_report then
		--战报里的isReport
		--把在打野的战报额外已读
		local extra = "AND (`isReport` == 1 OR `isReport` == 2 OR `isReport` == 3)"
		sql1 = sql1..extra
	end

	LuaDBInterface.ExecuteSQL(sql1,
		function (result)
			local t = 0
		end)
end

--删除部分邮件，  list  不删除的邮件
function MailDBManager:RemoveMailDataSelect(groupId,list)
	-- 如果是favor组的话，就得特殊处理一下
	if (groupId == MailInternalGroup.MAIL_IN_favor) then
		self:RemoveFavorMails()
		return
	end

	local playerUid = self.curPlayerUid
	local groupTypes = self:__getGroupCondSQL(groupId)

	local cond = ""
	for _,v in pairs(list) do
		if _ > 1 then
			cond = cond .. " or "
		end
		cond = cond .. "`uid` != '" .. v .. "'"
	end

	-- 分组里，没有收藏的，已经读取的，和已经领奖的，这几个标记
	local sql1 = string.format(
			"DELETE FROM MailData WHERE `toUser` = '%s' AND `saveFlag` = 0 AND `status` = 1 AND `rewardStatus` = 1 AND ",
			playerUid)
	local sql2 = sql1 .. cond .." AND "..groupTypes

	LuaDBInterface.ExecuteSQL(sql2,
			function (result)
				local t = 0
			end)
end

-- 删除所有收藏邮件（有个规则就是收藏的邮件肯定是已读和已领奖）
function MailDBManager:RemoveFavorMails()
	
	local playerUid = self.curPlayerUid
	local sql = string.format("DELETE FROM MailData WHERE `toUser` = '%s' AND saveFlag = 1",
		playerUid)

	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			local t = 0
		end)
end

-- 邮件加入收藏
function MailDBManager:UpdateMailData_AddFavor(mailId, callback)
	local Update_Favor_SQL = "UPDATE MailData SET saveFlag=1 WHERE `uid`='%s'"
	local sql = string.format(Update_Favor_SQL, mailId)

	MailPrint("UpdateMailData_AddFavor : " .. mailId)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			if callback ~= nil then
			end
		end)
end

-- 邮件取消收藏
function MailDBManager:UpdateMailData_CancelFavor(mailId, callback)
	local Update_CancelFavor_SQL = "UPDATE MailData SET saveFlag=0 WHERE `uid`='%s'"
	local sql = string.format(Update_CancelFavor_SQL, mailId)

	MailPrint("UpdateMailData_CancelFavor : " .. mailId)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			if callback ~= nil then
			end
		end)
end

-- 获取更多邮件
function MailDBManager:QueryMoreMails(groupId, start, count, callback)
	
	local playerUid = self.curPlayerUid
	local sql = ""
	
	-- favor这个group必须要特殊处理一下
	if groupId == MailInternalGroup.MAIL_IN_favor then
		sql = string.format(SQLFavorPageFormat, groupId, playerUid, start, count)
	elseif groupId == MailInternalGroup.MAIL_IN_report then
		local cond = self:__getGroupCondSQL(groupId)
		sql = string.format(SQLGroupPageFormatForReport, groupId, playerUid, cond, start, count)
	elseif groupId == MailInternalGroup.MAIL_IN_battle then
		local cond = self:__getGroupCondSQL(groupId)
		sql = string.format(SQLGroupPageFormatForBattle, groupId, playerUid, cond, start, count)
	elseif groupId == MailInternalGroup.MAIL_IN_blackKnight then
		local cond = self:__getGroupCondSQL(groupId)
		sql = string.format(SQLGroupPageFormatForBlackKnight, groupId, playerUid, cond, start, count)
	elseif groupId == MailInternalGroup.MAIL_IN_expeditionaryDuel then
		local cond = self:__getGroupCondSQL(groupId)
		sql = string.format(SQLGroupPageFormatForExpeditionaryDuel, groupId, playerUid, cond, start, count)
	else
		local cond = self:__getGroupCondSQL(groupId)
		sql = string.format(SQLGroupPageFormat, groupId, playerUid, cond, start, count)
	end
	
	MailPrint("QueryMoreMails : " .. sql)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			if callback ~= nil then
				if result.error ~= 0 and table.IsNullOrEmpty(result.values) then
					callback(nil)
				else
					local mailDatas = ParseResultToMailDatas(result)
					callback(mailDatas)
				end
			end
		end)
end

-- 获取已读和已领奖邮件uids，单次最多获取500个吧
function MailDBManager:GetAllCanDeleteMailUids(groupId, callback)

	local playerUid = self.curPlayerUid
	local sql = ""

	-- favor这个group必须要特殊处理一下
	if groupId == MailInternalGroup.MAIL_IN_favor then
		sql = string.format(SQLFavorAllUidFormat, groupId, playerUid)
	else
		local cond = self:__getGroupCondSQL(groupId)
		sql = string.format(SQLGroupAllUidFormat, groupId, playerUid, cond)
		if groupId == MailInternalGroup.MAIL_IN_battle then
			sql = string.format(SQLGroupAllUidForBattleFormat, groupId, playerUid, cond)
		elseif groupId == MailInternalGroup.MAIL_IN_report then
			sql = string.format(SQLGroupAllUidIsReportFormat, groupId, playerUid, cond)
		elseif groupId == MailInternalGroup.MAIL_IN_blackKnight then
			sql = string.format(SQLGroupAllUidBlackKnightFormat, groupId, playerUid, cond)
		elseif groupId == MailInternalGroup.MAIL_IN_expeditionaryDuel then
			sql = string.format(SQLGroupAllUidExpeditionaryDuelFormat, groupId, playerUid, cond)
		end
	end

	MailPrint("GetAllCanDeleteMailUids : " .. sql)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			__doDBCallback(result, callback)
		end)
end

-- 获取所有未读邮件uids，目前应该只有采集使用了
function MailDBManager:GetAllUnreadMailUids(groupId, callback)

	local playerUid = self.curPlayerUid
	local sql = ""

	-- favor这个group必须要特殊处理一下
	if groupId == MailInternalGroup.MAIL_IN_favor then
		return
	else
		local cond = self:__getGroupCondSQL(groupId)
		sql = string.format(SQLGroupNotReadFormat, groupId, playerUid, cond)
	end

	MailPrint("GetAllUnreadMailUids : " .. sql)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			__doDBCallback(result, callback)
		end)
end

-- 获取未领奖邮件uids，
function MailDBManager:GetAllCanRewardMailUids(groupId, callback)

	local playerUid = self.curPlayerUid
	local sql = ""

	-- favor这个group必须要特殊处理一下
	if groupId == MailInternalGroup.MAIL_IN_favor then
		return
	else
		local cond = self:__getGroupCondSQL(groupId,16)
		sql = string.format(SQLGroupNotRewardFormat, groupId, playerUid, cond)
	end

	MailPrint("GetAllUnreadMailUids : " .. sql)
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			__doDBCallback(result, callback)
		end)
end

--[[
-- 获取未领奖邮件uids，单次最多获取500个吧
function MailDBManager:GetAllCanRewardMailUids(groupId, callback)

	local playerUid = self.curPlayerUid
	local sqls = {}

	-- favor这个group不用处理
	if groupId == MailInternalGroup.MAIL_IN_favor then
		return
	else
		local cond = self:__getGroupCondSQL(groupId)
		local sql1 = string.format(SQLGroupNotRewardFormat, groupId, playerUid, cond)
		local sql2 = string.format(SQLGroupNotReadFormat, groupId, playerUid, cond)
		table.insert(sqls, sql1)
		table.insert(sqls, sql2)
	end

	MailPrint("GetAllCanRewardMailUids : " .. tostring(sqls))
	LuaDBInterface.ExecuteMultiSQL(sqls,
		function (result)
			if callback == nil then
				return 
			end
			
			-- 返回给上层两个集合；让其分别处理吧。注意可能有叠加，不过没关系	
			if result and #result>=2 then
				local rewardUids = {}
				local unreadUids = {}
				if result[1].error == 0 and not table.IsNullOrEmpty(result[1].values) then
					local t = LuaDBInterface.ParseResultToMultiLuaTables(result[1])
					for k,v in ipairs(t) do
						table.insert(rewardUids, v.uid)
					end
				end
				if result[2].error == 0 and not table.IsNullOrEmpty(result[2].values) then
					local t = LuaDBInterface.ParseResultToMultiLuaTables(result[2])
					for k,v in ipairs(t) do
						table.insert(unreadUids, v.uid)
					end
				end
				callback(rewardUids, unreadUids)
			else
				callback(nil, nil)
			end

		end)
end
]]

return MailDBManager
