--[[
-- added by wsh @ 2017-12-18
-- string扩展工具类，对string不支持的功能执行扩展
--]]

local unpack = unpack or table.unpack

-- 字符串分割
-- @split_string：被分割的字符串
-- @pattern：分隔符，可以为模式匹配
-- @init：起始位置
-- @plain：为true禁用pattern模式匹配；为false则开启模式匹配
local function split(split_string, pattern, search_pos_begin, plain)
	search_pos_begin = search_pos_begin or 1
	plain = plain or true
	local split_result = {}
	assert(type(split_string) == "string")
	assert(type(pattern) == "string" and #pattern > 0)
	pattern = pattern or ","
	if type(split_string) ~= "string" then
		return split_result
	end	

	while true do
		local find_pos_begin, find_pos_end = string.find(split_string, pattern, search_pos_begin, plain)
		if not find_pos_begin then
			break
		end
		local cur_str = ""
		if find_pos_begin > search_pos_begin then
			cur_str = string.sub(split_string, search_pos_begin, find_pos_begin - 1)
		end
		split_result[#split_result + 1] = cur_str
		search_pos_begin = find_pos_end + 1
	end

	if search_pos_begin <= string.len(split_string) then
		split_result[#split_result + 1] = string.sub(split_string, search_pos_begin)
	else
		split_result[#split_result + 1] = ""
	end

	return split_result
end

-- 字符串连接
function join(join_table, joiner)
	return table.concat(join_table, joiner)
end

-- 是否包含
-- 注意：plain为true时，关闭模式匹配机制，此时函数仅做直接的 “查找子串”的操作
function contains(target_string, pattern, plain)
	plain = plain or true
	local find_pos_begin, find_pos_end = string.find(target_string, pattern, 1, plain)
	return find_pos_begin ~= nil
end

-- 以某个字符串开始
function startswith(target_string, str)
	local find_pos_begin, find_pos_end = string.find(target_string, str, 1, true)
	return find_pos_begin == 1
end

-- 以某个字符串结尾
function endswith(target_string, str)
	local find_pos_begin, find_pos_end = string.find(target_string, str, -#str, true)
	return find_pos_end == #target_string
end
--数字以K,M，G表示
local function GetFormattedStr(value)
	local unit = ""
	if value<0 then
		value = -value
		unit = "-"
	end
	
	local num = math.floor(value / 100000000)
	if num >= 10 then
		num = num / 10
		local a, b = math.modf(num)
		if b == 0 then
			return string.format("%s%dG", unit, a)
		end
		return string.format("%s%.1fG", unit, num)
	end

	num = math.floor(value / 100000)
	if num >= 10 then
		num = num / 10
		local a, b = math.modf(num)
		if b == 0 then
			return string.format("%s%dM", unit, a)
		end
		return string.format("%s%.1fM", unit, num)
	end

	num = math.floor(value / 100)
	if num >= 10 then
		num = num / 10
		local a, b = math.modf(num)
		if b == 0 then
			return string.format("%s%dK", unit, a)
		end
		return string.format("%s%.1fK", unit, num)
	end
	
	return string.format("%s%d", unit, math.floor(value))
end

--千位分隔符
local function GetFormattedSeperatorNum(n)
	local left, num, right = string.match(n, '^([^%d]*%d)(%d*)(.-)$')
	return left .. (num:reverse():gsub('(%d%d%d)', '%1,'):reverse()) .. right
end

local function GetFormattedSpecial(value)
	if value>= 1000000 then
		return string.GetFormattedStr(value)
	else
		return string.GetFormattedSeperatorNum(math.floor(value))
	end
end

local function GetFormattedGoldNum(value)
	if value>= 100000 then
		return string.GetFormattedStr(value)
	else
		return string.GetFormattedSeperatorNum(math.floor(value))
	end
end

local function GetFormattedOfflineNum(value)
	if value >= 10000 then
		return string.GetFormattedStr(value)
	else
		return string.GetFormattedSeperatorNum(math.floor(value))
	end
end

--浮点数
local function GetFloatStr(value)
	if value ==0 then
		return "0"
	end
	return string.format("%.1f",value)
end

--百分比
local function GetFormattedPercentStr(value)
	value = value *100
	return string.format("%.1f%%",value)
end
--百分比--小数点后两位
local function GetFormattedPercentStrSpecial(value)
	value = value *100
	return string.format("%.2f%%",value)
end
--百分比
local function GetFormattedThousandthStr(value)
	value = value *1000
	return string.format("%.1f%‰",value)
end

local function IsNullOrEmpty(str)
	if str == nil or str == "" then
		return true
	end
	return false
end

function string.findlast(s, pattern, plain)
	local curr = 0
	repeat
		local next = s:find(pattern, curr + 1, plain)
		if (next) then curr = next end
	until (not next)
	if (curr > 0) then
		return curr
	end
end


local function trim(s)
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end


function string.IsNullOrEmpty(value)
	if (value == nil or value == "") then
		return true
	end
	return false
end

-- string[i]
local function at(str, pos)
	return string.sub(str, pos, pos)
end

-- 计算字符串的字符个数
-- https://blog.csdn.net/fightsyj/article/details/83589997
local function word_count(input)
	local len  = string.len(input)
	local left = len
	local cnt  = 0
	local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
	while left ~= 0 do
		local tmp = string.byte(input, -left)
		local i   = #arr
		while arr[i] do
			if tmp >= arr[i] then
				left = left - i
				break
			end
			i = i - 1
		end
		cnt = cnt + 1
	end
	return cnt
end

-- string解析成table
-- a=b;c=d
-- 解析成<int, int>
local function string2table_ii(str, sep1, sep2)
	sep1 = sep1 or ";"
	sep2 = sep2 or "="

	local t = {}
	
	local ts = string.split(str, sep2)
	for _, v in ipairs(ts) do
		local ts2 = string.split(v, sep1)
		if ts2 and #ts2 == 2 then
			local k = math.tointeger(ts2[1])
			local v = math.tointeger(ts2[2])
			if k and v then
				t[k] = v
			end
		end
	end

	return t
end

local function string2table_ss(str, sep1, sep2)
	sep1 = sep1 or ";"
	sep2 = sep2 or "="

	local t = {}

	local ts = string.split(str, sep2)
	for _, v in ipairs(ts) do
		local ts2 = string.split(v, sep1)
		if ts2 and #ts2 == 2 then
			local k = tostring(ts2[1])
			local v = tostring(ts2[2])
			if k and v then
				t[k] = v
			end
		end
	end

	-- 以下代码也可以实现类似功能，但是不太严谨
	--t = {}
	--s = "from=world, to=Lua"
	--for k, v in string.gmatch(s, "(%w+)=(%w+)") do
		--t[k] = v
	--end
	
	return t
end

local function string2table_si(str, sep1, sep2)
	sep1 = sep1 or ";"
	sep2 = sep2 or "="

	local t = {}

	local ts = string.split(str, sep2)
	for _, v in ipairs(ts) do
		local ts2 = string.split(v, sep1)
		if ts2 and #ts2 == 2 then
			local k = tostring(ts2[1])
			local v = math.tointeger(ts2[2])
			if k and v then
				t[k] = v
			end
		end
	end

	return t
end

local function string2table_is(str, sep1, sep2)
	sep1 = sep1 or ";"
	sep2 = sep2 or "="

	local t = {}

	local ts = string.split(str, sep2)
	for _, v in ipairs(ts) do
		local ts2 = string.split(v, sep1)
		if ts2 and #ts2 == 2 then
			local k = math.tointeger(ts2[1])
			local v = tostring(ts2[2])
			if k and v then
				t[k] = v
			end
		end
	end

	return t
end

local function string2table_sf(str, sep1, sep2)
	sep1 = sep1 or ";"
	sep2 = sep2 or "="

	local t = {}

	local ts = string.split(str, sep2)
	for _, v in ipairs(ts) do
		local ts2 = string.split(v, sep1)
		if ts2 and #ts2 == 2 then
			local k = tostring(ts2[1])
			local v = tonumber(ts2[2])
			if k and v then
				t[k] = v
			end
		end
	end

	return t
end

-- 字符串变成array
-- 譬如"1,2,3,4,5" => {1,2,3,4,5}
local function string2array_i(str, sep1, sep2)
	sep1 = sep1 or ","
	sep2 = sep2 or "|"

	local t = {}

	local ts = string.split(str, sep2)
	for _, v in ipairs(ts) do
		local t2 = {}
		local ts2 = string.split(v, sep1)
		if ts2 then
			for _,v in ipairs(ts2) do
				table.insert(t2, toInt(v))
			end
		end
		table.insert(t, t2)
	end

	return t
end

local function string2array_s(str, sep1, sep2)
	sep1 = sep1 or ","
	sep2 = sep2 or "|"

	local t = {}

	local ts = string.split(str, sep2)
	for _, v in ipairs(ts) do
		local ts2 = string.split(v, sep1)
		table.insert(t, ts2 or {})
	end

	return t
end


-- 字符串中的部分变成字符串
-- 这里的beg_pos，end_pos就是指具体位置
local function SliceToInt(str, beg_pos, end_pos)
	local sign = 1
	local Base = 0
	local i = beg_pos	
	end_pos = end_pos or string.len(str)

	local t = str:at(i)
	while (t == ' ') do
		i = i + 1
		t = str:at(i)
	end

	-- sign of number
	--t = str:at(i)
	if (t == '-' or t == '+') then
		sign = 1 - 2 * (t == '-' and 1 or 0)
		i = i + 1
	end

	-- checking for valid input
	-- lua 从1开始下标，所以这里<=Length
	t = str:at(i)
	while (i <= end_pos and t ~= nil and t >= '0' and t <= '9') do
		-- handling overflow test case
		if (Base > math.maxinteger / 10 or (Base == math.maxinteger / 10 and t - '0' > 7)) then
			if (sign == 1) then
				return math.maxinteger
			else
				return math.mininteger
			end
		end
		
		Base = 10 * Base + (t - '0')
		i = i + 1
		t = str:at(i)	
	end

	return Base * sign
end

-- 字符串分割成两个int
-- “？：
local function string2_ii(str, sep)
	local pos = string.find(str, sep)
	if pos == nil then
		return toInt(str), 0
	end

	local a = SliceToInt(str, 1, pos - 1)
	local b = SliceToInt(str, pos + 1)
	
	return a, b
end

local function _split_ss(str, sep)
	return string.split_ss(str, sep)
end

local function _split_ss_array(str, sep)
	return string.split_ss_array(str, sep)
end

local function GetBytes(char)
	if not char then
		return 0
	end
	local code = string.byte(char)
	if code < 127 then
		return 1
	elseif code <= 223 then
		return 2
	elseif code <= 239 then
		return 3
	elseif code <= 247 then
		return 4
	else
		return 0
	end
end

local function SubStr(str, startIndex, endIndex)
	local tempStr = str
	local byteStart = 1 -- string.sub截取的开始位置
	local byteEnd = -1 -- string.sub截取的结束位置
	local index = 0  -- 字符记数
	local bytes = 0  -- 字符的字节记数

	startIndex = math.max(startIndex, 1)
	endIndex = endIndex or -1
	while string.len(tempStr) > 0 do
		if index == startIndex - 1 then
			byteStart = bytes+1
		elseif index == endIndex then
			byteEnd = bytes
			break
		end
		bytes = bytes + GetBytes(tempStr)
		tempStr = string.sub(str, bytes+1)

		index = index + 1
	end
	return string.sub(str, byteStart, byteEnd)
end

local function SubStrByNum(str,length)
	local tempStr = str
	local arr = {}
	if #str>length then
		local count = 0
		while #tempStr>0 and count<100 do
			local a = string.sub(tempStr,1,length)
			local b = ""
			if #tempStr>=length+1 then
				b = string.sub(tempStr,length+1,#tempStr)
			end
			table.insert(arr,a)
			tempStr = b
			count = count+1
		end
	else
		table.insert(arr,tempStr)
	end
	return arr
end

--2位百分号显示
local function GetReasonPercent(num)
	local effectValueX, effectValueY = math.modf(num)
	if effectValueY < ModfRange then
		return effectValueX .. "%"
	else
		effectValueX, effectValueY = math.modf(num * 10)
		if effectValueY < ModfRange then
			return string.format("%.1f%%", num)
		else
			return string.format("%.2f%%", num)
		end
	end
end

local NUMBERIC_UNIT =
{
	[1] = "",
	[2] = "K",
	[3] = "M",
	[4] = "B",
	-- [5] = "t",
	-- [6] = "q",
	-- [7] = "Q",
	-- [8] = "s",
	-- [9] = "S",
}

-- 取换算为大数词头的数量字符串 
local floor = math.floor;
local function numbericFormationWithPrefix(value, digits, sep)
	digits = digits or 5
	digits = math.max(digits, 1)

	local sign = ""
	if value < 0 then
		value = -value
		sign = "-"
	end
	value = floor(value);

	local judge = 1
	for i = 1, digits do
		judge = judge * 10
	end

	local unitIdx = 1;
	local remainder = 0;
	while value >= judge and value >= 1000 and unitIdx < #NUMBERIC_UNIT do
		remainder = value % 1000;
		value = floor(value / 1000);
		unitIdx = unitIdx + 1;
	end

	local str = tostring(value)
	local fillDigits = digits - string.len(str)
	if sep then
		local count = floor((string.len(str) - 1) / 3)
		for i = 1, count do
			local index = string.len(str) - i * 3 + 1 - (i - 1)
			str = string.insert(str, index, sep)
		end
	end
	if fillDigits > 0 and unitIdx > 1 then
		str = str..'.'
		str = str .. string.sub(string.format("%03d", remainder), 1, fillDigits)
	end
	return sign .. str .. NUMBERIC_UNIT[unitIdx]
end

local function insert(str,index,insertStr, flag)
	if flag and string.find(str, flag) ~=nil then
		index = index + #flag
	end
	local pre = string.sub(str, 1, index -1)
	local tail = string.sub(str, index, -1)
	local createStr = string.format("%s%s%s", pre, insertStr, tail)
	return createStr
end

string._split_ss_array = _split_ss_array
string._split_ss = _split_ss
string.split = split
string.join = join
string.contains = contains
string.startswith = startswith
string.endswith = endswith
string.GetFormattedStr = GetFormattedStr
string.GetFormattedSeperatorNum = GetFormattedSeperatorNum
string.GetFloatStr = GetFloatStr
string.GetFormattedGoldNum = GetFormattedGoldNum
string.GetFormattedPercentStr = GetFormattedPercentStr
string.GetFormattedPercentStrSpecial = GetFormattedPercentStrSpecial
string.IsNullOrEmpty = IsNullOrEmpty
string.at = at
string.trim = trim
string.word_count = word_count
string.GetFormattedThousandthStr = GetFormattedThousandthStr
string.string2table_ii = string2table_ii
string.string2table_ss = string2table_ss
string.string2table_si = string2table_si
string.string2table_is = string2table_is
string.string2table_sf = string2table_sf
string.string2array_i = string2array_i
string.string2array_s = string2array_s
string.SliceToInt = SliceToInt
string.string2_ii = string2_ii
string.GetFormattedSpecial = GetFormattedSpecial
string.GetBytes = GetBytes
string.SubStr = SubStr
string.SubStrByNum = SubStrByNum
string.GetFormattedOfflineNum = GetFormattedOfflineNum
string.GetReasonPercent = GetReasonPercent
string.numbericFormationWithPrefix = numbericFormationWithPrefix
string.insert = insert