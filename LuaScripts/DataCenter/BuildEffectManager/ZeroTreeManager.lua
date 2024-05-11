--0级建筑管理器
local ZeroTreeManager = BaseClass("ZeroTreeManager")
local ResourceManager = CS.GameEntry.Resource

local Scale = 1
local Position = Vector3.New(0,0, 0)
local ShowTreeLevel = 4

function ZeroTreeManager:__init()
	self.scene = nil
	self:AddListener()
end

function ZeroTreeManager:__delete()
	self:RemoveListener()
	self:DestroyEffect()
end

function ZeroTreeManager:Startup()
end

function ZeroTreeManager:AddListener()
	if self.mainLvUpSignal == nil then
		self.mainLvUpSignal = function()
			self:CheckShowTree()
		end
		EventManager:GetInstance():AddListener(EventId.MainLvUp, self.mainLvUpSignal)
	end
end

function ZeroTreeManager:RemoveListener()
	if self.mainLvUpSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.mainLvUpSignal)
		self.mainLvUpSignal = nil
	end
end


function ZeroTreeManager:DestroyEffect()
	if self.scene ~= nil then
		self.scene:Destroy()
		self.scene = nil
	end
end

--显示一个特效
function ZeroTreeManager:CreateScene()
	if self.scene == nil then
		local request = ResourceManager:InstantiateAsync(UIAssets.Common_Empty)
		request:completed('+', function()
			if request.isError then
				return
			end
			request.gameObject:SetActive(true)
			request.gameObject.transform:Set_localScale(Scale, Scale, Scale)
			request.gameObject.transform:Set_position(Position.x, Position.y, Position.z)
		end)
		self.scene = request
	end
end

function ZeroTreeManager:CheckShowTree()
	if DataCenter.CityWallManager:IsHasWall() then
		self:DestroyEffect()
	else
		self:CreateScene()
	end
	
end

return ZeroTreeManager