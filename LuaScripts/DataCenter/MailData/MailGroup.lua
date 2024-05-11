--[[
	邮件的分组状态
	邮件是分组的，我这里按照组来存放；
	分组主要包含：
	目前从数据库拉取的水位
	此分组下红点的数量

	(*) 关于未读邮件，从两个地方处理；因为未读的是总数
	1。读取数据库的时候，获取了未读的总数
	2。网络数据下发的时候，通过AdjustMailCount进行调整

	(*) 另外total也是一样，因为内存中拿到的只是部分邮件
]]

local MailGroup = BaseClass("MailGroup")

function MailGroup:__init(InternalType)
	self.groupId = InternalType
	--self.dbWaterLevel = 0	-- 数据库水位
	self:__reset()
end

function MailGroup:__delete()
end

function MailGroup:__reset()
	self.unreadCount = 0	-- 未读邮件的数量，这个目前从外面维护
	self.total = 0			-- 总数量
	self.mailList = {}		-- 当前组的邮件列表，是一个引用数组
end

function MailGroup:SetTotal(total)
	self.total = total
	if self.total < 0 then
		self.total = 0
		MailPrint("SetTotal error?")
	end
end

function MailGroup:GetTotal()
	return self.total
end

function MailGroup:SetUnreadCount(c)
	self.unreadCount = c
	if self.unreadCount < 0 then
		self.unreadCount = 0
		MailPrint("SetUnreadCount error?")
	end
end

function MailGroup:GetUnreadCount()
	return self.unreadCount
end

-- 
local function compareMail(k1, k2)
	return k1.createTime > k2.createTime
end

-- 添加邮件
function MailGroup:AddMail(mailData, calcTotal)
	MailPrint("AddMail: group[%d], mailId[%s]", self.groupId, mailData.uid)	
	
	local isInsert = false
	-- 如果比最后一封邮件还要晚，就是二分插入
	if not table.IsNullOrEmpty(self.mailList) then
		local lastMail = self.mailList[#self.mailList]
		if lastMail.createTime < mailData.createTime then
			-- 需要插入到指定位置
			table.bininsert(self.mailList, mailData, compareMail)
			isInsert = true
		end
	end
	
	-- 直接在结尾追加即可
	if isInsert == false then
		table.insert(self.mailList, mailData)
	end
	
	mailData.groupId = self.groupId
	
	-- 有些邮件添加的时候不要计算计数的
	if calcTotal ~= false then
		self.total = self.total + 1
		
		-- 如果邮件未读则增加未读数量
		if mailData.status == 0 then
			self.unreadCount = self.unreadCount + 1
		end
	end
end

-- 删除邮件
function MailGroup:RemoveMail(mailId)
	MailPrint("RemoveMail: group[%d], mailId[%s]", self.groupId, mailId)
	for _,v in ipairs(self.mailList) do
		if v.uid == mailId then
			v.groupId = -1
			table.remove(self.mailList, _)
			self.total = self.total - 1 
			
			-- 删除邮件理论上不应该有未读的。采集邮件，添加删除前都要置status=1
			if v.status == 0 then
				self.unreadCount = self.unreadCount - 1
			end
			break
		end
	end
end

-- 删除所有邮件
function MailGroup:RemoveMailAll()
	MailPrint("RemoveMailAll: group[%d]", self.groupId)
	self:__reset()
end

-- 是否有邮件
function MailGroup:HasMail()
	return not table.IsNullOrEmpty(self.mailList)
end

-- 邮件排序，时间越新的排到越前面
function MailGroup:Sort()
	--table.sort(self.mailList, 
		--function (v1, v2)
			--return v1.createTime > v2.createTime
		--end)
end

-- 数据是否饱和
function MailGroup:IsGetAll()
	--黑骑士和远征活动处理
	if self.groupId == MailInternalGroup.MAIL_IN_blackKnight or self.groupId == MailInternalGroup.MAIL_IN_expeditionaryDuel then
		return false
	end
	if #self.mailList == self.total then
		return true
	end
	
	if #self.mailList > self.total then
		MailPrint("IsGetAll bug!!!")
		return true
	end
	
	return false
end


return MailGroup





