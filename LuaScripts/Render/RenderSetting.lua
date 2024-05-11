---------------------------------------------------------------------
-- aps_client333 (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2022-01-07 17:18:39
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class CustomSpherical
local RenderSetting = {}
local _gameQulity
local unitySHParamNames = {
	"_Boyan_SHAr","_Boyan_SHAg","_Boyan_SHAb",
	"_Boyan_SHBr","_Boyan_SHBg","_Boyan_SHBb",
	"_Boyan_SHC"
}
local function ToggleBlur(isToggle,name,index)
	
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline~=nil then
		local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
		local objs =  propertyInfo:GetValue(pipeline);
		for i = 1, objs.Length do
			local isDone = false
			local _scriptableRendererData = objs[i-1]
			cast(_scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
			--print(_scriptableRendererData.rendererFeatures.Count)
			for i = 0, _scriptableRendererData.rendererFeatures.Count-1 do
				local featureData=_scriptableRendererData.rendererFeatures[i]
				if featureData.name == name then
					--cast(featureData, typeof(CS.BlurURP))
					if isToggle then
						--featureData:SetActive(isToggle)
						CS.BlurURP.EnableFeature(index)
					else
						CS.BlurURP.DisableFeature(index)
					end
					--featureData:SetActive(isToggle)
					isDone = true
				end
			end
			
			if index==1 then
		
			for i = 0, _scriptableRendererData.rendererFeatures.Count-1 do
				local featureData=_scriptableRendererData.rendererFeatures[i]
                print(featureData.name..":".."BlurURP"..tostring(i))
				if featureData.name == "BlurURP"..tostring(i-1) then
			
						if isToggle then
						else
							featureData:SetActive(isToggle)
						end
				
					isDone = true
				end
			end
		  end
		end
		
	end
end
local function GetQulity()
	return  _gameQulity
end
local function InitRender()
	RenderSetting.InitQulity()
	RenderSetting.DumpSphericalHarmonicsL2()
	RenderSetting.SettingFur()
	RenderSetting.ToggleFurRenderFeature(false)
	RenderSetting.SetLayerCulling()
	--CS.UnityEngine.Rendering.OnDemandRendering.renderFrameInterval = 2;
end

local function SetLayerCulling()

end
local function GetShadowDistance()
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline,typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	return pipeline.shadowDistance
end
local function SetShadowDistance(distance)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline,typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	pipeline.shadowDistance = distance
end
local function ToggleDepthTexture(toggle)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline,typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	pipeline.supportsCameraDepthTexture=toggle
end

local function IsToggleDepthTexture()
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline,typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	return pipeline.supportsCameraDepthTexture
end

--是否关闭阴影
local function ToggleShadow(toggle)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline,typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	pipeline.supportsMainLightShadows = toggle
end
--先根据手机内存匹配
local function InitQulity()
	if CS.SDKManager.IS_UNITY_IPHONE() then
		_gameQulity=2
	else
		local systemMemorySize = CS.UnityEngine.SystemInfo.systemMemorySize
		if systemMemorySize>1024*5 then
			_gameQulity=2
		elseif systemMemorySize>1024*3 then
			_gameQulity=1
		elseif systemMemorySize>1024*2 then
			_gameQulity = 0
		else
			_gameQulity = -1
			_gameQulity = -1
		end
	end

end

local function SetSupportsMainLightShadows(supported)
	pcall(function()
		local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
		cast(pipeline,typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
		pipeline.supportsMainLightShadows = supported
	end)
end
--设置皮毛材质设置
local function SettingFur()
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline == nil then
		return
	end

	local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
	if propertyInfo == nil then
		return
	end

	local objs = propertyInfo:GetValue(pipeline);
	if objs == nil then
		return
	end

	for i = 1, objs.Length do
		local scriptableRendererData = objs[i-1]
		if scriptableRendererData == nil then
			goto continue
		end
		cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
		--print(scriptableRendererData.rendererFeatures.Count)
		for i = 0, scriptableRendererData.rendererFeatures.Count-1 do
			if scriptableRendererData.rendererFeatures[i].name=="NewFurRenderFeature" then
				local featureData=scriptableRendererData.rendererFeatures[i]
				cast(featureData, typeof(CS.FurRenderFeature))
				if _gameQulity<2 then
					featureData.settings.PassLayerNum=1
				end
			end
		end

		::continue::
	end
end
local function HeightFogIsOpen()
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline == nil then
		return
	end
	local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
	if propertyInfo == nil then
		return
	end

	local objs = propertyInfo:GetValue(pipeline);
	if objs == nil then
		return
	end

	for i = 1, objs.Length do
		local scriptableRendererData = objs[i-1]
		if scriptableRendererData ~= nil then
			cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
			for i = 0, scriptableRendererData.rendererFeatures.Count-1 do
				if scriptableRendererData.rendererFeatures[i].name=="NewHeightFogRenderFeature" then
					local featureData=scriptableRendererData.rendererFeatures[i]
					return featureData.isActive
				end
			end
		end
	end
	return false
	
end
local function SettingHeightFog(fogHeight,fogY,color1,color2,fogIntensity)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline == nil then
		return
	end
	local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
	if propertyInfo == nil then
		return
	end

	local objs = propertyInfo:GetValue(pipeline);
	if objs == nil then
		return
	end

	for i = 1, objs.Length do
		local scriptableRendererData = objs[i-1]
		if scriptableRendererData == nil then
			goto continue
		end
		cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
		for i = 0, scriptableRendererData.rendererFeatures.Count-1 do
			if scriptableRendererData.rendererFeatures[i].name=="NewHeightFogRenderFeature" then
				local featureData=scriptableRendererData.rendererFeatures[i]
				cast(featureData, typeof(CS.HeightFogRenderFeature))
				featureData.fogSetting._FogDisappearHeight = fogHeight
				featureData.fogSetting._FogPosY = fogY
				featureData.fogSetting.unexploredColor =color1
				featureData.fogSetting.exploredColor =color2
				featureData.fogSetting.FogIntensity =fogIntensity
			end
		end

		::continue::
	end
end
local function ToggleFurRenderFeature(visible)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline == nil then
		return
	end
	local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
	if propertyInfo == nil then
		return
	end

	local objs = propertyInfo:GetValue(pipeline);
	if objs == nil then
		return
	end

	for i = 1, objs.Length do
		local scriptableRendererData = objs[i-1]
		if scriptableRendererData ~= nil then
			cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
			for i = 0, scriptableRendererData.rendererFeatures.Count-1 do
				if scriptableRendererData.rendererFeatures[i].name=="NewFurRenderFeature" then
					local featureData=scriptableRendererData.rendererFeatures[i]
					featureData:SetActive(visible)
				end
			end
		end
	end
end

local function SetHeightFogVisible(visible)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline == nil then
		return
	end
	local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
	if propertyInfo == nil then
		return
	end

	local objs = propertyInfo:GetValue(pipeline);
	if objs == nil then
		return
	end

	for i = 1, objs.Length do
		local scriptableRendererData = objs[i-1]
		if scriptableRendererData ~= nil then
			cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
			for i = 0, scriptableRendererData.rendererFeatures.Count-1 do
				if scriptableRendererData.rendererFeatures[i].name=="NewHeightFogRenderFeature" then
					local featureData=scriptableRendererData.rendererFeatures[i]
					featureData:SetActive(visible)
				end
			end
		end
	end
end

local function DumpSphericalHarmonicsL2()
	Logger.Log("SH9 Init")
	local _Boyan_SHAb=CS.UnityEngine.Vector4.New(-0.002500065,0.1566966,0.2403159,0.2535352)
	local _Boyan_SHAg=CS.UnityEngine.Vector4.New(-0.0007448478,0.1495781,0.2342949,0.259032)
	local  _Boyan_SHAr=CS.UnityEngine.Vector4.New(-0.0006305838,0.1381056,0.2189651,0.2619695)
	local _Boyan_SHBb=CS.UnityEngine.Vector4.New(0.0009808665,0.1244143,0.1215409,0.007772579)
	local _Boyan_SHBg=CS.UnityEngine.Vector4.New(0.002275236,0.1206006,0.1166272,0.01075001)
	local _Boyan_SHBr=CS.UnityEngine.Vector4.New(0.003193089,0.1160733,0.1080668,0.01155533)
	local _Boyan_SHC=CS.UnityEngine.Vector4.New(0.0118142,0.01242505,0.01204208,1)
	CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[1],_Boyan_SHAr);
	CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[2],_Boyan_SHAg);
	CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[3],_Boyan_SHAb);
	CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[4],_Boyan_SHBr);
	CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[5],_Boyan_SHBg);
	CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[6],_Boyan_SHBb);
	CS.UnityEngine.Shader.SetGlobalVector(unitySHParamNames[7],_Boyan_SHC);
	Logger.Log("SH9 Init Finish")
end

local function SetHDR(enable)
	--local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	--cast(pipeline,typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	--pipeline.supportsHDR = enable
end

local function SetPlaneShadow(enable)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline~=nil then
		local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
		local objs =  propertyInfo:GetValue(pipeline);
		for i = 1, objs.Length do
			local isDone = false
			local _scriptableRendererData = objs[i-1]
			cast(_scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
			for i = 0, _scriptableRendererData.rendererFeatures.Count-1 do
				local featureData=_scriptableRendererData.rendererFeatures[i]
				if featureData.name == "OutLine" or featureData.name == "PlaneShadow" or featureData.name == "PlaneShadow1" or featureData.name == "PlaneShadow2" then
					featureData:SetActive(enable)
					isDone = true
				end
			end
			--if isDone  then
			--	_scriptableRendererData:SetDirty()
			--end
		end

	end
end

local function SetOutLine(enable)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline~=nil then
		local propertyInfo = pipeline:GetType():GetField("m_RendererDataList",4|32 );
		local objs =  propertyInfo:GetValue(pipeline);
		for i = 1, objs.Length do
			local isDone = false
			local _scriptableRendererData = objs[i-1]
			cast(_scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
			for i = 0, _scriptableRendererData.rendererFeatures.Count-1 do
				local featureData=_scriptableRendererData.rendererFeatures[i]
				if featureData.name == "OutLine" or featureData.name == "OutLine1" or featureData.name == "OutLineShadow" then
					featureData:SetActive(enable)
					isDone = true
				end
			end
			--if isDone  then
			--	_scriptableRendererData:SetDirty()
			--end
		end

	end
end

local function ReplacePlaneShadowMaterial(material)
	local pipeline = CS.UnityEngine.QualitySettings.renderPipeline
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))
	if pipeline then
		local propertyInfo = pipeline:GetType():GetField("m_RendererDataList", 4 | 32)
		local objs = propertyInfo:GetValue(pipeline)
		for i = 0, objs.Length - 1 do
			local scriptableRendererData = objs[i]
			cast(scriptableRendererData, typeof(CS.UnityEngine.Rendering.Universal.ScriptableRendererData))
			for j = 0, scriptableRendererData.rendererFeatures.Count - 1 do
				local featureData = scriptableRendererData.rendererFeatures[j]
				if featureData.name == "PlaneShadow" then
					cast(featureData, typeof(CS.UnityEngine.Experimental.Rendering.Universal.RenderObjects))
					local oldMaterial = featureData.settings.overrideMaterial
					featureData.settings.overrideMaterial = material
					return oldMaterial
				end
			end
		end
	end
	return nil
end

local function AddUpdater()
	if RenderSetting.update == nil then
		RenderSetting.update = function() RenderSetting.Update() end
		UpdateManager:GetInstance():AddUpdate(RenderSetting.update)
	end
end

local function RemoveUpdater()
	if RenderSetting.update then
		UpdateManager:GetInstance():RemoveUpdate(RenderSetting.update)
		RenderSetting.update = nil
	end
	
end

local function Update()
	-- 每帧调用,设置中高端机型渲染帧为30，当有输入事件的时候，恢复到原本的帧率
	--if _gameQulity>1 then
	--	if CS.UnityEngine.Input.GetMouseButton(0) or CS.UnityEngine.Input.touchCount>0 then
			--CS.UnityEngine.Rendering.OnDemandRendering.renderFrameInterval = 1
		--else
			--CS.UnityEngine.Rendering.OnDemandRendering.renderFrameInterval = 2
		--end
		
	--end
	--判断是否存在
	--if CS.UnityEngine.Rendering.OnDemandRendering~=nil then
	--	
	--end
end

RenderSetting.InitRender=InitRender
RenderSetting.ToggleBlur=ToggleBlur
RenderSetting.InitQulity = InitQulity
RenderSetting.GetQulity = GetQulity
RenderSetting.ToggleDepthTexture =ToggleDepthTexture
RenderSetting.SetShadowDistance =SetShadowDistance
RenderSetting.GetShadowDistance =GetShadowDistance
RenderSetting.SetSupportsMainLightShadows = SetSupportsMainLightShadows
RenderSetting.DumpSphericalHarmonicsL2 = DumpSphericalHarmonicsL2
RenderSetting.SetHDR = SetHDR
RenderSetting.SettingHeightFog =SettingHeightFog
RenderSetting.SetHeightFogVisible = SetHeightFogVisible
RenderSetting.SettingFur = SettingFur
RenderSetting.ToggleFurRenderFeature=ToggleFurRenderFeature
RenderSetting.IsToggleDepthTexture = IsToggleDepthTexture
RenderSetting.HeightFogIsOpen =HeightFogIsOpen
RenderSetting.SetLayerCulling = SetLayerCulling
RenderSetting.SetOutLine = SetOutLine
RenderSetting.ReplacePlaneShadowMaterial = ReplacePlaneShadowMaterial
RenderSetting.AddUpdater = AddUpdater
RenderSetting.RemoveUpdater = RemoveUpdater
RenderSetting.Update = Update
RenderSetting.SetPlaneShadow = SetPlaneShadow


return RenderSetting