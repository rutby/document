--[[
	LUA DB统一执行接口

	注意：任何逻辑代码不要写在C#中，所有数据库操作都通过SQL语句形式，
	C#中仅仅提供一个SQLite操作的接口。
	按照惯例，上线之后肯定会有修改聊天表结构的需求，这回都放到LUA层
	
	所有操作都通过一个执行SQL的接口，这个优点是可以在lua里操作，且简单方便。
	缺点是无法进行SQL-STMT预处理，在insert或者select大量数据时会略微影响性能

	** 用户表结构是一个table，有5列，基本等同pragma table_info
	name type notnull dflt_value pk
	名称 类型 是否为空 默认值(default_value)  是否主键(primary key)

--]]


local LuaDBInterface = 
{ 
	init = false,
	sql_count = 0,
}

-- SqlManager；有C#版和C版本
-- 如果C有的话，优先返回CModule
local SQLManager = CS.LuaDatabaseManager

function LuaDBInterface.Init(callback)
	print("[DB]LuaDBInterface.Init")
	
	local cb = function (b)
		LuaDBInterface.init = b
		if b == false then
			print("[DB]database error!!!")
			--self:__Callback("error", "database_error")
			--return
		end

		if callback then
			callback(b)
		end
	end
	
	-- 如果有C模块的话，使用C模块的sqlite
	if LuaEntry.Sqlite and LuaEntry.Async then
		SQLManager = LuaEntry.Sqlite
	end
	
	-- 如果数据库已经初始化完毕，就不去重复打开了
	if LuaDBInterface.init == true then
		cb(true)
	else
		SQLManager.InitDataBase("config.db", cb)
	end
	
	return
end

function LuaDBInterface.Uninit()
	print("[DB]LuaDBInterface.Uninit")
	LuaDBInterface.init = false
	SQLManager.UninitDatabase()
	print("[DB]LuaDBInterface.Uninit end")
end

function LuaDBInterface.ExecuteSQL(sql, callback)
	LuaDBInterface.sql_count = LuaDBInterface.sql_count + 1
	
	SQLManager.ExecuteSQL(sql, 
		function (r)
			if r.error ~= 0 then
				local error = r.error or 0
				local errormsg = r.errormsg or ""
				print("[SQL] error: " .. error .. ", msg: " .. errormsg)
			end
			
			if callback then
				callback(r)
			end
		end)
	return
end

function LuaDBInterface.ExecuteSTMT(sqlstmt, values, format, callback)
	LuaDBInterface.sql_count = LuaDBInterface.sql_count + 1

	SQLManager.ExecuteSTMT(sqlstmt,
		values, 
		format,
		function (r)
			if r.error ~= 0 then
				local error = r.error or 0
				local errormsg = r.errormsg or ""
				print("[SQL] error: " .. error .. ", msg: " .. errormsg)
			end

			if callback then
				callback(r)
			end
		end)
	return
end

function LuaDBInterface.ExecuteMultiSQL(sqlArr, callback)
	LuaDBInterface.sql_count = LuaDBInterface.sql_count + 1
	
	SQLManager.ExecuteMultiSQL(sqlArr, callback)
	return
end

-- 创建一个表
-- checkTableInfo: 目前程序中预期的表信息
-- 根据预期创建的表结构信息生成SQL语句
function LuaDBInterface.CreateOneTable(sqlTable, tableName, checkTableInfo)
	local createsql = "CREATE TABLE IF NOT EXISTS \"" .. tableName .. "\" ( "

	table.walk(checkTableInfo, function(k,v)
			local pk = ((v[5] == 1) and " primary key" or "")
			local notnull = ((v[3] == 1) and " not null" or "")
			createsql = createsql .. "\n" ..
			'"' .. v[1] .. '"' .. ' ' .. v[2] .. pk .. notnull .. ","
		end)
	createsql = string.sub(createsql, 1, -2) -- 去除一个多余的,
	createsql = createsql .. " )"

	table.insert(sqlTable, createsql)
end

-- 根据信息返回修改的sql语句，sqlTable为in,out参数
-- tableInfo: 目前数据库的表信息，通过pragma table_info返回的
-- checkTableInfo: 目前程序中预期的表信息
function LuaDBInterface.MigrateOneTable(sqlTable, tableName, tableInfo, checkTableInfo)
	local alterInfo = {}

	for i=1,#checkTableInfo do
		local found = false
		for j=1,#tableInfo.values do
			if checkTableInfo[i][1] == tableInfo.values[j][2] then
				found = true
				break
			end
		end

		if (found == false) then
			table.insert(alterInfo, i)
		end
	end

	-- 有需要修改的列
	for j=1,#alterInfo do
		local pos = alterInfo[j]
		local alterSQL = "ALTER TABLE " .. tableName .. " ADD COLUMN "
		.. checkTableInfo[pos][1] .. " " .. checkTableInfo[pos][2]
		table.insert(sqlTable, alterSQL)
	end
end


-- 将单行数据库数据解析成Lua table
-- 通常就是select .. limit 1某个表之后返回的结果
-- 处理很简单，就是直接按照t[col_name] = col_value形式
function LuaDBInterface.ParseResultToLuaTable(result)
	-- 数据不存在或者查询出错了
	if result == nil or result.error ~= 0 or #result.values <= 0 then
		return nil
	end

	if #result.values > 1 then
		print("multi rows??")
	end

	-- cols列名, values是数值（注意是一个Array，所以我们只取第一行即可）
	local tbl = {}
	for i=1,result.col_count do
		local k = result.cols[i].name
		local v = result.values[1][i]
		tbl[k] = v
	end

	return tbl
end

-- 将多行数据库数据解析成Lua tables
-- 通常就是select某个表之后返回的结果，结果是一个LUA table array
function LuaDBInterface.ParseResultToMultiLuaTables(result)
	local tbl = {}
	-- 数据不存在或者查询出错了
	if result == nil or result.error ~= 0 or result.cols == nil then
		return tbl
	end

	if result.values == nil or #result.values <= 0 then
		return tbl
	end

	-- cols列名, values是数值
	local col_count = result.col_count
	local cols = result.cols

	for rowidx=1,#result.values do
		local row = {}
		for i=1,col_count do
			local k = cols[i].name
			local v = result.values[rowidx][i]
			row[k] = v
		end
		table.insert(tbl, row)
	end

	return tbl
end

-- 目前暂时如此，以后DB这块要修改一下
function LuaDBInterface.escape(keyWord)
	keyWord = string.gsub(keyWord, "'", "''")
	return keyWord
end

return LuaDBInterface

