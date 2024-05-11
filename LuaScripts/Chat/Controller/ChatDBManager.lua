--[[ 
	聊天数据库管理器（聊天移植到Lua的最终版）
	不要把执行SQL的函数暴露给用户层了，因为用户其实是不用知道表结构的
]]

local ChatDBManager = BaseClass("ChatDBManager")

function ChatDBManager:__init()
	
	self.isInit = false
	self.sql_count = 0
end

-- 用户信息表结构
local tblUserInfoData = 
{
	-- name						type		notnull	dflt_value	pk
	{"uid", 					"varchar", 	1,		"",			1 },	
	{"userName", 				"varchar", 	0,		"",			0 },
	{"serverId", 				"integer",	0,		"",			0 },
	{"crossFightSrcServerId",	"integer",	0,		"",			0 },
	{"headPic",					"varchar",	0,		"",			0 },
	{"headPicVer", 				"integer",	0,		"",			0 },
	
	{"gmFlag", 					"integer",	0,		"",			0 },
	{"careerId",				"varchar",	0,		"",			0 },
	{"lastUpdateTime",			"bigint",	0,		"",			0 },
	
	{"monthCard",				"integer",	0,		"",			0 },
	{"vipLevel", 				"integer",	0,		"",			0 },
	{"svipLevel",				"integer",	0,		"",			0 },
	{"vipframe", 				"integer",	0,		"",			0 },
	{"vipEndTime", 				"bigint",	0,		"",			0 },
	
	{"allianceId", 				"varchar",	0,		"",			0 },
	{"allianceSimpleName", 		"varchar",	0,		"",			0 },
	
	{"chatSkinId", 				"varchar",	0,		"",			0 },
	{"chatFrameId", 			"varchar",	0,		"",			0 },
	{"chatBantime", 			"bigint",	0,		"",			0 },
	{"careerType",				"integer",	0,		"",			0 },
	{"careerLv",				"integer",	0,		"",			0 },
	{"mainBuildingLevel",		"integer",	0,		"",			0 },
	{"nation",					"varchar",	0,		"",			0 },
	{"monthCardEndTime",		"integer",	0,		"",			0 },
	{"sex",						"integer",	0,		"",			0 },
	{"headSkinId",				"integer",	0,		"",			0 },
	{"headSkinET",				"bigint",	0,		"",			0 },
	{"positionId",				"integer",	0,		"",			0 },
	{"titleSkinId",				"integer",	0,		"",			0 },
	{"titleSkinET",				"bigint",	0,		"",			0 },
	--{"extra",					"varchar",	0, 		"",			0 },
	--{"JsonStr",					"varchar", 	0,		"",			0 },
}
	

-- 聊天数据表结构
local tblChatData = 
{
	-- name						type		notnull	dflt_value	pk
	{"Key", 					"varchar", 	1,		"",			1 },
	{"seqId",					"integer",	0,		"",			0 },		-- 服务器消息序号
	{"group",					"varchar",	0,		"",			0 },
	{"type",					"integer",	0,		"",			0 },
	{"roomId",					"varchar",	0,		"",			0 },		-- 房间id
	{"senderUid",				"varchar",	0,		"",			0 },		-- 发送者id
	{"senderName",				"varchar",	0,		"",			0 },
	
	{"sendState",				"integer",	0,		"",			0 },		-- 发送状态
	{"serverTime",				"real",		0,		"",			0 },		-- 发送时的服务器时间 单位毫秒 对应后台传回来的createTime 作用于更新信息创建时间。针对别的玩家
	{"sendLocalTime",			"bigint",	0,		"",			0 },		-- 发送者本地时间   单位秒  主要用于发送聊天回包通过此字段查找数据库聊天数据更新数据用
	
	{"post",					"integer",	0,		"",			0 },		-- 消息类型
	{"msg",						"varchar",	0,		"",			0 },
	{"msgMask",					"varchar",	0,		"",			0 },		-- 处理过的消息体，例如：处理过屏蔽字的消息
	
	{"isTranslating",			"integer",	0,		"",			0 },		-- 是否正在翻译？这个要入库？
	{"translateMsg",			"varchar",	0,		"",			0 },
	{"originalLang",			"varchar",	0,		"",			0 },		-- 源语言
	{"targetLang",				"varchar",	0,		"",			0 },	
	
	{"attachmentId",			"varchar",	0,		"",			0 },		-- msg 会根据这个字段进行拼接显示内容
	{"media",					"varchar",	0,		"",			0 },
	
	--{"extra",					"varchar",	0, 		"",			0 },
	--{"JsonStr",					"varchar",	0,		"",			0 },
}


-- 频道数据表结构
-- 主要用来保存lastClickTime，这个是频道最后的点击时间
-- 如果这个频道内，有消息的时间戳大于这个时间，那么就表示有新消息了
local tblRoomData =
{
	-- name						type		notnull	dflt_value	pk
	{"Key", 					"varchar", 	1,		"",			1 },		-- 联合id
	{"roomId", 					"varchar", 	1,		"",			0 },
	{"gameUid",					"varchar",	1,		"",			0 },		-- 频道相关的gameuid
	{"isPin",					"integer",	0,		"",			0 },		-- 是否pin
	{"firstMsgTime",			"real",		0,		"",			0 },		
	{"lastMsgTime",				"real",		0,		"",			0 },
	{"lastClickTime",			"real",		0,		"",			0 },		-- 最后点击时间
	{"group",					"integer",	0,		"",			0 },
	{"owner",					"varchar",	0,		"",			0 },
	{"appId",					"varchar",	0,		"",			0 },
	{"name",					"varchar",	0,		"",			0 },
	{"memberList",				"varchar",	0,		"",			0 },
}


-- 插入ChatData模板
local Insert_ChatData_SQL = [[INSERT OR REPLACE INTO ChatData (
"Key",
"seqId",
"group",
"type",
"roomId",
"senderUid",
"senderName",
"sendState",
"serverTime",
"sendLocalTime",
"post",
"msg",
"msgMask",
"isTranslating",
"translateMsg",
"originalLang",
"targetLang",
"attachmentId",
"media"
) VALUES ]]

-- 更新ChatData模板
local Update_ChatData_SQL = [[UPDATE ChatData 
SET Key='%s', seqId='%d', sendState='%d' 
WHERE Key='%s']]

-- 单条聊天信息sql insert value 字符串
local function GetSingleChatInfoValue(cm)
	
	local Key = string.format("%s_%d", cm.roomId, cm.seqId)
	local v = "(".. "'" .. Key .. "', "
	.. "'" .. cm.seqId .. "', "
	.. "'" .. cm.group .. "', "
	.. "'" .. cm.type .. "', "
	.. "'" .. LuaDBInterface.escape(cm.roomId or "") .. "', "
	.. "'" .. (cm.senderUid or 0) .. "', "
	.. "'" .. LuaDBInterface.escape(cm.senderName or "") .. "', "
	.. "'" .. (cm.sendState or 0) .. "', "
	.. "'" .. (cm.serverTime or 0) .. "', "
	.. "'" .. (cm.sendLocalTime or 0) .. "', "
	.. "'" .. (cm.post or 0) .. "', "
	.. "'" .. LuaDBInterface.escape(cm.msg or "") .. "', "
	.. "'" .. LuaDBInterface.escape(cm.msgMask or "") .. "', "
	.. "'" .. (cm.isTranslating or 0) .. "', "
	.. "'" .. LuaDBInterface.escape(cm.translateMsg or "") .. "', "
	.. "'" .. (cm.originalLang or "") .. "', "
	.. "'" .. (cm.targetLang or "") .. "', "
	.. "'" .. LuaDBInterface.escape(cm.attachmentId or "") .. "', "
	.. "'" .. (cm.media or "") .. "' "
	.. ")"
	
	return v
end
-- 制作批量插入聊天数据到数据库的SQL
-- 暂时应该不需要优化：https://www.jianshu.com/p/faa5e852b76b?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
-- single表示到底是1条还是多条，不要去用代码判断了，手动传入
local function MakeInsertChatInfos(chatMessages, single)

	if single then
		local sql = Insert_ChatData_SQL .. GetSingleChatInfoValue(chatMessages)
		return sql
	end
		
	local sqls = {}
	for i=1,#chatMessages do
		table.insert(sqls, Insert_ChatData_SQL .. GetSingleChatInfoValue(chatMessages[i]))
	end

	return sqls
end

-- 插入用户数据模板
local Insert_UserInfo_SQL = [[INSERT OR REPLACE INTO UserInfoData (
"uid",
"userName",
"serverId",
"crossFightSrcServerId",
"headPic",
"headPicVer",
"gmFlag",
"careerId",
"lastUpdateTime",
"monthCard",
"vipLevel",
"svipLevel",
"vipframe",
"vipEndTime",
"allianceId",
"allianceSimpleName",
"chatSkinId",
"chatFrameId",
"chatBantime",
"careerType",
"careerLv",
"mainBuildingLevel",
"nation",
"monthCardEndTime",
"sex",
"headSkinId",
"headSkinET",
"positionId",
"titleSkinId",
"titleSkinET"
) VALUES ]]

-- 单条消息
local function GetSingleUserInfoValue(userInfo)
	local v = "("
		.. "'" .. userInfo.uid .. "', "
		.. "'" .. LuaDBInterface.escape(userInfo.userName) .. "', "
		.. "'" .. userInfo.serverId .. "', "
		.. "'" .. (userInfo.crossFightSrcServerId or 0) .. "', "
		.. "'" .. (userInfo.headPic or "") .. "', "
		.. "'" .. (userInfo.headPicVer or 0) .. "', "
		.. "'" .. (userInfo.gmFlag or 0) .. "', "
		.. "'" .. (userInfo.careerId or "") .. "', "
		.. "'" .. (userInfo.lastUpdateTime or 0) .. "', "
		.. "'" .. (userInfo.monthCard or 0) .. "', "
		.. "'" .. (userInfo.vipLevel or 0) .. "', "
		.. "'" .. (userInfo.svipLevel or 0) .. "', "
		.. "'" .. (userInfo.vipframe or 0) .. "', "
		.. "'" .. (userInfo.vipEndTime or 0) .. "', "
		.. "'" .. (userInfo.allianceId or "") .. "', "
		.. "'" .. (userInfo.allianceSimpleName or "") .. "', "
		.. "'" .. (userInfo.chatSkinId or "") .. "', "
		.. "'" .. (userInfo.chatFrameId or "") .. "', "
		.. "'" .. (userInfo.chatBantime or 0) .. "', "
		.. "'" .. (userInfo.careerType or 0) .. "', "
		.. "'" .. (userInfo.careerLv or 0) .. "', "
		.. "'" .. (userInfo.mainBuildingLevel or 0) .. "', "
		.. "'" .. (userInfo.nation or "UN") .. "', "
		.. "'" .. (userInfo.monthCardEndTime or 0) .. "', " 
		.. "'" .. (userInfo.sex or 0) .. "', "
		.. "'" .. (userInfo.headSkinId or 0) .. "', " 
		.. "'" .. (userInfo.headSkinET or 0) .. "', "
		.. "'" .. (userInfo.positionId or 0) .. "', "
		.. "'" .. (userInfo.titleSkinId or 0) .. "', "
		.. "'" .. (userInfo.titleSkinET or 0) .. "' "
		.. ")"
	return v
end

-- 插入某个用户数据SQL
local function MakeInsertUserInfos(userInfos, single)

	if single then
		local sql = Insert_UserInfo_SQL .. GetSingleUserInfoValue(userInfos)
		return sql
	end

	local sqls = {}
	for i=1,#userInfos do
		table.insert(sqls, Insert_UserInfo_SQL .. GetSingleUserInfoValue(userInfos[i]))
	end

	return sqls
end


-- 插入房间数据模板
local Insert_RoomData_SQL = [[INSERT OR REPLACE INTO RoomData (
"Key",
"roomId",
"gameUid",
"isPin",
"firstMsgTime",
"lastMsgTime",
"lastClickTime",
"group",
"owner",
"appId",
"name",
"memberList"
) VALUES ]]

-- 主要用来更新房间频道的属性；isPin和最后点击时间
local Update_RoomData_SQL = [[UPDATE RoomData
SET isPin='%d', lastClickTime='%f', name='%s'
WHERE Key='%s']]

-- 单条消息
local function GetSingleRoomDataValue(uid, rd)
	local Key = string.format("%s-%s", uid, rd.roomId)
	local memberListStr = ""
	if rd.memberList and #rd.memberList > 0 then
		memberListStr = table.concat(rd.memberList, ';')
	end
	
	local v = "("
	.. "'" .. Key .. "', "
	.. "'" .. LuaDBInterface.escape(rd.roomId) .. "', "
	.. "'" .. uid .. "', "
	.. "'" .. (rd.isPin or 0) .. "', "
	.. "'" .. (rd.firstMsgTime or 0) .. "', "
	.. "'" .. (rd.lastMsgTime or 0) .. "', "
	.. "'" .. (rd.lastClickTime or 0) .. "', "
	.. "'" .. (rd.group or 0) .. "', "
	.. "'" .. (rd.owner or 0) .. "', "
	.. "'" .. (rd.appId or "") .. "', "
	.. "'" .. (rd.name or 0) .. "', "
	.. "'" .. memberListStr .. "' "
	.. ")"
	
	return v
end

-- 插入某个用户数据SQL
local function MakeInsertRoomDatas(uid, roomDatas, single)

	if single then
		local sql = Insert_RoomData_SQL .. GetSingleRoomDataValue(uid, roomDatas)
		return sql
	end

	local sqls = {}
	for k, v in pairs(roomDatas) do
		table.insert(sqls, Insert_RoomData_SQL .. GetSingleRoomDataValue(uid, v))
	end

	return sqls
end

-- 创建表
local function CreateChatTable(sqlTable)
	LuaDBInterface.CreateOneTable(sqlTable, "ChatData", tblChatData)
	table.insert(sqlTable, "CREATE UNIQUE INDEX index_chatdata_key on ChatData (Key)")
	table.insert(sqlTable, "CREATE INDEX index_chatdata_roomId on ChatData (roomId)")
end

local function CreateUserInfoTable(sqlTable)
	LuaDBInterface.CreateOneTable(sqlTable, "UserInfoData", tblUserInfoData)
	table.insert(sqlTable, "CREATE UNIQUE INDEX index_userinfo_uid on UserInfoData (uid)")
end

local function CreateRoomDataTable(sqlTable)
	LuaDBInterface.CreateOneTable(sqlTable, "RoomData", tblRoomData)
end

-- 处理ChatUserInfo的数据
-- 理论上可以从ParseResultToLuaTable解析成通用数据再赋值，但是会产生额外开销
local function ParseResultToUserInfo(result)
	local tbl = {}

	-- 数据不存在或者查询出错了
	if result == nil or result.error ~= 0 or result.cols == nil then
		ChatPrint("userinfo error!!")
		return tbl
	end

	if result.values == nil or #result.values <= 0 then
		ChatPrint("chat result.values error")
		return tbl
	end

	-- cols列名, values是数值（注意是一个Array，所以我们只取第一行即可）
	local col_count = result.col_count
	local cols = result.cols

	if col_count <= 0 then
		ChatPrint("col_count error")
		return tbl
	end

	local UserMgr = ChatManager2:GetInstance().User
	for rowidx=1,#result.values do
		local row = UserMgr:CreateUserInfo()
		for i=1,col_count do
			local k = cols[i].name
			local v = result.values[rowidx][i]
			row[k] = v
		end

		-- 从数据库读出来的UserInfo就算info_ok = true
		row:SetInfoOK()
		table.insert(tbl, row)
	end

	return tbl
end

-- 处理ChatMessage的数据
local function ParseResultToChatMessage(result)
	local tbl = {}

	-- 数据不存在或者查询出错了
	if result == nil or result.error ~= 0 or result.cols == nil then
		ChatPrint("chat error!")
		return tbl
	end

	if result.values == nil or #result.values <= 0 then
		return tbl
	end

	-- cols列名, values是数值
	local col_count = result.col_count
	local cols = result.cols

	local RoomMgr = ChatManager2:GetInstance().Room
	for rowidx=1,#result.values do
		local row = RoomMgr:CreateChatMessage() --ChatMessage.New()
		for i=1,col_count do
			local k = cols[i].name
			local v = result.values[rowidx][i]
			row[k] = v
		end
		table.insert(tbl, row)
	end

	return tbl
end

-- 处理一下用户信息
local function processCacheUserInfo (result)
	local userInfos = ParseResultToUserInfo(result)
	if userInfos == nil then
		return 
	end
	
	-- 数据库初始化完毕之后，直接先缓存一些用户信息，避免每次从数据库读取
	-- 从数据库读出来的UserInfo，就算self.info_ok = true了
	local UserManager = ChatManager2:GetInstance().User
	for i=1,#userInfos do
		UserManager:addChatUserInfo(userInfos[i])
	end
end

-- 处理缓存的房间信息
local function processCacheRoomData (result)	
	local roomInfos = LuaDBInterface.ParseResultToMultiLuaTables(result)
	ChatManager2:GetInstance().Room:SetCacheRoomInfos(roomInfos)
end

-- 有表修改，无表创建
-- FIXME: 这里的逻辑不是很严谨
local function onCreateOrAlterTable(self, result)
	
	-- 最终需要处理的sql语句集合
	-- 其中result[1]表示UserInfoData;result[2]表示ChatData
	local sqls = {}
	
	if result == nil then
		CreateChatTable(sqls)
		CreateUserInfoTable(sqls)
		CreateRoomDataTable(sqls)
	else
		if #result > 0 then
			if (result[1].col_count == 0 or #result[1].values == 0) then
				CreateUserInfoTable(sqls)
			else
				LuaDBInterface.MigrateOneTable(sqls, "UserInfoData", result[1], tblUserInfoData)
			end
		end
		
		if #result > 1 then
			if (result[2].col_count == 0 or #result[2].values == 0) then
				CreateChatTable(sqls)
			else
				LuaDBInterface.MigrateOneTable(sqls, "ChatData", result[2], tblChatData)
			end
		end
		
		if #result > 2 then
			if (result[3].col_count == 0 or #result[3].values == 0) then
				CreateRoomDataTable(sqls)
			else
				LuaDBInterface.MigrateOneTable(sqls, "RoomData", result[3], tblRoomData)
			end
		end
	end
	
	-- 处理一下用户信息
	if #result >= 4 then
		processCacheUserInfo(result[4])
	end
	
	-- 处理房间信息
	if #result >= 5 then
		processCacheRoomData(result[5])
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


function ChatDBManager:__Callback(status, reason)
	if (self.callback) then
		self.callback(status, reason)
	else
		ChatPrint("db : " .. status .. "," .. reason)
	end
end


-- 数据库加载完毕，之后初始化各种表数据
function ChatDBManager:__ChatDBInit()
	
	local uid = ChatInterface.getPlayerUid()
	local roomSQL = string.format("SELECT * FROM RoomData WHERE gameUid = '%s'", uid)
	--local roomSQL = string.format("SELECT * FROM RoomData")

	local tbl = {
		"pragma table_info ('UserInfoData')",
		"pragma table_info ('ChatData')",
		"pragma table_info ('RoomData')",
		-- 系统初始化的时候就去缓存300个用户信息
		"SELECT * FROM UserInfoData LIMIT 300",
		-- 同时把系统房间获取出来
		roomSQL
	}

	LuaDBInterface.ExecuteMultiSQL(tbl,
		function(r)
			onCreateOrAlterTable(self, r)
		end)
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

function ChatDBManager:Init(callback)
	ChatPrint("ChatDBManager:Init")
	self.callback = callback
	self:__ChatDBInit()
end

function ChatDBManager:Uninit()
	ChatPrint("ChatDBManager:Uninit")
	self.callback = nil
end


-- 插入某个用户数据
-- 这个callback(bool) 有个参数，标志true or false
function ChatDBManager:InsertUserInfo(userInfo, callback)
	
	if userInfo.uid == nil or userInfo.userName == nil or userInfo.serverId == nil then
		ChatPrint("userInfo error!!!")
		return
	end
	
	local sql = MakeInsertUserInfos(userInfo, true)
	LuaDBInterface.ExecuteSQL(sql, function (result)
		if callback ~= nil then
			local ret = (result.error == 0 and result.change_rows == 1) and true or false
			callback(ret)
		end
	end)
end

-- 插入多个用户数据
function ChatDBManager:InsertUserInfos(userInfos, callback)
	
	if type(userInfos) ~= "table" or #userInfos == 0 then
		return
	end

	local sqls = MakeInsertUserInfos(userInfos, false)
	LuaDBInterface.ExecuteMultiSQL(sqls, function (result)
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


-- 插入多个频道数据
function ChatDBManager:InsertRoomDatas(roomDatas, callback)

	if type(roomDatas) ~= "table" or table.count(roomDatas) == 0 then
		return
	end

	local sqls = MakeInsertRoomDatas(roomDatas, false)
	LuaDBInterface.ExecuteMultiSQL(sqls, function (result)
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


-- 获取某个用户数据
-- callback(userinfo)，如果存在用户userinfo是用户的table，否则是nil
function ChatDBManager:QueryUserInfo(uid, callback)

	local sql = string.format("SELECT * FROM UserInfoData WHERE uid = '%s'", uid)
	LuaDBInterface.ExecuteSQL(sql, function (result)
			if callback ~= nil then
				local userInfo = ParseResultToUserInfo(result)
				if userInfo then
					callback(userInfo[1])
				end
			end
		end)
end

-- 获取多个用户数据
function ChatDBManager:QueryUserInfos(uidTable, callback)
	
	-- 插入sql语句
	local c = uidTable and #uidTable or 0
	if c == 0 then
		if callback ~= nil then
			callback(nil)
		end
	end
	
	local sql_full = "SELECT * FROM UserInfoData WHERE uid IN ("
	for i=1,c do
		sql_full = sql_full .. "'" .. uidTable[i] .. "'" .. (i~=c and "," or ")")
	end

	LuaDBInterface.ExecuteSQL(sql_full, function (result)
			if callback ~= nil then
				local userInfos = ParseResultToUserInfo(result)
				if userInfos then
					callback(userInfos)
				end
			end
		end)
end

-- 插入某个聊天数据
-- 这个callback(bool) 有个参数，标志true or false
function ChatDBManager:InsertChatInfo(chatMessage, callback)
	
	local sql = MakeInsertChatInfos(chatMessage, true)
	LuaDBInterface.ExecuteSQL(sql, function (result)
			if callback ~= nil then
				local ret = (result.error == 0 and result.change_rows == 1) and true or false
				callback(ret)
			end
		end)
end

-- 插入多条数据
function ChatDBManager:InsertChatInfos(chatMessages, callback)
	
	if chatMessages == nil or #chatMessages == 0 then
		return 
	end
	
	local sqls = MakeInsertChatInfos(chatMessages, false)
	LuaDBInterface.ExecuteMultiSQL(sqls, function (result)
			if callback ~= nil then
				local ret = true -- (result.error == 0 and result.change_rows == 1) and true or false
				callback(ret)
			end
		end)
end

-- 更新我发送的聊天数据
function ChatDBManager:UpdateChatData(oldSeqId, chatMessage, callback)

	local OldKey = string.format("%s_%d", chatMessage.roomId, oldSeqId)
	local NewKey = string.format("%s_%d", chatMessage.roomId, chatMessage.seqId)
	
	--local Update_ChatData_SQL = [[UPDATE ChatData
	--SET Key=%s, sequenceId=%d, sendState=%d
	--WHERE Key=%s]]
	
	local sql = string.format(Update_ChatData_SQL,
		NewKey, tonumber(chatMessage.seqId), tonumber(chatMessage.sendState),
		OldKey)
	
	LuaDBInterface.ExecuteSQL(sql, function (result)
			if callback ~= nil then
				local ret = (result.error == 0 and result.change_rows == 1) and true or false
				callback(ret)
			end
		end)
end

-- 删除聊天数据，根据房间删除
function ChatDBManager:RemoveChatRoom(roomId)
	
	local uid = ChatInterface.getPlayerUid()
	local Key = string.format("%s-%s", uid, roomId)
	
	local t = {}
	-- 首先先把相关的房间数据删除
	local sql1 = string.format("DELETE FROM RoomData WHERE `Key` = '%s'", Key)
	local sql2 = string.format("DELETE FROM ChatData WHERE `roomId` = '%s'", roomId)
	
	table.insert(t, sql1)
	table.insert(t, sql2)
	
	LuaDBInterface.ExecuteMultiSQL(t, 
		function (result)
			local t = 0
		end)
end

-- 查找指定房间的聊天数据
function ChatDBManager:QueryChatByTime(roomId, fromTime, toTime, callback)
	
	local sql = string.format("SELECT * FROM ChatData WHERE `roomId` = '%s' AND `sendLocalTime` >= '%d' AND `sendLocalTime` <= '%d'", roomId, fromTime, toTime)
	LuaDBInterface.ExecuteSQL(sql, function (result)
			if callback ~= nil then
				local charInfos = ParseResultToChatMessage(result)
				callback(chatInfos)
			end
		end)
end

-- 返回房间的最近30条消息
function ChatDBManager:QueryLatestChat(roomId, callback)

	local sql = string.format("SELECT * FROM ChatData WHERE `roomId` == '%s' ORDER BY serverTime DESC LIMIT 30", roomId)
	LuaDBInterface.ExecuteSQL(sql, function (result)
			if callback ~= nil then
				local chatInfos = ParseResultToChatMessage(result)
				callback(chatInfos)
			end
		end)
end

-- 查找指定房间的聊天数据
function ChatDBManager:QueryChatBySeqId(roomId, from, to, callback)

	local sql = string.format("SELECT * FROM ChatData WHERE `roomId` = '%s' AND `seqId` >= '%d' AND `seqId` <= '%d'", roomId, from, to)
	LuaDBInterface.ExecuteSQL(sql, function (result)
			if callback ~= nil then
				local charInfos = ParseResultToChatMessage(result)
				callback(chatInfos)
			end
		end)
end

-- 保存一条聊天数据
function ChatDBManager:SaveChatItem(chatData, callback)
	
	if chatData == nil or chatData.post == PostType.Text_ChatRoomSystemMsg then
		return
	end
	
	local roomData = ChatManager2:GetInstance().Room:GetRoomData(chatData.roomId)
	if roomData == nil then
		return
	end
	
	if roomData:isPrivateChat() then
        return
    end
	
	self:InsertChatInfo(chatData, callback)
end

-- 保存频道列表
function ChatDBManager:InsertRoomDatas(roomDatas, callback)
	if table.IsNullOrEmpty(roomDatas) then
		ChatPrint("no roomdatas!")
		return
	end

	local uid = ChatInterface.getPlayerUid()
	local sqls = MakeInsertRoomDatas(uid, roomDatas, false)	
	
	-- 先把表都删了
	local sql = string.format("DELETE FROM RoomData WHERE `gameUid` == '%s'", uid)
	table.insert(sqls, 1, sql)
	
	LuaDBInterface.ExecuteMultiSQL(sqls, 
		function (result)
			if callback ~= nil then
				local ret = true -- (result.error == 0 and result.change_rows == 1) and true or false
				callback(ret)
			end
		end)
	
end

-- 获取聊天频道列表
function ChatDBManager:QueryRoomDatas(callback)
	local uid = ChatInterface.getPlayerUid()
	local sql = string.format("SELECT * FROM RoomData WHERE `gameUid` == '%s'", uid)
	LuaDBInterface.ExecuteSQL(sql, 
		function (result)
			if callback ~= nil then
				local roomInfos = ParseResultToMultiLuaTables(result)
				callback(roomInfos)
			end
		end)
end

-- 更新聊天频道的属性
function ChatDBManager:UpdateRoomData(rd, callback)
	local uid = ChatInterface.getPlayerUid()
	local Key = string.format("%s-%s", uid, rd.roomId)
	
	local sql = string.format(Update_RoomData_SQL, 
		0, rd.lastClickTime, rd.name, Key)
	
	LuaDBInterface.ExecuteSQL(sql,
		function (result)
			if callback ~= nil then
				local ret = (result.error == 0 and result.change_rows == 1) and true or false
			end
		end)
end

	
return ChatDBManager
