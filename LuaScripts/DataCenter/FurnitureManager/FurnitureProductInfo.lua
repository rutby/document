--- Created by shimin.
--- DateTime: 2024/3/26 16:25
--- 家具生产信息

local FurnitureProductInfo = BaseClass("FurnitureProductInfo")

function FurnitureProductInfo:__init()
	self.uuid = 0--家具uuid
	self.startTime = 0--开始时间
	self.endTime = 0--结束时间
	self.stopTime = 0--停止时间
end

function FurnitureProductInfo:__delete()
	self.uuid = 0--家具uuid
	self.startTime = 0--开始时间
	self.endTime = 0--结束时间
	self.stopTime = 0--停止时间
end

function FurnitureProductInfo:SetTime(fUuid, startTime, endTime, stopTime)
	self.uuid = fUuid
	self.startTime = startTime
	self.endTime = endTime
	self.stopTime = stopTime or 0
end

function FurnitureProductInfo:SetStopTime(stopTime)
	self.stopTime = stopTime
end


return FurnitureProductInfo