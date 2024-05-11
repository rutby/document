--[[
	领取奖励协议
]]

local MailRewardMessage = BaseClass("MailRewardMessage", SFSBaseMessage)

function MailRewardMessage:OnCreate(mailId)
	if string.IsNullOrEmpty(mailId) then
		MailPrint("领取奖励参数不对, mailId 为空")
		return
	end
	
	self.sfsObj:PutUtfString("uid", mailId)
	return
end

function MailRewardMessage:HandleMessage(message)
	
	--CS.CommonUtils.RecvReward(message._raw)
	
	-- 所有商品的奖励是一起返回的，这里整理成一个普通返回的reward结构
	--message.goods
	--message.moneyAdd
	--message.goldAdd
	--message.hero
	
end

return MailRewardMessage

