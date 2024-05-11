--[[
	批量删除邮件的消息
	删除的时候要把邮件uid传给服务器
	因为服务器的邮件表比较大，所以这里没法直接发type
]]

local MailBatchDelMessage = BaseClass("MailBatchDelMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization

local function OnCreate(self, mailIds, types)
	
	-- 如果是table的话，需要组合一下
	-- 发给服务器的是,号分割的字符串
	if type(mailIds) == "table" then
		mailIds = table.concat(mailIds, ",")
    end
	
	if string.IsNullOrEmpty(mailIds) then
		MailPrint("MailBatchDel string error!!")
	end
	
	if type(mailIds) == "string" then
		self.sfsObj:PutUtfString("uids", mailIds)
		return
	end
end

local function HandleMessage(self, t)
	
	MailPrint("MailBatchDelMessage return : " .. tostring(t.success))
	EventManager:GetInstance():Broadcast(EventId.MailBatchDelete)
	EventManager:GetInstance():Broadcast(EventId.MailPush)
	--if t.success == true then
	--	UIUtil.ShowTipsId(310112) 
	--	return 
	--end
	
    local errCode =  t["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode) 
	end
end

MailBatchDelMessage.OnCreate = OnCreate
MailBatchDelMessage.HandleMessage = HandleMessage

return MailBatchDelMessage