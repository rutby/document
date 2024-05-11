---
--- Created by shimin.
--- DateTime: 2022/6/13 11:25
--- 英雄委托数据
---

local HeroEntrustInfo = BaseClass("HeroEntrustInfo")

function HeroEntrustInfo:__init()
	self.id = 0							--int
	self.state = 0						--int  0未完成 1已完成
	self.payArr = {}					--int arr  已交付的物品数组，1 表示第一个物品已经交付
end

function HeroEntrustInfo:__delete()
	self.id = 0							--int
	self.state = 0						--int  0未完成 1已完成
	self.payArr = {}					--int arr  已交付的物品数组，1 表示第一个物品已经交付
end

function HeroEntrustInfo:UpdateInfo(message)
	if message == nil then
		return
	end
	
	self.id = message["id"]
	self.state = message["state"]
	self.payArr = message["payArr"]
end
--是否全部交付
function HeroEntrustInfo:IsAllComplete()
	return self.state == HeroEntrustState.Yes
end
--index子任务是否交付
function HeroEntrustInfo:IsCompleteByIndex(index)
	if self.payArr ~= nil then
		for k,v in ipairs(self.payArr) do
			if v == index then
				return true
			end
		end
	end
	return false
end

--获取未完成的委托index
function HeroEntrustInfo:GetUnCompleteIndexList()
	if not self:IsAllComplete() then
		local result = {}
		local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(self.id)
		if template ~= nil then
			for k,v in ipairs(template.need) do
				if not self:IsCompleteByIndex(k) then
					table.insert(result, k)
				end
			end
		end
		return result
	end
end

return HeroEntrustInfo