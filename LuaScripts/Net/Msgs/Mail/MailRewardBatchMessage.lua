--[[
	批量领取奖励协议
	注意:该协议返回后要把数据库中所有的邮件和已经缓存的都设置为已领取 并且更新界面
]]

local MailRewardBatchMessage = BaseClass("MailRewardBatchMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization

function MailRewardBatchMessage:OnCreate(mailIds)
	
	if type(mailIds) == "table" then
		mailIds = table.concat(mailIds, ",")
	end
	
	if string.IsNullOrEmpty(mailIds) then
		MailPrint("MailRewardBatchMessage error!")
	end
	
	self.sfsObj:PutUtfString("uids", mailIds)
end

function MailRewardBatchMessage:HandleMessage(message)	
	MailPrint("MailRewardBatchMessage:HandleMessage")
	
	-- 所有商品的奖励是一起返回的，这里整理成一个普通返回的reward结构
	--message.goods
	--message.moneyAdd
	--message.goldAdd
	--message.hero
	DataCenter.MailDataManager:OnRewardMails()

	--区分单次领取和一键所有展示方式
	--if DataCenter.MailDataManager.isAll or message["hero"]~=nil then
		--一键领取等获取到所有奖励再展示
		SoundUtil.PlayEffect(SoundAssets.Effect_Ue_GetReward)
		DataCenter.RewardManager:ShowGiftReward(message, Localization:GetString("320320"))
		--DataCenter.MailDataManager:RewardCheckMails(message)
	--else
	--	EventManager:GetInstance():Broadcast(EventId.ReadOneMailRespond)
	--end
	-- 领取奖励,暂时实现了goods,这个弄明白后需要统一一下，为什么游戏内又是rewards又是goods。。。。
	if message["goods"] then
		for k,v in pairs(message["goods"]) do
			local param = {}
			param["type"] = RewardType.GOODS
			param["value"] = v
			DataCenter.RewardManager:AddOneReward(param)
		end
	end
	if message["stone"] then	--水晶
		LuaEntry.Resource.metal = message["stone"]
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
	end
	if message["exp"] then		--经验
		LuaEntry.Player.exp = message["exp"]
	end
	if message["gold"] then		--钻石
		LuaEntry.Player.gold = message["gold"]
		EventManager:GetInstance():Broadcast(EventId.UpdateGold)
	end
	if message["water"] then	--水
		LuaEntry.Resource.water = message["water"]
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
	end
	if message["money"] then	--钞票
		LuaEntry.Resource.money = message["money"]
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
	end
	if message["electricity"] then	--电力
		LuaEntry.Resource.electricity = message["electricity"]
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
	end
	if message["wood"] then	--木头
		LuaEntry.Resource.wood = message["wood"]
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
	end
	if message["coal"] then	--煤? 钢铁!
		LuaEntry.Resource.steel = message["coal"]
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
	end
	if message["iron"] then	--铁? 木头!
		LuaEntry.Resource.steel = message["iron"]
		EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
	end

	if message["arms"] then
		local dic = message["arms"]
		if dic ~= nil then
			for k,v in pairs(dic) do
				local armyInfo = DataCenter.ArmyManager:FindArmy(v.itemId)
				--如果有该类型的士兵
				if armyInfo ~= nil then
					armyInfo:UpdateFree(v.count)
				else
					local param = {}
					param.id = v.itemId
					param.free = v.count
					DataCenter.ArmyManager:UpdateOneArmy(param)
				end
			end
		end
	end
	
	--[[
	local rewards = MailUtils.FormatRewardForShow(message)
	local rewardList = CS.RewardController.Instance:GetRewardListByLuaArr(rewards)
	CS.CommonUtils.OpenCommonRewardTip("110425", rewardList)
	--将所有查询的邮件设置为已领取邮件
	self:setAllQueryMailsReceived()
	--更新缓存数据
	MailChannelManager:receivedAllMailsReward(self.panelType)
	--通知界面更新未读数
	Event:notify_all(CS.EventId.LF_MailReadRefresh)
	--刷新邮件界面
	Event:notify(MailEventId.REFRESH_MAIL_VIEW)
	]]
end

return MailRewardBatchMessage
