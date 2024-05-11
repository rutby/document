--[[
	玩家资源信息
]]

local ResourceInfo= BaseClass("ResourceInfo")


function ResourceInfo:AddListener(msg_name, callback)
	local bindFunc = function(...) callback(self, ...) end
	self.__event_handlers[msg_name] = bindFunc
	EventManager:GetInstance():AddListener(msg_name, bindFunc)
end

function ResourceInfo:RemoveListener(msg_name, callback)
	local bindFunc = self.__event_handlers[msg_name]
	if not bindFunc then
		Logger.LogError(msg_name, " not register")
		return
	end
	self.__event_handlers[msg_name] = nil
	EventManager:GetInstance():RemoveListener(msg_name, bindFunc)
end

function ResourceInfo:__init()
	self.__event_handlers = {}
	self:__reset()
	self:AddListener(EventId.EffectNumChange, self.UpdateResourceMaxValue)
end

function ResourceInfo:__reset()
	self.oil = 0
	--self.metal = 0
	self.water = 0
	self.electricity = 0
	self.money = 0
	self.pvePoint = 0
	--self.wood = 0
	self.people = 0
	
	self.flint =0  --赛季资源

	self.maxOil = 0
	self.maxMetal = 0
	self.maxWater = 0
	self.maxElectricity = 0
	self.maxPvePoint = 0
	self.maxFlint = 0
	-- 受矿跟影响，单独读取速度值
	self.oilAddSpeed = 0
	self.waterAddSpeed = 0
	self.metalAddSpeed = 0
	self.iron = 0
	self.food = 0
	self.steel = 0
	-- 餐饮
	self.meal = 0 -- 后端值
	self.deltaMeal = 0 -- 前端改变值
	self.maxMeal = 0
end

function ResourceInfo:InitFromNet(obj)
	local resource = obj["resource"]
	if resource then
		self:UpdateResource(resource)
	end
	self:UpdateResourceMaxValue()

end

function ResourceInfo:Release()
	self:RemoveListener(EventId.EffectNumChange, self.UpdateResourceMaxValue)
end

function ResourceInfo:UpdateResource(resource)
	if resource then
		self:UpdateResourceCurrentValue(resource)
	end
	EventManager:GetInstance():Broadcast(EventId.ResourceUpdated)
end

function ResourceInfo:UpdateResourceAddSpeed(message)
	if message["oil_speed"] then
		self.oilAddSpeed = message["oil_speed"]
	end

	if message["water_speed"] then
		self.waterAddSpeed = message["water_speed"]
	end

	--if message["metal_speed"] then
	--	self.metalAddSpeed = message["metal_speed"]
	--end
end

function ResourceInfo:UpdateResourceCurrentValue(resource)
	
	if resource["oil"] then
		self.oil = resource["oil"]
	end
	
	--if resource["metal"] then
	--	self.metal = resource["metal"]
	--end
	
	if resource["money"] then
		self.money = resource["money"]
	end
	
	if resource["electricity"] then
		self.electricity = resource["electricity"]
	end
	
	if resource["water"] then
		self.water = resource["water"]
	end
	
	if resource["pvePoint"] then
		self.pvePoint = resource["pvePoint"]
	end
	--if resource["wood"] then
	--	self.wood = resource["wood"]
	--end
	if resource["people"] then
		self.people = resource["people"]
	end

	if resource["flint"] then
		self.flint = resource["flint"]
	end
	if resource["food"] then
		self.food = resource["food"]
	end
	if resource["iron"] then
		self.iron = resource["iron"]
	end
	if resource["coal"] then
		self.steel = resource["coal"]
	end
	
end

-- 更新最大值，每次作用号变更的时候需要同步一次
function ResourceInfo:UpdateResourceMaxValue()
	self.maxWater = LuaEntry.Effect:GetGameEffect(EffectDefine.WATER_MAX_LIMIT);
	self.maxMetal = LuaEntry.Effect:GetGameEffect(EffectDefine.METAL_MAX_LIMIT);
	self.maxElectricity = LuaEntry.Effect:GetGameEffect(EffectDefine.ELECTRICITY_MAX_LIMIT);
	self.maxPvePoint = LuaEntry.Effect:GetGameEffect(EffectDefine.PVE_POINT_MAX_LIMIT);
	local oilBase = LuaEntry.Effect:GetGameEffect(EffectDefine.OIL_MAX_LIMIT);
	local oldAdd =LuaEntry.Effect:GetGameEffect(EffectDefine.OIL_MAX_LIMIT_ADD_PERCENT);
	self.maxOil = oilBase*(1+(oldAdd/100))
	local flintBase = LuaEntry.Effect:GetGameEffect(EffectDefine.FLINT_MAX_LIMIT);
	local flintAdd =LuaEntry.Effect:GetGameEffect(EffectDefine.FLINT_MAX_LIMIT_ADD_PERCENT);
	self.maxFlint = flintBase*(1+(flintAdd/100))
	self.maxMeal = LuaEntry.Effect:GetGameEffect(EffectDefine.MEAL_CAPACITY)
end


-- 获取资源最大存储量
function ResourceInfo:GetMaxStorageByResType(type)	

	if type == ResourceType.Oil then
		return self.maxOil
	elseif type == ResourceType.Water then
		return self.maxWater
	elseif type == ResourceType.Electricity then
		return self.maxElectricity
	elseif type == ResourceType.Metal then
		return self.maxMetal
	elseif type == ResourceType.PvePoint then
		return self.maxPvePoint
	elseif type == ResourceType.FLINT then
		return self.maxFlint
	elseif type == ResourceType.Meal then
		return self.maxMeal
	end
	return 0
end

function ResourceInfo:GetResCurrentPercentByResType(type)

	if type == ResourceType.Oil then
		if (self.maxOil <= 0) then

			return 0;
		end
		return self.oil/self.maxOil
	elseif type == ResourceType.FLINT then
		if (self.maxFlint <= 0) then

			return 0;
		end
		return self.flint / self.maxFlint
	elseif type == ResourceType.Water then

		if (self.maxWater <= 0) then

			return 0;
		end

		return self.water/self.maxWater;

	elseif type == ResourceType.Electricity then

		if (self.maxElectricity <= 0) then

			return 0;
		end

		return self.electricity/self.maxElectricity

	elseif type ==ResourceType.Metal then

		--if (self.maxMetal <= 0) then
		--
		--	return 0;
		--end
		Logger.LogError(" can not get Metal percent")
		return 0

	elseif type ==ResourceType.PvePoint then

		if (self.maxPvePoint <= 0) then

			return 0;
		end
		return self.pvePoint/self.maxPvePoint
	end

	return 0
end

-- 获取资源量
function ResourceInfo:GetCntByResType(type)

	if type == ResourceType.Oil then
		return self.oil
	elseif type == ResourceType.Water then
		return self.water
	elseif type == ResourceType.Electricity then
		return self.electricity
	elseif type == ResourceType.Metal then
		Logger.LogError(" can not get Metal")
		return 0
	elseif type == ResourceType.Money then
		return self.money
	elseif type == ResourceType.PvePoint then
		return self.pvePoint
	elseif type == ResourceType.Wood then
		Logger.LogError(" can not get Wood")
		return 0
	elseif type == ResourceType.People then
		return self.people
	elseif type == ResourceType.FLINT then
		return self.flint
	elseif type == ResourceType.Food then
		return self.food
	elseif type == ResourceType.Plank then
		return self.iron
	elseif type == ResourceType.Steel then
		return self.steel
	elseif type == ResourceType.Meal then
		return Mathf.Clamp(self.meal + self.deltaMeal, 0, self.maxMeal)
	end

	return 0
end

-- 资源增加速度
function ResourceInfo:GetResAddSpeedByResType(type)
	if type == ResourceType.Oil then
		return self.oilAddSpeed
	elseif type == ResourceType.Water then
		return self.waterAddSpeed
	elseif type == ResourceType.Electricity then
		--原始+油+核
		return LuaEntry.Effect:GetGameEffect(EffectDefine.ELECTRICITY_SPEED);
		--return self.electricity
	elseif type == ResourceType.Metal then
		Logger.LogError(" can not get Metal Speed")
		return 0
	end			
						
	return 0
end

function ResourceInfo:SyncMealCount(count)
	self.meal = count
	self.deltaMeal = 0
	DataCenter.CityHudManager:RefreshFurnitureHudById(FurnitureType.FoodWindow)
end

function ResourceInfo:ChangeMealCount(delta)
	self.deltaMeal = self.deltaMeal + delta
	DataCenter.CityHudManager:RefreshFurnitureHudById(FurnitureType.FoodWindow)
end

return ResourceInfo
