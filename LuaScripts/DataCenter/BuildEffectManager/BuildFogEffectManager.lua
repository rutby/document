--在迷雾中建筑特效管理器
local BuildFogEffectManager = BaseClass("BuildFogEffectManager")
local BuildFogEffectObject = require "Scene.BuildEffectObject.BuildFogEffectObject"

function BuildFogEffectManager:__init()
	self.allEffect = {} --所有特效
	self:AddListener()
end

function BuildFogEffectManager:__delete()
	self:RemoveListener()
	self:DestroyAllEffect()
	self.allEffect = {} --所有特效
end

function BuildFogEffectManager:Startup()
end

function BuildFogEffectManager:AddListener()
end

function BuildFogEffectManager:RemoveListener()
end

function BuildFogEffectManager:DestroyAllEffect()
	for k,v in pairs(self.allEffect) do
		v:Destroy()
	end
	self.allEffect = {}
end

--显示一个特效
function BuildFogEffectManager:ShowOneEffect(buildId)
	if self.allEffect[buildId] == nil then
		self.allEffect[buildId] = BuildFogEffectObject.New()
		self.allEffect[buildId]:ReInit({buildId = buildId})
	end
end

function BuildFogEffectManager:RemoveOneEffect(buildId)
	if self.allEffect[buildId] ~= nil then
		self.allEffect[buildId]:Destroy()
		self.allEffect[buildId] = nil
	end
end

return BuildFogEffectManager