--[[
	邮件管理器
	维护人员注意采集邮件的特殊性，所有采集邮件被合并成一封邮件
	然后这里做了一个虚拟的邮件，uid = "00000000-0000-xxxx-0000-000000000000"
	然后有一些地方特殊处理了一下这封虚拟邮件。

	注：本文所表示的mailId和uid是一个东西
]]

local MailDataManager = BaseClass("MailDataManager");
local MailDBManager = require "DataCenter.MailData.MailDBManager"
local MailGroup = require "DataCenter.MailData.MailGroup"
local MailInfo = require "DataCenter.MailData.MailInfo"
local Localization = CS.GameEntry.Localization
require "DataCenter.MailData.MailEnum"

-- 初始化邮件的几个组
function MailDataManager:__initGroup()
	local group = {}
	group[MailInternalGroup.MAIL_IN_system] = MailGroup.New(MailInternalGroup.MAIL_IN_system)
	group[MailInternalGroup.MAIL_IN_report] = MailGroup.New(MailInternalGroup.MAIL_IN_report)
	group[MailInternalGroup.MAIL_IN_alliance] = MailGroup.New(MailInternalGroup.MAIL_IN_alliance)
	group[MailInternalGroup.MAIL_IN_gather] = MailGroup.New(MailInternalGroup.MAIL_IN_gather)
	group[MailInternalGroup.MAIL_IN_monsterReward] = MailGroup.New(MailInternalGroup.MAIL_IN_monsterReward)
	group[MailInternalGroup.MAIL_IN_favor] = MailGroup.New(MailInternalGroup.MAIL_IN_favor)
	group[MailInternalGroup.MAIL_IN_scout] = MailGroup.New(MailInternalGroup.MAIL_IN_scout)
	group[MailInternalGroup.MAIL_IN_resSupportFrom] = MailGroup.New(MailInternalGroup.MAIL_IN_resSupportFrom)
	group[MailInternalGroup.MAIL_IN_resSupportTo] = MailGroup.New(MailInternalGroup.MAIL_IN_resSupportTo)
	group[MailInternalGroup.MAIL_IN_battle] = MailGroup.New(MailInternalGroup.MAIL_IN_battle)
	group[MailInternalGroup.MAIL_IN_blackKnight] = MailGroup.New(MailInternalGroup.MAIL_IN_blackKnight)
	group[MailInternalGroup.MAIL_IN_expeditionaryDuel] = MailGroup.New(MailInternalGroup.MAIL_IN_expeditionaryDuel)
	self.group = group
	-- 申请领取的奖励要存起来
	self.rewardReqList = {}
end

-- 通过邮件类型查找到分组
function MailDataManager:__mailTypeToGroup(mailData, saveFlag)

	-- 如果状态为1，就是收藏夹
	if saveFlag == 1 then
		return MailInternalGroup.MAIL_IN_favor
	end
	--战报只有野怪或者地块分类到打野中
	if mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.SHORT_KEEP_FIGHT_MAIL then
		local ext = mailData:GetMailExt()
		if ext ~= nil then
			if ext:IsExistBlackKnightBattle() then
				self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.BlackKnight)
				mailData:SetMailReport(MailIsReportType.BlackKnight)
				return MailInternalGroup.MAIL_IN_blackKnight
			elseif ext:IsExistExpeditionaryDuelBattle() then
				self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.ExpeditionaryDuel)
				mailData:SetMailReport(MailIsReportType.ExpeditionaryDuel)
				return MailInternalGroup.MAIL_IN_expeditionaryDuel
			elseif ext:IsOnlyMonsterBattle() or ext:IsOnlyDesertBattle() or ext:IsOnlyPveBattle() then
				self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.Report)
				mailData:SetMailReport(MailIsReportType.Report)
				return MailInternalGroup.MAIL_IN_report
			else
				self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.None)
			end
		end
	elseif mailData.type == MailType.MAIL_SCOUT_RESULT then
		if mailData:GetMailExt():IsPveScout() then
			self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.Report)
			mailData:SetMailReport(MailIsReportType.Report)
			return MailInternalGroup.MAIL_IN_report
		else
			self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.None)
		end
	elseif mailData.type == MailType.MAIL_SCOUT_ALERT then
		if mailData.isReport == nil then
			self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.None)
		end
	elseif mailData.type == MailType.MARCH_DESTROY_MAIL then
		if mailData:GetMailExt():GetIsPveBuild() then
			self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.Report)
			mailData:SetMailReport(MailIsReportType.Report)
			return MailInternalGroup.MAIL_IN_report
		else
			self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.None)
		end
	elseif mailData.type == MailType.ELITE_FIGHT_MAIL then
		self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.None)
	end
	local groupType = MailTypeToInternalGroup[mailData.type]
	if groupType == MailInternalGroup.MAIL_IN_report then
		self.DB:SetMailData_IsReport(mailData.uid, MailIsReportType.Report)
		mailData:SetMailReport(MailIsReportType.Report)
	end
	return groupType
end

function MailDataManager:__init()
	self.DB = MailDBManager.New()
	self.mailList = {}
	self.group = {}
end

function MailDataManager:__delete()
	self.mailList = nil
	self.isAll = nil
	self.allReward = nil
	self.message = nil
	self.rewardCount = nil
end

function MailDataManager:__reset()
	-- 保存所有邮件kv列表: uid, maildata
	self.mailList = {}
	self.doMailInit = false
	self.reqCount = 20
	self.lastUid = "0"	-- 邮件的最大uid
	self.lastTime = 0	-- 邮件的最大时间
	self.firstRequest = true	-- 是否是第一次请求，服务器会有一个缓存；理论上更应该做到服务器
	self.requestOver = false -- 注意默认是拉取完毕的（防止数据库或者什么出错进不去了）

	self.serverLastUid = "0"
	self.serverLastTime = 0

	self.isAll = false
	self.allReward = false
	self.rewardCount = 0
	self.message = {}
	self.scoutMail = {}--侦查邮件<玩家uid, dict<pointId, mailData>>
	-- 初始化组
	self:__initGroup()
	self.lastGroup = 1
end

function MailDataManager:Startup()

	self:__reset()

	-- 数据库初始化完毕之后，就去服务器拉取最新的邮件信息
	self.DB:Init(
			function (status, result)
				self.requestOver = false
				self:RequestMailListMessage()
			end)
end

function MailDataManager:Cleanup()
	self:__reset()
end

-- 邮件是否从服务器拉取完毕
-- 如果这个号换了设备的话，就要从服务器拉取很多邮件
-- 这个时间有时候会略长，这里加个标志，如果没拉取完，不让进邮件（文明觉醒）
function MailDataManager:IsMailRequestOver()
	return self.doMailInit
end

function MailDataManager:CreateMailData()
	return MailInfo.New()
end

-- 请求邮件数据列表
function MailDataManager:RequestMailListMessage()
	MailPrint("MailGetMuti"..self.lastUid..self.lastTime)
	SFSNetwork.SendMessage(MsgDefines.MailGetMuti,self.lastUid,self.lastTime,self.reqCount,self.firstRequest)
end

-- 返回邮件数据
function MailDataManager:OnGetMailListMessage(message)
	if message == nil then
		MailPrint("OnGetMailListMessage error")
		return
	end
	if self.group ==nil then
		return
	end
	MailPrint("OnGetMailListMessage")
	self.firstRequest = false

	-- 如果还有更多的话，继续取
	local isHasMore = false
	if message["more"] then
		isHasMore = message["more"]
		if isHasMore then
			self.RequestMailListMessage(self)
		else
			self.requestOver = true
		end
	else
		self.requestOver = true
	end

	-- 如果有服务器最后的邮件信息的话
	-- 暂时存起来；貌似没啥太大的意义？
	if message["lastUid"] then
		self.serverLastUid = message["lastUid"]
	end
	if message["lastMailTime"] then
		self.serverLastTime = message["lastMailTime"]
	end

	-------------------------------------
	-- 如果和请求的一样的话，表示客户端已经存在了；
	-- 服务器会把请求的uid重新发回来，也许是个机制，但大概率就是设计问题！
	-- 这里比较一下，如果是之前请求的直接忽略掉
	local lastUid = self.lastUid
	local lastTime = self.lastTime

	-- 从服务器拉过来的mail要保存起来
	local saveList = {}
	-- 解析具体的邮件列表信息
	local list = message.msg or {}

	-- 处理网络邮件
	for _,v in ipairs(list) do

		if lastUid == v.uid and	lastTime == v.createTime then
			goto continue
		end

		--local m = self:GetMailInfoById(v.uid)
		--if m == nil then
		--	m = self:CreateMailData()
		--	m:ParseBaseData(v)
		--	m.newMail = true -- 标记为新邮件
		--	self:AddMail(m)
		--else
		--	-- 一切以服务器的标准走
		--	local oldStatus = m.status
		--	m:ParseBaseData(v)
		--	if oldStatus ~= m.status then
		--		MailPrint("server status not sync~!!")
		--		m.status = oldStatus
		--	end
		--end

		local m = self:CreateMailData()
		m:ParseBaseData(v)
		self:__mailTypeToGroup(m, m.saveFlag)
		table.insert(saveList, m)
		::continue::
	end

	if not table.IsNullOrEmpty(saveList) then
		self.DB:InsertMailDatas(saveList,function (result)
			if result == true and isHasMore ==false then
				self:OnGetMailListFinish()
			end
		end)
	else
		if isHasMore==false then
			self:OnGetMailListFinish()
		end
	end
	--
	---- 每次网络邮件回来之后，要处理一下
	--self:__MakeVirtualMail(MailType.NEW_COLLECT_MAIL, MailInternalGroup.MAIL_IN_gather,MailInternalGroup.MAIL_IN_report)
	--self:__MakeVirtualMail(MailType.MONSTER_COLLECT_REWARD, MailInternalGroup.MAIL_IN_monsterReward,MailInternalGroup.MAIL_IN_report)
	--self:__MakeVirtualMail(MailType.NEW_FIGHT_BLACK_KNIGHT, MailInternalGroup.MAIL_IN_blackKnight,MailInternalGroup.MAIL_IN_report)
	--self:__MakeVirtualMail(MailType.NEW_FIGHT_EXPEDITIONARY_DUEL, MailInternalGroup.MAIL_IN_expeditionaryDuel, MailInternalGroup.MAIL_IN_report)
	--self:SaveMailAsOne(MailType.RESOURCE_HELP_FROM, MailInternalGroup.MAIL_IN_alliance)
	--self:SaveMailAsOne(MailType.RESOURCE_HELP_TO, MailInternalGroup.MAIL_IN_alliance)
	
	
end

function MailDataManager:OnGetPushMailListMessage(message)
	if message == nil then
		MailPrint("OnGetMailListMessage error")
		return
	end
	if self.group ==nil then
		return
	end
	MailPrint("OnGetMailListMessage")
	self.firstRequest = false

	-- 如果还有更多的话，继续取
	if message["more"] then
		local isHasMore = message["more"]
		if isHasMore then
			self.RequestMailListMessage(self)
		else
			self.requestOver = true
		end
	else
		self.requestOver = true
	end

	-- 如果有服务器最后的邮件信息的话
	-- 暂时存起来；貌似没啥太大的意义？
	if message["lastUid"] then
		self.serverLastUid = message["lastUid"]
	end
	if message["lastMailTime"] then
		self.serverLastTime = message["lastMailTime"]
	end

	-------------------------------------
	-- 如果和请求的一样的话，表示客户端已经存在了；
	-- 服务器会把请求的uid重新发回来，也许是个机制，但大概率就是设计问题！
	-- 这里比较一下，如果是之前请求的直接忽略掉
	local lastUid = self.lastUid
	local lastTime = self.lastTime

	-- 从服务器拉过来的mail要保存起来
	local saveList = {}
	-- 解析具体的邮件列表信息
	local list = message.msg or {}

	-- 处理网络邮件
	for _,v in ipairs(list) do

		if lastUid == v.uid and	lastTime == v.createTime then
			goto continue
		end

		local m = self:GetMailInfoById(v.uid)
		if m == nil then
			m = self:CreateMailData()
			m:ParseBaseData(v)
			m.newMail = true -- 标记为新邮件
			self:AddMail(m)
		else
			-- 一切以服务器的标准走
			local oldStatus = m.status
			m:ParseBaseData(v)
			if oldStatus ~= m.status then
				MailPrint("server status not sync~!!")
				m.status = oldStatus
			end
		end

		table.insert(saveList, m)
		::continue::
	end

	if not table.IsNullOrEmpty(saveList) then
		self.DB:InsertMailDatas(saveList)
	end

	-- 每次网络邮件回来之后，要处理一下
	self:__MakeVirtualMail(MailType.NEW_COLLECT_MAIL, MailInternalGroup.MAIL_IN_gather,MailInternalGroup.MAIL_IN_report)
	self:__MakeVirtualMail(MailType.MONSTER_COLLECT_REWARD, MailInternalGroup.MAIL_IN_monsterReward,MailInternalGroup.MAIL_IN_report)
	self:__MakeVirtualMail(MailType.NEW_FIGHT_BLACK_KNIGHT, MailInternalGroup.MAIL_IN_blackKnight,MailInternalGroup.MAIL_IN_report)
	self:__MakeVirtualMail(MailType.NEW_FIGHT_EXPEDITIONARY_DUEL, MailInternalGroup.MAIL_IN_expeditionaryDuel, MailInternalGroup.MAIL_IN_report)
	self:SaveMailAsOne(MailType.RESOURCE_HELP_FROM, MailInternalGroup.MAIL_IN_alliance)
	self:SaveMailAsOne(MailType.RESOURCE_HELP_TO, MailInternalGroup.MAIL_IN_alliance)
end
-- 添加一封邮件
-- 直接获取到邮件分组，然后扔到分组相关的列表中即可
function MailDataManager:AddMail(mailData, calcTotal)
	if self.mailList ==nil then
		return false
	end
	if table.IsNullOrEmpty(mailData) then
		MailPrint("mailData = nil !!")
		return false
	end

	-- 更新一下邮件最新的时间
	if not self.lastTime or mailData.createTime > self.lastTime then
		self.lastTime = mailData.createTime
		self.lastUid = mailData.uid
	end

	-- 如果邮件已经存在的话，就更新一下
	local v = self.mailList[mailData.uid]
	if v then
		v:ParseBaseData(mailData)
		return false
	end

	self.mailList[mailData.uid] = mailData

	local mailExt = mailData:GetMailExt()
	if (mailExt ~= nil) then
		-- 如果只是打怪的邮件,则默认已读
		if (((mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.SHORT_KEEP_FIGHT_MAIL) and mailExt:IsOnlyMonsterBattle() and mailExt:GetBattleWin() ) or
				(mailData.type == MailType.MAIL_PICK_GARBAGE)) then
			--self:ReadMail(mailData.uid)
		elseif mailData.type == MailType.MAIL_SCOUT_RESULT then
			-- 如果是侦察的邮件,存在scoutMail中
			self:AddOneScoutMailToDict(mailData)
		end
	end

	-- 然后把邮件放到相应的组里面
	local groupId = self:__mailTypeToGroup(mailData, mailData.saveFlag)

	if groupId~=nil then
		local group = self.group[groupId]
		if group then
			group:AddMail(mailData, calcTotal)
			return true
		end
	end
	return false
end

-- 是否有邮件
function MailDataManager:HasMail(uid)
	local mailData = self.mailList[uid]
	if mailData then
		return true
	end
	return false
end

-- 从数据库返回邮件数据
function MailDataManager:OnGetDBMails(mailDatas)
	for _, v in ipairs(mailDatas) do
		self:AddMail(v)
	end

	-- 每次report回来之后，要处理一下
	self:__MakeVirtualMail(MailType.NEW_COLLECT_MAIL, MailInternalGroup.MAIL_IN_gather,MailInternalGroup.MAIL_IN_report)
	self:__MakeVirtualMail(MailType.MONSTER_COLLECT_REWARD, MailInternalGroup.MAIL_IN_monsterReward,MailInternalGroup.MAIL_IN_report)
	self:__MakeVirtualMail(MailType.NEW_FIGHT_BLACK_KNIGHT, MailInternalGroup.MAIL_IN_blackKnight,MailInternalGroup.MAIL_IN_report)
	self:__MakeVirtualMail(MailType.NEW_FIGHT_EXPEDITIONARY_DUEL, MailInternalGroup.MAIL_IN_expeditionaryDuel, MailInternalGroup.MAIL_IN_report)
	self:SaveMailAsOne(MailType.RESOURCE_HELP_FROM, MailInternalGroup.MAIL_IN_alliance)
	self:SaveMailAsOne(MailType.RESOURCE_HELP_TO, MailInternalGroup.MAIL_IN_alliance)
end

function MailDataManager:OnGetMailListFinish()
	if self.doMailInit ==false then
		self.mailList = {}
		self:__initGroup()
		self.lastGroup = 1
		self.doMailInit = true
		self.DB.callback = nil
		self.DB:__MailDBInit()
	end
end

-- 从数据库返回的最新的uid及时间戳
function MailDataManager:OnDBLatestMailUid(t)
	self.lastUid = t.uid or "0"
	self.lastTime = t.createTime or 0
end

-- 从数据库返回的未读的数量
-- 如果是report，这里也需要特殊处理一下
function MailDataManager:OnDBGroupUnreadCount(list)
	MailPrint("OnDBGroupUnreadCount: " .. #list)
	for _, v in ipairs(list) do
		local group = self.group[v.groupId]
		if group then
			group:SetTotal(v.total)
			group:SetUnreadCount(v.unread)

		else
			MailPrint("OnDBGroupUnreadCount erorr, not found group : " .. v.groupId)
		end
	end
end

function MailDataManager:SetMailTranslated(uid, transMsg, transLang)
	local mailData = self:GetMailInfoById(uid)
	if mailData == nil then
		return
	end
	self.DB:UpdateMailData_Translate(mailData.uid, transMsg, transLang)
end

-- 把某封邮件设置为已读
function MailDataManager:ReadMail(uid)

	local mailData = self:GetMailInfoById(uid)
	if mailData == nil then
		MailPrint("mail not found: " .. uid)
		return
	end

	MailPrint("set Mail read! : " .. mailData.uid)


	---- 如果邮件已经已读了
	if mailData.status == 1 and mailData.type ~= MailType.NEW_COLLECT_MAIL then
		return
	end

	
	mailData.status = 1

	-- 这里兼容一下没有group的情形;就不直接return了
	local group = self.group[mailData.groupId]
	if group == nil then
		MailPrint("error! no group ~!")
	end

	-- 对于采集邮件，这里要特殊处理一下
	-- 采集是读取一封邮件，就全部读取了！
	if mailData.type == MailType.NEW_COLLECT_MAIL then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_gather)
	elseif mailData.type == MailType.MONSTER_COLLECT_REWARD then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_monsterReward)
	elseif mailData.type == MailType.RESOURCE_HELP_FROM or mailData.type == MailType.RESOURCE_HELP_TO then
		self:__ReadGroupMail(MailTypeToInternalGroup[mailData.type])
	elseif (mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.SHORT_KEEP_FIGHT_MAIL) and mailData:GetMailExt():IsExistBlackKnightBattle() then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_blackKnight)
	elseif (mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.SHORT_KEEP_FIGHT_MAIL)  and mailData:GetMailExt():IsExistExpeditionaryDuelBattle() then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_expeditionaryDuel)
	elseif mailData.type == MailType.NEW_FIGHT_BLACK_KNIGHT then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_blackKnight)
	elseif mailData.type == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_expeditionaryDuel)
	else
		-- 减少组内未读数量
		if group then
			group:SetUnreadCount(group:GetUnreadCount() - 1)
		end

		-- 同时保存到数据库和服务器
		self.DB:UpdateMailData_Read(mailData.uid)
		SFSNetwork.SendMessage(MsgDefines.MailReadStatus, mailData.uid, 1)
	end

	EventManager:GetInstance():Broadcast(EventId.MailPush)

end


-- 把分组邮件设置为已读；目前只有采集使用
function MailDataManager:__ReadGroupMail(groupId)

	-- 如果目前group是采集的话，需要特殊处理一下
	-- 这个处理略显另类，但是目前没想到更好的办法
	if groupId == MailInternalGroup.MAIL_IN_gather then
		local virMail = self:__GetVirtualMail(MailType.NEW_COLLECT_MAIL,MailInternalGroup.MAIL_IN_report)
		if virMail then
			virMail.status = 1
		end
	elseif groupId == MailInternalGroup.MAIL_IN_monsterReward then
		local virMail = self:__GetVirtualMail(MailType.MONSTER_COLLECT_REWARD,MailInternalGroup.MAIL_IN_report)
		if virMail then
			virMail.status = 1
		end
	elseif groupId == MailInternalGroup.MAIL_IN_resSupportFrom or groupId == MailInternalGroup.MAIL_IN_resSupportTo then
		local targetGroup = self.group[MailInternalGroup.MAIL_IN_alliance]
		if targetGroup~=nil then
			for k,v in ipairs(targetGroup) do
				if v.type == MailType.RESOURCE_HELP_FROM or v.type == MailType.RESOURCE_HELP_TO then
					v.status = 1
				end
			end
		end
	elseif groupId == MailInternalGroup.MAIL_IN_blackKnight then
		local virMail = self:__GetVirtualMail(MailType.NEW_FIGHT_BLACK_KNIGHT,MailInternalGroup.MAIL_IN_report)
		if virMail then
			virMail.status = 1
		end
		local targetGroup = self.group[groupId]
		if targetGroup ~= nil then
			for k,v in ipairs(targetGroup) do
				v.status = 1
			end
		end
	elseif groupId == MailInternalGroup.MAIL_IN_expeditionaryDuel then
		local virMail = self:__GetVirtualMail(MailType.NEW_FIGHT_EXPEDITIONARY_DUEL,MailInternalGroup.MAIL_IN_report)
		if virMail then
			virMail.status = 1
		end
		local targetGroup = self.group[groupId]
		if targetGroup ~= nil then
			for k,v in ipairs(targetGroup) do
				v.status = 1
			end
		end
	end

	local group = self.group[groupId]
	if group == nil then
		MailPrint("ReadGroupMail error :" .. groupId)
		return
	end

	-- 从数据库获取所有的uid，然后删除
	self.DB:GetAllUnreadMailUids(groupId,
			function (uids)

				-- 把此分类中所有未读的标记成已读
				for _, v in ipairs(group.mailList) do
					v.status = 1
				end
				group:SetUnreadCount(0)
				self.DB:UpdateMailData_ReadAll(groupId)

				-- 然后再把数据库返回的uid，统一发给服务器删除
				if #uids > 0 then
					SFSNetwork.SendMessage(MsgDefines.MailReadStatusBatch, uids, 1)
				end

			end)
end


-- 把分组邮件奖励都领取
function MailDataManager:__ClaimRewardGroupMail(groupId)

	local group = self.group[groupId]
	if group == nil then
		MailPrint("__ClaimRewardGroupMail error :" .. groupId)
		return
	end

	-- 从数据库获取所有的uid，然后删除
	self.DB:GetAllCanRewardMailUids(groupId,
			function (uids)
				-- 然后再把数据库返回的uid，统一发给服务器删除
				-- 如果没有的话，模拟一个；否则无法结束
				if #uids > 0 then
					table.insert(self.rewardReqList, uids)
					SFSNetwork.SendMessage(MsgDefines.MailRewardBatch, uids, 1)
				else
					table.insert(self.rewardReqList, "")
					DataCenter.MailDataManager:OnRewardMails()
				end
			end)
end


-- 删除一封邮件
function MailDataManager:DeleteMail(mailId)

	local mailData = self:GetMailInfoById(mailId)
	if mailData == nil then
		MailPrint("mail not found: " .. mailId)
		return
	end

	-- 如果邮件中有未领取的奖励的话，不让删除
	if mailData.rewardStatus == 0 then
		MailPrint("mail has reward, cannot delete: " .. mailId)
		return
	end

	-- 先从分组中删除
	local group = self.group[mailData.groupId]
	if group then
		group:RemoveMail(mailId)
	end

	self.mailList[mailId] = nil

	-- 如果是删除采集邮件的话
	if mailData.type == MailType.NEW_COLLECT_MAIL then
		self:DeleteGroupMail(MailInternalGroup.MAIL_IN_gather)
		return
	end
	if mailData.type == MailType.MONSTER_COLLECT_REWARD then
		self:DeleteGroupMail(MailInternalGroup.MAIL_IN_monsterReward)
		return
	end
	if mailData.type == MailType.NEW_FIGHT_BLACK_KNIGHT then
		self:DeleteGroupMail(MailInternalGroup.MAIL_IN_blackKnight)
		return
	end
	if mailData.type == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL then
		self:DeleteGroupMail(MailInternalGroup.MAIL_IN_expeditionaryDuel)
		return
	end

	--资源援助邮件
	if mailData.type == MailType.RESOURCE_HELP_FROM or mailData.type == MailType.RESOURCE_HELP_TO then
		self:DeleteGroupMail(MailTypeToInternalGroup[mailData.type])
	elseif mailData.type == MailType.MAIL_SCOUT_RESULT then
		self:RemoveOneScoutMailToDict(mailData)
	end

	-- 删除邮件要通知网络和数据库
	SFSNetwork.SendMessage(MsgDefines.MailDelete, mailId, 1)
	self.DB:RemoveMailData(mailId)
	EventManager:GetInstance():Broadcast(EventId.Mail_DeleteMailDone)

end

--[[
	删除某个组下所有邮件
	* 这里得特殊处理一下，删除战报的时候。如果有采集邮件同时把采集邮件删除了
	* 理论上这个应该做在中间层。但是为了方便，这里底层直接处理了吧

	策划规则：2、	“一键删除”按钮会删除此页签下所有已读和已领取邮件，
	带有红点或还有奖励未领取的邮件不会被删除
]]
function MailDataManager:DeleteGroupMail(groupId)

	local group = self.group[groupId]
	if group == nil then
		MailPrint("DeleteGroupMail error :" .. groupId)
		return
	end

	-- 删除report的时候同时删除采集即可
	if groupId == MailInternalGroup.MAIL_IN_report then
		self:__DeleteVirtualGroupMail(MailType.NEW_COLLECT_MAIL,MailInternalGroup.MAIL_IN_gather,MailInternalGroup.MAIL_IN_report)
		self:__DeleteVirtualGroupMail(MailType.MONSTER_COLLECT_REWARD,MailInternalGroup.MAIL_IN_monsterReward,MailInternalGroup.MAIL_IN_report)
		self:__DeleteVirtualGroupMail(MailType.NEW_FIGHT_BLACK_KNIGHT,MailInternalGroup.MAIL_IN_blackKnight,MailInternalGroup.MAIL_IN_report)
		self:__DeleteVirtualGroupMail(MailType.NEW_FIGHT_EXPEDITIONARY_DUEL,MailInternalGroup.MAIL_IN_expeditionaryDuel,MailInternalGroup.MAIL_IN_report)
	end

	-- 从数据库获取所有的uid，然后删除
	self.DB:GetAllCanDeleteMailUids(groupId,
			function (uids)
				
				self.DB:RemoveMailDatas(uids)

				for _, v in ipairs(group.mailList) do
					if v.type == MailType.NEW_COLLECT_MAIL or v.type == MailType.MONSTER_COLLECT_REWARD 
							or ((v.type == MailType.NEW_FIGHT or v.type == MailType.SHORT_KEEP_FIGHT_MAIL) and (v:GetMailExt():IsExistBlackKnightBattle() or v:GetMailExt():IsExistExpeditionaryDuelBattle())) then
						group:RemoveMail(v.uid)
						self.mailList[v.uid] = nil
					end
				end

				for _, v in ipairs(uids) do
					group:RemoveMail(v)
					self.mailList[v] = nil
				end

				-- 同时刷新列表和红点
				EventManager:GetInstance():Broadcast(EventId.Mail_DeleteBatchMailDone)
				EventManager:GetInstance():Broadcast(EventId.MailPush)

				------------------------------------------
				-- 然后再把数据库返回的uid，统一发给服务器删除
				if #uids > 0 then
					SFSNetwork.SendMessage(MsgDefines.MailBatchDel, uids, 1)
				end

			end)
end

--批量删除邮件
function MailDataManager:DeleteSelectMail(list)
	local deleteList = {}
	for i = 1 ,table.count(list) do
		local mailData = self:GetMailInfoById(list[i])
		if mailData ~= nil then
			-- 如果邮件中有未领取的奖励的话，不让删除
			if mailData.rewardStatus == 1 and mailData.status == 1 then
				-- 先从分组中删除
				local group = self.group[mailData.groupId]
				if group then
					group:RemoveMail(list[i])
				end
				self.mailList[list[i]] = nil
				local isInsert = true
				-- 如果是删除采集邮件的话
				if mailData.type == MailType.NEW_COLLECT_MAIL then
					isInsert = false
					self:DeleteGroupMail(MailInternalGroup.MAIL_IN_gather)
				end
				if mailData.type == MailType.MONSTER_COLLECT_REWARD then
					isInsert = false
					self:DeleteGroupMail(MailInternalGroup.MAIL_IN_monsterReward)
				end
				if mailData.type == MailType.NEW_FIGHT_BLACK_KNIGHT then
					isInsert = false
					self:DeleteGroupMail(MailInternalGroup.MAIL_IN_blackKnight)
				end
				if mailData.type == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL then
					isInsert = false
					self:DeleteGroupMail(MailInternalGroup.MAIL_IN_expeditionaryDuel)
				end
				if isInsert then
					table.insert(deleteList,list[i])
				end
				--资源援助邮件
				if mailData.type == MailType.RESOURCE_HELP_FROM or mailData.type == MailType.RESOURCE_HELP_TO then
					self:DeleteGroupMail(MailTypeToInternalGroup[mailData.type])
				elseif mailData.type == MailType.MAIL_SCOUT_RESULT then
					self:RemoveOneScoutMailToDict(mailData)
				end
			end
		end
	end
	self.DB:RemoveMailDatas(deleteList)
	if #deleteList == 0 or #deleteList ~= table.count(list) then
		UIUtil.ShowTipsId(312120)
	else
		UIUtil.ShowTipsId(310112)
	end
	------------------------------------------
	-- 然后再把数据库返回的uid，统一发给服务器删除
	if #deleteList > 0 then
		SFSNetwork.SendMessage(MsgDefines.MailBatchDel, deleteList, 1)
	end
end

-- 删除采集邮件组
function MailDataManager:__DeleteVirtualGroupMail(mailType,groupId,targetGroupId)
	local virMail = self:__GetVirtualMail(mailType,targetGroupId)
	if virMail then
		if virMail.status == 0 then
			return
		end
	else
		local group = self.group[groupId]
		if group and group:GetUnreadCount() > 0 then
			return
		end
	end

	-- 以上情况是采集有未读邮件，那么就不删除
	self:DeleteGroupMail(groupId)
end

--设置一键或单次领取状态
function MailDataManager:SetAllAndOne(state)
	self.isAll = state
end

function MailDataManager:SetAllReward(state)
	self.allReward = state
end

function MailDataManager:SetAllRewardCount(count)
	self.message = {}
	self.message.electricityAdd = 0
	self.message.waterAdd = 0
	self.message.pvePointAdd = 0
	self.message.goldAdd = 0
	self.message.moneyAdd = 0
	self.message.stoneAdd = 0
	self.message.detectEventAdd = 0
	self.message.formationStaminaAdd = 0
	self.rewardCount = count
end

-- 领取一封邮件的奖励
function MailDataManager:RewardMail(mailId)

	local mailData = self:GetMailInfoById(mailId)
	if mailData == nil then
		MailPrint("mail not found: " .. mailId)
		return
	end

	table.insert(self.rewardReqList, mailId)
	-- 领取奖励这个东西，必须要服务器返回确认之后再置灰
	-- 防止前端设置了领取标志之后但是服务器没有领取，导致卡死
	-- 这里统一使用batch处理
	SFSNetwork.SendMessage(MsgDefines.MailRewardBatch, mailId)

end

-- 一键已读及领取
function MailDataManager:ReadAndRewardGroupMail(groupId)

	local group = self.group[groupId]
	if group == nil then
		MailPrint("RewardGroupMail error :" .. groupId)
		return
	end

	-- 一键已读report的时候同时设置采集已读；采集没有奖励，所以也无所谓。
	if groupId == MailInternalGroup.MAIL_IN_report then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_gather)
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_monsterReward)
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_blackKnight)
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_expeditionaryDuel)
	elseif groupId == MailInternalGroup.MAIL_IN_alliance then
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_resSupportFrom)
		self:__ReadGroupMail(MailInternalGroup.MAIL_IN_resSupportTo)
	end

	-- 同时执行两种操作吧
	self:__ReadGroupMail(groupId)
	self:__ClaimRewardGroupMail(groupId)

end

function MailDataManager:RewardCheckMails(reward)
	self.rewardCount = self.rewardCount - 1
	if (reward["goods"] ~= nil) then
		local goods = reward["goods"]
		if not self.message.goods then
			self.message.goods = {}
		end
		for k = 1, #goods do
			table.insert(self.message.goods,goods[k])
		end
	end
	if (reward["electricity"] ~= nil) then
		self.message.electricity = reward["electricity"]
	end
	if (reward["electricityAdd"] ~= nil) then
		self.message.electricityAdd = self.message.electricityAdd + reward["electricityAdd"]
	end
	if (reward["water"] ~= nil) then
		self.message.water = reward["water"]
	end
	if (reward["waterAdd"] ~= nil) then
		self.message.waterAdd = self.message.waterAdd + reward["waterAdd"]
	end
	if (reward["gold"] ~= nil) then
		self.message.gold = reward["gold"]
	end
	if (reward["goldAdd"] ~= nil) then
		self.message.goldAdd = self.message.goldAdd + reward["goldAdd"]
	end
	if (reward["money"] ~= nil) then
		self.message.money = reward["money"]
	end
	if (reward["moneyAdd"] ~= nil) then
		self.message.moneyAdd = self.message.moneyAdd + reward["moneyAdd"]
	end
	if (reward["stone"] ~= nil) then
		self.message.stone = reward["stone"]
	end
	if (reward["stoneAdd"] ~= nil) then
		self.message.stoneAdd = self.message.stoneAdd + reward["stoneAdd"]
	end
	if (reward["pvePoint"] ~= nil) then
		self.message.pvePoint = reward["pvePoint"]
	end
	if (reward["pvePointAdd"] ~= nil) then
		self.message.pvePointAdd = self.message.pvePointAdd + reward["pvePointAdd"]
	end
	if (reward["getMoney"] ~= nil) then
		self.message.getMoney = reward["getMoney"]
	end
	if (reward["detectEvent"] ~= nil) then
		self.message.detectEvent = reward["detectEvent"]
	end
	if (reward["detectEventAdd"] ~= nil) then
		self.message.detectEventAdd = self.message.detectEventAdd + reward["detectEventAdd"]
	end
	if (reward["formationStamina"] ~= nil) then
		self.message.formationStamina = reward["formationStamina"]
	end
	if (reward["formationStaminaAdd"] ~= nil) then
		self.message.formationStaminaAdd = self.message.formationStaminaAdd + reward["formationStaminaAdd"]
	end
	if self.rewardCount == 0 then
		if self.message.gold~=nil then
			LuaEntry.Player.sm_addGoldCount = self.message.gold - self.message.goldAdd
		end
		DataCenter.RewardManager:ShowGiftReward(self.message,Localization:GetString("128027"))
	end
end

-- 领取奖励返回
function MailDataManager:OnRewardMails()
	if table.IsNullOrEmpty(self.rewardReqList) then
		MailPrint("OnRewardMails but no cache?? error~~!")
		return
	end

	-- 设置数据库已读的状态
	local t = self.rewardReqList[1]
	table.remove(self.rewardReqList, 1)
	if t == "" then
		--一键领取时刷新一次就可以
		local allReward  = DataCenter.MailDataManager.allReward
		if allReward then
			-- 同时刷新列表和红点
			EventManager:GetInstance():Broadcast(EventId.Mail_DeleteBatchMailDone)
			EventManager:GetInstance():Broadcast(EventId.MailPush)
			DataCenter.MailDataManager:SetAllReward(false)
		end
		return
	end

	-- 设置claim
	self.DB:UpdateMailData_Claim(t)
	if type(t) ~= "table" then
		t = {t}
	end

	-- 循环遍历所有t
	for _,v in ipairs(t) do
		local mailInfo = self.mailList[v]
		if mailInfo then
			mailInfo.rewardStatus = 1
		end
	end

	-- 同时刷新列表和红点
	EventManager:GetInstance():Broadcast(EventId.MailPush)
end


-- 获取虚拟的邮件
function MailDataManager:__GetVirtualMail(mailType,groupType)
	local groupReport = self.group[groupType]
	if groupReport == nil then
		return nil
	end

	local virMail = nil
	for k,v in ipairs(groupReport.mailList) do
		--if v.type == MailType.MAIL_GATHER_ITEM then
		if v.type == mailType then
			virMail = v
			break
		end
	end

	return virMail
end


-- 检测采集邮件是否要出现
-- 因为采集要合并，所以这里做一个虚假的采集邮件
-- 在每次数据库加载（因为拖动）或者网络消息发送过来之后；检测一次！
function MailDataManager:__MakeVirtualMail(mailType,groupId,targetGroupId)--邮件原本类型，原邮件组id，目标邮件组id
	local groupReport = self.group[targetGroupId]
	if groupReport == nil then
		return
	end

	-- 查找采集邮件，如果已经存在，则更新
	-- 主要有三种，1新来了战斗邮件，2采集邮件被清空了，3新来了采集邮件
	-- 情况1可以不用处理，理论上没啥影响；
	-- 处理情况2，3直接使用简单暴力方法，删除重新加。重走添加规则
	local fakeUuid = ""
	local oldVirMail = self:__GetVirtualMail(mailType,targetGroupId)
	if oldVirMail then
		oldVirMail.status = 1
		groupReport:RemoveMail(oldVirMail.uid)
		self.mailList[oldVirMail.uid] = nil
		fakeUuid = oldVirMail.uid
		oldVirMail = nil
	end

	local group = self.group[groupId]
	if group == nil or group:HasMail() == false then
		return
	end

	local gatherTime = group.mailList[1].createTime

	---- 取第一封邮件，如果在最后一封邮件之前，就显示出来
	--if (groupReport:HasMail() == true) and (groupReport:IsGetAll() == false) then
	--	local reportTime = groupReport.mailList[#groupReport.mailList].createTime
	--	if gatherTime < reportTime then
	--		return
	--	end
	--end

	if fakeUuid == "" then
		NameCount = NameCount + 1
		fakeUuid = "00000000-0000-" .. tostring(NameCount) .. "-0000-000000000000"
	end

	-- 生成一封虚拟邮件，放到列表中
	local virMail = self:CreateMailData()
	--virMail.type = MailType.MAIL_GATHER_ITEM
	virMail.type = mailType
	virMail.createTime = gatherTime
	virMail.uid = fakeUuid
	virMail.status = 1
	virMail.rewardStatus = 1

	self.mailList[virMail.uid] = virMail
	groupReport:AddMail(virMail)
	-- 添加完再设置这个值，记住！
	if group:GetUnreadCount() > 0 then
		virMail.status = 0
	else
		virMail.status = 1
	end

end

--合成一封
function MailDataManager:SaveMailAsOne(mailType, targetGroupType)
	local targetGroup = self.group[targetGroupType]
	if not targetGroup then
		return
	end

	local oldVirMail = nil
	for k,v in ipairs(targetGroup.mailList) do
		if v.type == mailType then
			oldVirMail = v
			break
		end
	end
	if oldVirMail then
		oldVirMail.status = 1
		targetGroup:RemoveMail(oldVirMail.uid)
		self.mailList[oldVirMail.uid] = nil
		oldVirMail = nil
	end
	local dataGroup = self.group[MailTypeToInternalGroup[mailType]]
	if not dataGroup or not dataGroup:HasMail() then
		return
	end

	local latestTime = dataGroup.mailList[1].createTime
	local virUid = "00000000-0000-" .. mailType .. "-0000-000000000000"

	local newVirMail = self:CreateMailData()
	newVirMail.type = mailType
	newVirMail.createTime = latestTime
	newVirMail.title = dataGroup.mailList[1].title
	newVirMail.uid = virUid
	newVirMail.status = 1
	newVirMail.rewardStatus = 1

	self.mailList[newVirMail.uid] = newVirMail
	targetGroup:AddMail(newVirMail)

	if dataGroup:GetUnreadCount() > 0 then
		newVirMail.status = 0
	else
		newVirMail.status = 1
	end
end

-- 获取相应类型
function MailDataManager:GetGroup(groupId)
	local group = self.group[groupId]
	return group
end

-- 获取相应类型的邮件
function MailDataManager:GetGroupMailList(groupId)
	local group = self.group[groupId]
	if group~=nil then
		return group.mailList
	else
		return {}
	end

end


function MailDataManager:GetMailInfoById(uid)
	if self.mailList~=nil then
		if uid~=nil and self.mailList[uid]~=nil then
			return self.mailList[uid]
		end
	end

	MailPrint("GetMailInfoById uid not found: " .. uid)
	return nil
end

-- 获取一共的红点数量
function MailDataManager:GetMailUnReadCountAll()
	local count = 0
	if self.group~=nil then
		for k,v in pairs(self.group) do
			local curCount = v:GetUnreadCount()
			if curCount > 0 and v ~= MailInternalGroup.MAIL_IN_favor then
				if k == MailInternalGroup.MAIL_IN_gather then
					count = count + 1
				else
					count = count + curCount
				end
			end
		end
	end


	return count
end

-- 返回指定频道类型邮件未读数
function MailDataManager:GetMailUnReadCountByGroup( groupId )
	if self.group[groupId] == nil then
		return 0
	end
	if (groupId == MailInternalGroup.MAIL_IN_report) then
		local battleCnt = self.group[MailInternalGroup.MAIL_IN_report]:GetUnreadCount()
		local gatherCnt = self.group[MailInternalGroup.MAIL_IN_gather]:GetUnreadCount() > 0 and 1 or 0
		local blackKnightCnt = self.group[MailInternalGroup.MAIL_IN_blackKnight]:GetUnreadCount() > 0 and 1 or 0
		local expeditionaryDuelCnt = self.group[MailInternalGroup.MAIL_IN_expeditionaryDuel]:GetUnreadCount() > 0 and 1 or 0
		local temp = self.group[MailInternalGroup.MAIL_IN_monsterReward]
		local monsterRewardCount = 0
		if temp~=nil then
			monsterRewardCount= temp:GetUnreadCount() > 0 and 1 or 0
		end
		return battleCnt + gatherCnt + monsterRewardCount + blackKnightCnt + expeditionaryDuelCnt
	elseif (groupId == MailInternalGroup.MAIL_IN_alliance) then
		local allianceCount = self.group[MailInternalGroup.MAIL_IN_alliance]:GetUnreadCount()
		local resSupportFrom = 0
		local resSupportTo = 0
		if self.group[MailInternalGroup.MAIL_IN_resSupportFrom]~=nil then
			resSupportFrom = self.group[MailInternalGroup.MAIL_IN_resSupportFrom]:GetUnreadCount() > 0 and 1 or 0
		end
		if self.group[MailInternalGroup.MAIL_IN_resSupportTo]~=nil then
			resSupportTo = self.group[MailInternalGroup.MAIL_IN_resSupportTo]:GetUnreadCount() > 0 and 1 or 0
		end
		return allianceCount + resSupportFrom + resSupportTo
	elseif (groupId == MailInternalGroup.MAIL_IN_battle) then
		--战报中剔除特殊邮件
		local battleCount = self.group[MailInternalGroup.MAIL_IN_battle]:GetUnreadCount()
		return battleCount
	else
		return self.group[groupId]:GetUnreadCount()
	end
end

-- 收藏邮件
-- 邮件添加收藏后，需要将邮件添加到收藏夹列表
function MailDataManager:SetFavor(uid)
	local mailData = self:GetMailInfoById(uid)
	if mailData == nil then
		return
	end

	-- 未领取邮件不能收藏
	if mailData:CanClaimReward() == true then
		MailPrint("set favor but has reward.")
		return
	end

	-- 采集邮件不能收藏
	if mailData.type == MailType.NEW_COLLECT_MAIL then
		MailPrint("set favor but collect mail.")
		return
	end

	if mailData.type == MailType.RESOURCE_HELP_FROM or mailData.type == MailType.RESOURCE_HELP_TO 
			or mailData.type == MailType.RESOURCE_HELP_FAIL or mailData.type == NEW_FIGHT_BLACK_KNIGHT or mailData.type == NEW_FIGHT_EXPEDITIONARY_DUEL then
		--同采集邮件，不能加入收藏
		return
	end

	if mailData.saveFlag == 1 then
		MailPrint("Already in favor, why?")
	else
		mailData.saveFlag = 1

		SFSNetwork.SendMessage(MsgDefines.MailAddFavor, uid, 1)
		self.DB:UpdateMailData_AddFavor(uid)

		self:__MailMoveGroup(uid, MailInternalGroup.MAIL_IN_favor)
		EventManager:GetInstance():Broadcast(EventId.Mail_DeleteMailDone)
	end
end

-- 取消收藏邮件
-- 邮件取消收藏后，需要将邮件从收藏夹列表移回到原始列表
function MailDataManager:CancelFavor(uid)
	local mailData = self:GetMailInfoById(uid)
	if mailData == nil then
		return
	end

	if mailData.saveFlag == 0 then
		MailPrint("Not in favor, why?")
	else
		mailData.saveFlag = 0

		SFSNetwork.SendMessage(MsgDefines.MailCancelFavor, uid, 1)
		self.DB:UpdateMailData_CancelFavor(uid)

		self:__MailMoveGroup(uid, __mailTypeToGroup(mailData))
	end
end

-- 邮件移动group
function MailDataManager:__MailMoveGroup(uid, toGroup)
	local mailData = self:GetMailInfoById(uid)
	if mailData == nil then
		return
	end


	local groupSrc = self.group[mailData.groupId]
	if groupSrc == nil then
		return
	end

	local groupDest = self.group[toGroup]
	if groupDest == nil then
		return
	end

	-- 先从源删除
	groupSrc:RemoveMail(mailData.uid)

	-- 然后根据情况看是否要插入到目标group中
	-- 取第一封邮件，如果在最后一封邮件之前，就显示出来
	local curTime = mailData.createTime
	local moveTime = 0

	-- 如果都取出来了，那么就直接追加到最后
	-- 否则要判断一下，如果在目前时间之内，插入；否则不做处理（等用户自己往上拖出来）
	if groupDest:IsGetAll() == false then
		if #groupDest.mailList > 0 then
			moveTime = groupDest.mailList[#groupDest.mailList].createTime
		end

		if curTime < moveTime then
			-- 维护目标组的total!
			groupDest:SetTotal(groupDest:GetTotal() + 1)
			return
		end
	end

	groupDest:AddMail(mailData)

	groupDest:Sort()

end

-- 请求更多
function MailDataManager:ReqMore( groupId, callback )

	local group = self.group[groupId]
	if group == nil then
		MailPrint("ReqMore groupId not found!")
		return false
	end

	if group:IsGetAll() then
		if callback then
			callback(false)
		end
		return false
	end

	local mailTotal = #group.mailList

	-- 如果是战斗报告邮件组的话（同时采集邮件已经显示出来了），这里就需要特殊处理一下
	if groupId == MailInternalGroup.MAIL_IN_report then
		local virMail = self:__GetVirtualMail(MailType.NEW_COLLECT_MAIL,groupId)
		if virMail then
			mailTotal = mailTotal - 1
			local groupCount = self:GetGroupMailList(MailInternalGroup.MAIL_IN_gather)
			if groupCount ~= nil then
				mailTotal = mailTotal + #groupCount
			end
		end
		local secVirMail = self:__GetVirtualMail(MailType.MONSTER_COLLECT_REWARD,groupId)
		if secVirMail then
			mailTotal = mailTotal - 1
			local groupCount = self:GetGroupMailList(MailInternalGroup.MAIL_IN_monsterReward)
			if groupCount ~= nil then
				mailTotal = mailTotal + #groupCount
			end
		end
		local threeVirMail = self:__GetVirtualMail(MailType.NEW_FIGHT_BLACK_KNIGHT, groupId)
		if threeVirMail then
			mailTotal = mailTotal - 1
			local groupCount = self:GetGroupMailList(MailInternalGroup.MAIL_IN_blackKnight)
			if groupCount ~= nil then
				mailTotal = mailTotal + #groupCount
			end
		end
		local fourVirMail = self:__GetVirtualMail(MailType.NEW_FIGHT_EXPEDITIONARY_DUEL, groupId)
		if fourVirMail then
			mailTotal = mailTotal - 1
			local groupCount = self:GetGroupMailList(MailInternalGroup.MAIL_IN_expeditionaryDuel)
			if groupCount ~= nil then
				mailTotal = mailTotal + #groupCount
			end
		end
	end

	-- 直接从数据库中取
	DataCenter.MailDataManager.DB:QueryMoreMails(
			groupId, mailTotal, 20,
			function (mailDatas)
				if mailDatas and #mailDatas > 0 then
					self:OnGetDBMails(mailDatas)
				end

				-- 发送读取完毕的消息
				if callback then
					callback(true)
				end
				EventManager:GetInstance():Broadcast(EventId.MailGetMore)
			end)

	return true
end

function MailDataManager:TryShareMail(shareParam)
	if shareParam then
		local shareType = nil
		if shareParam.post == PostType.Text_MailScoutResultShare or shareParam.post == PostType.Text_ScoutReportContentShare or PostType.Text_ScoutAlertContentShare then
			shareType = ShareCheckType.MailScoutResult
		elseif shareParam.post == PostType.Text_Formation_Fight_Share or shareParam.post == PostType.Text_BattleReportContentShare then
			shareType = ShareCheckType.MailBattleReport
		end
		if shareType then
			self.cacheShareParam = shareParam
			SFSNetwork.SendMessage(MsgDefines.ShareCdCheck, shareType)
		end
	end
end

function MailDataManager:OnRecvShareCheckResult(t)
	if t["canSend"] then
		if self.cacheShareParam then
			if self.cacheShareParam.post == PostType.Text_Formation_Fight_Share then
				if self.cacheShareParam.param ~= nil and self.cacheShareParam.param.para ~=nil then
					local uid = self.cacheShareParam.param.para.mailUid
					SFSNetwork.SendMessage(MsgDefines.UserShareMail, uid)
					EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, self.cacheShareParam)
				end
			else
				EventManager:GetInstance():Broadcast(ChatEventEnum.CHAT_SHARE_COMMAND, self.cacheShareParam)
			end
		end
		
	else
		--local nextT = t["nextTime"]
		UIUtil.ShowTipsId(141080)
	end
	self.cacheShareParam = nil
end

function MailDataManager:GetUnReceiveGiftMail()
	if self.mailList~=nil then
		for k, v in pairs(self.mailList) do
			if v.type == MailType.MAIL_GIFT_RECEIVE and v.rewardStatus == 0 then
				return v
			end
		end
	end
	return nil
end

function MailDataManager:AddOneScoutMailToDict(mail)
	local mailExt = mail:GetMailExt()
	if mailExt ~= nil then
		local mailReport = mailExt:GetExtData()
		if mailReport ~= nil and mailReport.targetType == ScoutMailTargetType.MAIN_BUILDING and mailReport.targetUser ~= nil then
			local uid = mailReport.targetUser.uid
			if self.scoutMail[uid] == nil then
				self.scoutMail[uid] = {}
			end
			local pointId = mailExt:GetPointId()

			if self.scoutMail[uid][pointId] == nil then
				self.scoutMail[uid][pointId] = mail
			else
				--比较时间，取最新的
				if mail.createTime >= self.scoutMail[uid][pointId].createTime then
					self.scoutMail[uid][pointId] = mail
				end
			end
		end
	end
end

function MailDataManager:RemoveOneScoutMailToDict(mail)
	local mailExt = mail:GetMailExt()
	if mailExt ~= nil then
		local mailReport = mailExt:GetExtData()
		if mailReport ~= nil and mailReport.targetUser ~= nil then
			local uid = mailReport.targetUser.uid
			local pointId = mailExt:GetPointId()
			if self.scoutMail[uid] ~= nil and self.scoutMail[uid][pointId] ~= nil and self.scoutMail[uid][pointId].uid == mail.uid then
				self.scoutMail[uid][pointId] = nil
			end
		end
	end
end

--通过玩家uid和建筑坐标点获取侦查邮件
function MailDataManager:GetScoutMailByTargetUidAndPoint(targetUid, pointId)
	if self.scoutMail[targetUid] ~= nil and self.scoutMail[targetUid][pointId] ~= nil then
		local mail = self.scoutMail[targetUid][pointId]
		if mail ~= nil then
			--30分钟内才行
			local curTime = UITimeManager:GetInstance():GetServerTime()
			local durTime = LuaEntry.DataConfig:TryGetNum("scout_units_unlock_level", "k2") * 1000
			if durTime <= 0 then
				durTime = ScoutMailShowTime
			end
			if (curTime - mail.createTime) <= durTime then
				return mail
			end
		end
	end
end

--上一次打开邮件分组
function MailDataManager:SetLastGroup(group)
	self.lastGroup = group
end

function MailDataManager:GetLastGroup()
	if self.lastGroup then
		return self.lastGroup
	end
	return 1
end

function MailDataManager:DeleteAllMailDBData()
	self.DB:RemoveAllMailData()
end

return MailDataManager

