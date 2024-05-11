--[[
	金币价格
	这个主要是用来处理第三方平台的代币问题的
	譬如先用￥购买平台的代币，然后再用代币购买礼包
]]

local GoldPrice = BaseClass("GoldPrice", Singleton)

function GoldPrices:__init()
end

function GoldPrices:__reset()
	self.id = ""
	self.exchange_id = ""
	self.product_id = ""
	self.vk = ""
	self.qq = ""
	self.mycard = ""
	self.gash = ""
	self.mol = ""
end

function GoldPrices:Parse(data)
	if (data == null) then
		return
	end

	self.id = data["id"] or ""
	self.exchange_id = data["exchange_id"] or ""
	self.product_id = data["product_id"] or ""
	self.vk = data["VK"] or ""
	self.qq = data["QQ"] or ""
	self.mycard = data["mycard"] or ""
	self.gash = data["gash"] or ""
	self.mol = data["mol"] or ""
end

return GoldPrice

