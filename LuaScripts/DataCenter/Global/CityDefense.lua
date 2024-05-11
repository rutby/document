--[[
	游戏城防信息
	本系统中貌似已经废弃了！
]]

local CityDefense = BaseClass("CityDefense")

function CityDefense:__init()
	self.cityDefenseVal = 0 --城市城防值
	self.cityFireStamp = 0
	self.cityLastRepairStamp = 0
	self.cityUpdateStamp = 0
	self.addDefenceDiamond = 0
end

function CityDefense:InitFromNet(obj)
	self:UpdateCityDefenceInfo(obj)
end

function CityDefense:UpdateCityDefenceInfo(data)
	if data.cityDefValue then
		self.cityDefenseVal = data["cityDefValue"]
	end
	
	if data.ft then
		self.cityFireStamp = data["ft"]
	end

	if data.lastCityDefTime then
		self.cityLastRepairStamp = data["lastCityDefTime"]
	end

	if data.curCostDiamond then
		self.addDefenceDiamond = data["curCostDiamond"]
	end

	self.cityUpdateStamp = UITimeManager:GetInstance():GetServerTime()
end

function CityDefense:UpdateCityDefenceInfo2(data)
	self.cityDefenseVal = data["cityDefValue"]
	self.cityLastRepairStamp = data["lastCityDefTime"]
	if data.curCostDiamond then
		self.addDefenceDiamond = data["curCostDiamond"]
	end
end

-- 重置城防(一般迁城之后调用)
function CityDefense:ResetCityDefence()
	self.cityDefenseVal = GetDefCityMax()
	self.cityFireStamp = 0
	self.cityUpdateStamp = 0
	self.cityLastRepairStamp = 0
end

-- 城堡目前是否处于燃烧状态
function CityDefense:IsCityInFire()
	if (self.cityFireStamp > UITimeManager:GetInstance():GetServerTime()) then
		return true
	end

	return false
end

-- 剩余燃烧时间(秒)
function CityDefense:GetFireRemainTime()
	local seconds = self.cityFireStamp - GameEntry.Timer.GetServerTime();
	seconds = seconds / 1000
	return seconds
end

-- 获取城防最大值
function CityDefense:GetDefCityMax()
	return 1150
end

-- 获取当前城防值
function CityDefense:GetDefCity()
	return self.cityDefenseVal;
end

-- 获取当前的城堡燃烧速度
function CityDefense:GetFireRate()
	local fireRate = 0;

--// 在黑土地上
--if (GameEntry.GlobalData.cityTileCountry == (int)GridType.NEUTRALLY)
--{
--fireRate = GameEntry.GlobalData.fire[2];
--fireRate -= (int)(fireRate * (LuaEntry.Effect:GetGameEffect(564) / 100));
--}
--else
--{
--fireRate = GameEntry.GlobalData.fire[0];
--}

	return fireRate
end

-- 获取当前的城防值
function CityDefense:StartGetCityDefence()
	GetCityDefMessage.Instance.Send();
end

function CityDefense:EndGetCityDefence(dict)

--if (dict.ContainsKey("cityDefValue") == false || dict.ContainsKey("ft") == false)
--{
--return;
--}
--UpdateCityDefenceInfo(dict);
end

function CityDefense:StartRepairCity()
	AddDefenseMessage.Instance.Send();
end

function CityDefense:EndRepairCity(dict)
	UpdateCityDefenceInfo(dict);	
end

function CityDefense:StartCityOutFire()
	BuyCityDefMessage.Instance.Send();
end

function CityDefense:EndCityOutFire(dict)
	UpdateCityDefenceInfo(dict);
end

-- 每次修复城墙的值
function CityDefense:GetRepairValue()
	return GameEntry.GlobalData.fire1[2];
end

-- 获取修改按钮的剩余时间
function CityDefense:GetRepairButtonTime()
	local now = UITimeManager:GetInstance():GetServerTime();
	local interval = GameEntry.GlobalData.fire1[1] * 60 * 1000;
	local next = self.cityLastRepairStamp + interval;
	
	local s = next - now
	s = s / 1000
	
	return s
end

function CityDefense:UpdateCurrentValue()
	if (self:IsCityInFire() == false) then
		return 0
	end

	local ft = self:GetFireRate()

	local now = UITimeManager:GetInstance():GetServerTime()
	local elapse = (now - self.cityUpdateStamp) / 1000
	
	-- 当前消耗的城防值 = 流逝时间 * 每小时的城防值消耗 / 每小时
	local value = ft * elapse / 3600;
	self.cityDefenseVal = self.cityDefenseVal - value

	if(self.cityDefenseVal < 0) then
		self.cityDefenseVal = 0
	end

	self.cityUpdateStamp = UITimeManager:GetInstance():GetServerTime()
	return self.cityDefenseVal
end

-- 目前没有手动灭火这个概念，当火自动灭了之后会自动增长
function CityDefense:UpdateCurrentValueOutFire()
	if (self:IsCityInFire() == true or self.cityDefenseVal >= self:GetDefCityMax()) then
		return
	end

	local ft = self:GetDefenceGrowRate()

	local now = UITimeManager:GetInstance():GetServerTime()
	local elapse = (now - self.cityUpdateStamp) / 1000

	-- 当前消耗的城防值 = 流逝时间 * 每小时的城防值消耗 / 每小时
	local value = ft * elapse / 3600
	self.cityDefenseVal = self.cityDefenseVal + value

	if (self.cityDefenseVal >= self:GetDefCityMax()) then
		self.cityDefenseVal = self:GetDefCityMax()
	end

	self.cityUpdateStamp = UITimeManager:GetInstance():GetServerTime()
end

-- 火灭了之后，城防值满自动增长
function CityDefense:GetDefenceGrowRate()
	local k4 = LuaEntry.DataConfig:TryGetStr("nai_jiu_zhi","k4")
	local GrowMin = (tonumber(k4) / 100) * self:GetDefCityMax()

	local rate = LuaEntry.Effect:GetGameEffect(297)

	GrowMin = GrowMin * (1 + rate / 100)
	return GrowMin * 60;
end

function CityDefense:StartCityAddDefence()
	BuyCitydefAddMessage.Instance.Send();
end

function CityDefense:EndCityAddDefence(dict)
	if (not dict["cityDefValue"]) then
		return;
	end
	
	self:UpdateCityDefenceInfo(dict)
end

function CityDefense:GetCostDiamond()
	return self.addDefenceDiamond
end

function CityDefense:GetDefenceGrow()
	local Grow = LuaEntry.DataConfig:TryGetNum("nai_jiu_zhi","k1")
	return Grow
end

return CityDefense

