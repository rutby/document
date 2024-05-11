--- Created by shimin.
--- DateTime: 2023/11/7 11:39
--- 家具信息

local FurnitureInfo = BaseClass("FurnitureInfo")

function FurnitureInfo:__init()
	self.uuid = 0			--long 装饰唯一uuid
	self.fId = 0			--int 家具id
	self.lv = 0				--int 等级
	self.bUuid = 0			--long 主建筑uuid
	self.index = 0			--int 主建筑的第几个fId家具（大部分是1） 为了防止主建筑原来有5个家具，改成要删除第2个这种极端情况，index不能从1开始叠加 要写成代表主建筑的第几个fId家具
end

function FurnitureInfo:__delete()
	self.uuid = 0			--long 装饰唯一uuid
	self.fId = 0			--int 家具id
	self.lv = 0				--int 等级
	self.bUuid = 0			--long 主建筑uuid
	self.index = 0			--int 主建筑的第几个fId家具（大部分是1） 为了防止主建筑原来有5个家具，改成要删除第2个这种极端情况，index不能从1开始叠加 要写成代表主建筑的第几个fId家具
end

function FurnitureInfo:UpdateInfo(message)
	if message == nil then
		return
	end
	
	self.uuid = message["uuid"]
	self.fId = message["fId"]
	self.lv = message["lv"]
	self.bUuid = message["bUuid"]
	self.index = message["index"]
end

return FurnitureInfo