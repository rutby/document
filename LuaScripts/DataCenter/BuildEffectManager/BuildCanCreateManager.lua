--建筑可以建造白色特效管理器
local BuildCanCreateManager = BaseClass("BuildCanCreateManager")
local ResourceManager = CS.GameEntry.Resource

local Scale = 20

function BuildCanCreateManager:__init()
	self.allEffect = {} --所有特效
	self.canShowEffect = true--是否可以显示待建造特效
	self:AddListener()
end

function BuildCanCreateManager:__delete()
	self:RemoveListener()
	self:DestroyAllEffect()
	self.allEffect = {} --所有特效
	self.canShowEffect = true--是否可以显示待建造特效
end

function BuildCanCreateManager:Startup()
end

function BuildCanCreateManager:AddListener()
	if self.buildUpgradeFinishSignal == nil then
		self.buildUpgradeFinishSignal = function(uuid)
			self:BuildUpgradeFinishSignal(uuid)
		end
		EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
	end
end

function BuildCanCreateManager:RemoveListener()
	if self.buildUpgradeFinishSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
		self.buildUpgradeFinishSignal = nil
	end
end


function BuildCanCreateManager:DestroyAllEffect()
	for k,v in pairs(self.allEffect) do
		v:Destroy()
	end
	self.allEffect = {}
end

--显示一个特效(rotation为空取配置里旋转，不为空取rotation值)
function BuildCanCreateManager:ShowOneCreateEffect(buildId, rotation)
	local request = ResourceManager:InstantiateAsync(UIAssets.UIBuildCanCreateEffect)
	request:completed('+', function()
		if request.isError then
			return
		end
		request.gameObject:SetActive(true)
		request.gameObject.transform:Set_localScale(Scale, Scale, Scale)
		local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
		if desTemplate ~= nil then
			local pos = desTemplate:GetPosition()
			request.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
			if rotation == nil then
				rotation = desTemplate.rotation
			end
			request.gameObject.transform.rotation = Quaternion.Euler(0, rotation, 0)
		end
	end)
	self.allEffect[buildId] = request
end

function BuildCanCreateManager:RemoveOneCreateEffect(buildId)
	if self.allEffect[buildId] ~= nil then
		self.allEffect[buildId]:Destroy()
		self.allEffect[buildId] = nil
	end
end

function BuildCanCreateManager:BuildUpgradeFinishSignal(bUuid)
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
	if buildData ~= nil then
		self:RemoveOneCreateEffect(buildData.itemId)
	end
end

function BuildCanCreateManager:SetCanShowEffect(isShow)
	if self.canShowEffect ~= isShow then
		self.canShowEffect = isShow
		local list = DataCenter.BuildCityBuildManager:GetCanCreateBuildIdList()
		if list[1] ~= nil then
			for k,v in ipairs(list) do
				local data = DataCenter.BuildCityBuildManager:GetCityBuildDataByBuildId(v)
				if data ~= nil then
					EventManager:GetInstance():Broadcast(EventId.RefreshCityBuildModel, data.pointId)
				end
			end
		end
	end
end

function BuildCanCreateManager:CanShowEffect()
	return self.canShowEffect
end

return BuildCanCreateManager