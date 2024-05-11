---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/6/23 21:37
---
local PushMailMessage = BaseClass("PushMailMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
	
	-- 先加入邮件到管理器
	local message = {
		msg = {t}
	}
	if DataCenter.MailDataManager:IsMailRequestOver() then --本地邮件初始化结束后再接收push
		DataCenter.MailDataManager:OnGetPushMailListMessage(message)

		EventManager:GetInstance():Broadcast(EventId.MailPush, t["uid"])
		if (t.type == MailType.MAIL_SCOUT_RESULT or t.type == MailType.NEW_FIGHT or t.type == MailType.SHORT_KEEP_FIGHT_MAIL) then
			--local mailData = DataCenter.MailDataManager:GetMailInfoById(t["uid"])
			--if (mailData ~= nil) then
			--	local showPanel = true
			--	if ((mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.SHORT_KEEP_FIGHT_MAIL) and mailData:GetMailExt():IsOnlyMonsterBattle()) then
			--		showPanel = false
			--		--处理引导
			--		if DataCenter.GuideManager:GetGuideType() == GuideType.WaitMarchFightEnd then
			--			local param = {}
			--			param.waitMarchFightEnd = true
			--			DataCenter.GuideManager:SetCompleteNeedParam(param)
			--			DataCenter.GuideManager:CheckGuideComplete()
			--		end
			--	end
			--	if (showPanel) then
			--		EventManager:GetInstance():Broadcast(EventId.UIMainShowMailTips, t["uid"])
			--	end
			--end
		elseif t.type == MailType.MIGRATE_APPLY then
			DataCenter.MigrateDataManager:GetMigrateRequest()
		end
	end
end

PushMailMessage.OnCreate = OnCreate
PushMailMessage.HandleMessage = HandleMessage

return PushMailMessage