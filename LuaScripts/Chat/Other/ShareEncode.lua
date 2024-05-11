--[[
	ShareEncode
	主要用来做AttachmentId的编码，因为AttachmentId拼起来太长，
	所以，这里使用ShareDecode来处理
	
	最后对应消息ChatEventId.CHAT_SHARE_COMMAND，参数是一个table
	不同的分享，table不同，详细可以看这个文件各个类型的注释
	
	主要用来处理分享消息
	1。分享消息是把相关的数据打包成一个字符串(目前就是json)然后传给服务器
	然后再根据字符串进行解析；
	2。如果是声音或者图片的话，就把数据上传到CDN服务器
	然后把拉取的uri发出去
	3。从理论上来讲，外界不需要关心如何打包这个字符串
	外界应该穿一个数据相关的table，然后由这个类提供一个打包函数
	解包也一样，由这个类处理，然后返回用户相关的table。
	调用方和聊天维护人员约定好table中的具体数据即可
]]

local rapidjson = require "rapidjson"
local ShareEncode = {}

--[[
	世界坐标分享:
	post = PostType.Text_PointShare
	roomId = 要分享的房间id
	
	param说明：
	[.t] = 标题dialog
	[.sid] = 服务器id
	.x = 坐标X
	.y = 坐标Y
	
	## 如果是分享譬如空地，怪物，矿等固有物件
	.oname = 建筑物或者怪物的dialog
	[.olv] = 建筑物等级（如果没有的话，传0或者不设置）
	## 如果是分享角色主城的话
	.uname = 如果是分享玩家坐标的话，需要传
	[.abbr] = 联盟简称
	## 如果是分享特殊msg的话
	.msg = 分享的字符串（如果就是要分享的时候发一个字符串，优先显示）
]]

local function Encode_PointShare(tbl)

	-- 防止传多余的项，这里做一次过滤处理
	if tbl.x == nil or tbl.y == nil then
		return nil
	end

	local t = {}
	if not string.IsNullOrEmpty(tbl.sid) then
		t.sid = tbl.sid
	end
	if not string.IsNullOrEmpty(tbl.worldId) then
		t.worldId = tbl.worldId
	end
	t.x = tbl.x
	t.y = tbl.y
	if not string.IsNullOrEmpty(tbl.msg) then
		t.msg = tbl.msg
	else
		if not string.IsNullOrEmpty(tbl.uname) then
			t.uname = tbl.uname
			t.abbr = tbl.abbr
		end
		if not string.IsNullOrEmpty(tbl.oname) then
			t.oname = tbl.oname
			t.olv = tbl.olv
		end
	end
	return t
end



local function Encode_AllianceTaskShare(tbl)
	local t = {}
	t.taskId = tbl.taskId
	t.taskName = tbl.taskName
	t.curProg = tbl.curProg
	t.maxProg = tbl.maxProg
	return t
end

local function Encode_AllianceRecruitShare(tbl)
	local t = {}
	t.uid = tbl.uid
	t.name = tbl.name
	t.abbr = tbl.abbr
	t.language = tbl.language
	t.recruitTip = tbl.recruitTip
	t.country = tbl.country
	t.memberNum = tbl.memberNum
	t.allianceFlag = tbl.allianceFlag
	t.needApply = tbl.needApply
	return t
end

local function Encode_MailScoutResultShare(tbl)
	local t = {}
	if not string.IsNullOrEmpty(tbl.sid) then
		t.sid = tbl.sid
	end
	if not string.IsNullOrEmpty(tbl.worldId) then
		t.worldId = tbl.worldId
	end
	if not string.IsNullOrEmpty(tbl.msg) then
		t.msg = tbl.msg
	end
	if not string.IsNullOrEmpty(tbl.msg) then
		t.uid = tbl.uid
	end
	if not string.IsNullOrEmpty(tbl.msg) then
		t.mailType = tbl.mailType
	end
	if not string.IsNullOrEmpty(tbl.msg) then
		t.toUser = tbl.toUser
	end
	return t
end


--[[
	联盟招募世界分享:
	post = PostType.Text_AllianceInvite
	roomId = 只能分享给世界
	
	param说明：
	.aid = 联盟id
	.abbr = 简称
	.name = 联盟名称
	[.icon] = 图标
	[.power] = 联盟战力
	[.c] = 当前人数
	[.mc] = 最大人数
	[.cond] = 加入条件
	[.t] = 忽悠的话
]]

local function Encode_AllianceInvite(tbl)

	-- 防止传多余的项，这里做一次过滤处理
	if tbl.aid == nil then
		return nil
	end

	local t = {}
	t.aid = tbl.aid
	t.abbr = tbl.abbr
	t.name = tbl.name
	t.power = tbl.power
	t.c = tbl.c
	t.mc = tbl.mc
	t.icon = (not string.IsNullOrEmpty(tbl.icon)) and tbl.icon or nil
	t.cond = tbl.cond
	t.t = tbl.t

	return t
end


--[[
	联盟职级调整:
	post = PostType.Text_AllianceRankChange
	roomId = 只在联盟频道显示一下
	
	param说明：
	.uid = 用户id
	.uname = 用户名称
	.old = 旧等级
	.new = 新等级
]]

local function Encode_AllianceRankChange(tbl)

	if tbl.uid == nil then
		return nil
	end

	local t = {}
	t.uid = tbl.uid
	t.uname = tbl.uname
	t.old = tbl.old
	t.new = tbl.new
	t.selfName = tbl.selfName
	t.selfRank = tbl.selfRank
	
	return t
end

local function Encode_AllianceMemberChange(tb)
	if tb.name == nil then
		return nil
	end
	
	local t = {}
	t.name = tb.name
	
	return t
end

--[[
	联盟官员调整:
	post = PostType.Text_AllianceOfficialChange
	roomId = 只在联盟频道显示一下
	
	param说明：
	.uid = 用户id
	.uname = 用户名称
	.new = 新官职名称（只显示：xxx被任命成xxx）
]]

local function Encode_AllianceOfficialChange(tbl)
	
	if tbl.uid == nil then
		return nil
	end

	local t = {}
	t.uid = tbl.uid
	t.uname = tbl.uname
	t.new = tbl.new

	return t
end


-- 分享战报
local function Encode_ShareFightReport(tb)
	if tb.name == nil then
		return nil
	end

	local t = {}
	--t.msg = tb.msg
	--t.name = tb.name
	t.para = tb.para

	return t
end

-- 分享战报（全部信息）
local function Encode_ShareFightReportContent(tb)
	local t = {}
	t.mailType = tb.mailType
	t.reportContent = tb.reportContent
	t.createTime = tb.createTime
	return t
end

-- 分享侦查战报（全部信息）
local function Encode_ShareScoutReportContent(tb)
	local t = {}
	t.mailType = tb.mailType
	t.reportContent = tb.reportContent
	t.createTime = tb.createTime
	return t
end

-- 分享被侦查战报（全部信息）
local function Encode_ShareScoutAlertContent(tb)
	local t = {}
	t.mailType = tb.mailType
	t.content = tb.content
	t.createTime = tb.createTime
	return t
end

-- 分享编队
local function Encode_SharePlayerFormation(tb)
	if tb.name == nil then
		return nil
	end

	local t = {}
	t.para = tb.para

	return t
end

local function Encode_Text_ChampionBattle_Report_Share(tb)
	if tb.name == nil then
		return nil
	end

	local t = {}
	t.para = tb.para

	return t
end

local function Encode_AllianceRedPacket(tb)
	if tb.name == nil then
		return nil
	end

	local t = {}
	t.para = tb.para

	return t
end
--[[
	文字分享:
	post = PostType.Text_MsgShare
	roomId = 频道Id
	
	param说明：
	.dialogId = 多语言id
	.dialogParamNum = 在多语言中配位符数量，如:{0},{1},{2}--->num =3
	.unUseDialogParamList ={"","",""}，填写不需要参与多语言解析的配位符内容，如：钻石个数，玩家名字。
	.useDialogParamList ={"","",""}，填写不需要参与多语言解析的配位符内容，填写多语言id
	注：上述两个list长度需要与dialogParamNum相等，空位置用""填充
]]
local function Encode_Text_MsgShare(tb)
	local t = {}
	t = tb
	return t
end

-- 分享编码相关的表格
local EncodeTable = 
{
	[PostType.Text_PointShare] = Encode_PointShare,
	[PostType.Text_AllianceInvite] = Encode_AllianceInvite,
	[PostType.Text_AllianceRankChange] = Encode_AllianceRankChange,
	[PostType.Text_AllianceOfficialChange] = Encode_AllianceOfficialChange,
	[PostType.Text_MemberQuit] = Encode_AllianceMemberChange,
	[PostType.Text_MemberJoin] = Encode_AllianceMemberChange,
	[PostType.Text_AllianceTaskShare] = Encode_AllianceTaskShare,
	[PostType.Text_AllianceRecruitShare] = Encode_AllianceRecruitShare,
	[PostType.Text_Formation_Fight_Share] = Encode_ShareFightReport,
	[PostType.Text_BattleReportContentShare] = Encode_ShareFightReportContent,
	[PostType.Text_ScoutReportContentShare] = Encode_ShareScoutReportContent,
	[PostType.Text_ScoutAlertContentShare] = Encode_ShareScoutAlertContent,
	[PostType.Text_Formation_Share] = Encode_SharePlayerFormation,
	[PostType.RedPackge] = Encode_AllianceRedPacket,
	[PostType.Text_MailScoutResultShare] = Encode_MailScoutResultShare,
	[PostType.Text_MsgShare] = Encode_Text_MsgShare,
	[PostType.Text_ChampionBattleReportShare] = Encode_Text_ChampionBattle_Report_Share,
	[PostType.Text_ActMonsterTowerHelp] = Encode_Text_MsgShare,
}

-- 进行消息封装，最终封装成json格式
function ShareEncode.Encode(tbl)
	if tbl == nil then
		return nil
	end

	local t = nil
	local f = EncodeTable[tbl.post]
	
	-- 返回类型相关的参数表格
	if f then
		t = f(tbl.param)
	else
		ChatPrint("share encode not found! type : " .. tbl.post)
	end

	if t then
		return rapidjson.encode(t)
	end
	
	return nil
end




--function ChatMessage:getRandomWelcome()
	--local welcomes = { "138202", "138203", "138204" }
	--local index = math.random(3)
	--return welcomes[index]
--end


return ShareEncode


