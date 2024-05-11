--- Created by shimin.
--- DateTime: 2024/3/12 20:15
--- 特效管理器
local EffectSceneManager = BaseClass("EffectSceneManager")
local BaseBuildLightRangeScene = require "Scene.GuideAnimScene.BaseBuildLightRangeScene"

function EffectSceneManager:__init()
	self.model = {}
	self:AddListener()
end

function EffectSceneManager:__delete()
	self:RemoveListener()
	self:DestroyAllEffect()
	self.model = {}
end

function EffectSceneManager:Startup()
end

function EffectSceneManager:AddListener()
end

function EffectSceneManager:RemoveListener()
end

function EffectSceneManager:DestroyAllEffect()
	for k,v in pairs(self.model) do
		v:Destroy()
	end
	self.model = {}
end

function EffectSceneManager:DestroyOneScene(sceneType)
	if self.model[sceneType] ~= nil then
		self.model[sceneType]:Destroy()
		self.model[sceneType] = nil
	end
end

function EffectSceneManager:LoadOneScene(param)
	if self.model[param.sceneType] == nil then
		self.model[param.sceneType] = self:GetScript(param.sceneType)
	end
	self.model[param.sceneType]:ReInit(param)
end

function EffectSceneManager:GetScript(sceneType)
	if sceneType == GuideAnimObjectType.BaseBuildLightRangeScene then
		return BaseBuildLightRangeScene.New()
	end
end


return EffectSceneManager