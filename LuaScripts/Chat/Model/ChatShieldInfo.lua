--[[
	聊天屏蔽消息
	里面就保存一个uuid和uid即可，需要数据的时候，去ChatUserInfo里面取
]]

local ChatShieldInfo = BaseClass("ChatShieldInfo")

--构造函数
function ChatShieldInfo:__init()
    self.uuid = ""
    self.uid  = ""
end 

function ChatShieldInfo:onParseServerData(shieldTab)
	self.uuid = shieldTab.uuid
	if shieldTab.other then 
		self.uid  = shieldTab.other
	end 

	if shieldTab.name then 
		self.name = shieldTab.name
	end 

	--if shieldTab.repLevel then 
		--self.rank = tonumber(shieldTab.repLevel)
	--end 

	if shieldTab.pic then 
		self.pic = shieldTab.pic
	end

	if shieldTab.picVer then 
		self.picVer = shieldTab.picVer
	end

	if shieldTab.power then 
		self.power = shieldTab.power
	end
	if shieldTab.server then
		self.server = shieldTab.server
	end

	if shieldTab.abbr then 
		self.abbr = shieldTab.abbr
	end
	
	--if shieldTab.allianceId then
	--	self.allianceId = shieldTab.allianceId
	--end
	
	--if shieldTab.allianceName then
		--self.allianceName = shieldTab.allianceName
	--end
end

return ChatShieldInfo