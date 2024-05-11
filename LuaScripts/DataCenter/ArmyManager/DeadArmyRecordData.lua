---
--- Created by shimin.
--- DateTime: 2023/1/31 12:19
--- 士兵死亡记录数据
---
local DeadArmyRecordData = BaseClass("DeadArmyRecordData")

function DeadArmyRecordData:__init()
	self.time = 0 		--时间
	self.armyDict = {}   --死亡士兵数据<ArmyDeadType, list>
end

function DeadArmyRecordData:__delete()
	self.time = 0 		--时间
	self.armyDict = {}   --死亡士兵数据<ArmyDeadType, list>
end

function DeadArmyRecordData:UpdateInfo(message)
	if message == nil then
		return
	end

	self.time = message["time"]
	self.armyDict = {}
	if message["armyArr"] ~= nil then
		for k,v in ipairs(message["armyArr"]) do
			local armyId = v["armyId"]
			local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
			if template ~= nil then
				if not template:IsMercenary() then
					local one = {}
					one.armyId = armyId
					one.count = v["count"]
					if v["r"] ~= nil then
						one.deadType = v["r"]
					else
						one.deadType = ArmyDeadType.Hospital
					end
					if self.armyDict[one.deadType] == nil then
						self.armyDict[one.deadType] = {}
					end
					table.insert(self.armyDict[one.deadType], one)
				end
			end
		end
	end
end

--获取死亡士兵总数
function DeadArmyRecordData:GetTotalNum()
	local result = 0
	for k,v in pairs(self.armyDict) do
		for k1, v1 in ipairs(v) do
			result = result + v1.count
		end
	end
	return result
end

--通过死亡类型获取死亡士兵
function DeadArmyRecordData:GetDeadDataByDeadType(deadType)
	return self.armyDict[deadType]
end

--检测，如果全是雇佣兵 则清空
function DeadArmyRecordData:NeedDelete()
	return table.count(self.armyDict) == 0
end

return DeadArmyRecordData