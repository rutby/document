---
--- 游戏画面设置
---

require "Util.DeviceModelSpec"
require "Util.SocModelSpec"

local tolower = string.lower
local Setting = CS.GameEntry.Setting
local Application = CS.UnityEngine.Application
local SceneQualitySetting = CS.SceneQualitySetting
local SystemInfo = CS.UnityEngine.SystemInfo
local QualitySettings = CS.UnityEngine.QualitySettings

local _isEnableUpdateTargetFrameRate = false
local _kMiddleQualityTargetFrameRate = 30
local _kLowTargetFrameRate = 45
local _kHighTargetFrameRate = 60
local _kCompareTargetFrameRate = 53
local _curTargetFrameRate = 60

local _combatUnitsThreshhold = 255
local _kPixelWidthMax = 1080
local _kPixelWidthMaxLow = 720
local _kRenderScaleLow = 0.7
local Screen = CS.UnityEngine.Screen
local MainCamera
local function SetTargetFrameRate(targetFrameRate)
	Application.targetFrameRate = targetFrameRate
end

local QualitySettingUtil = {
	Low = { 
		[EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.Off,
		[EnumQualitySetting.Resolution] = EnumQualityLevel.Low,
		[EnumQualitySetting.Terrain] = EnumQualityLevel.Low,
	},
	Middle = {
		[EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.High,
		[EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.Off,
		[EnumQualitySetting.Resolution] = EnumQualityLevel.High,
		[EnumQualitySetting.Terrain] = EnumQualityLevel.Low,
	},
	High = {
		[EnumQualitySetting.PostProcess_Bloom] = EnumQualityLevel.High,
		[EnumQualitySetting.PostProcess_ColorAdjustments] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_Vignette] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_Tonemapping] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_LiftGammaGain] = EnumQualityLevel.Off,
		[EnumQualitySetting.PostProcess_DepthOfField] = EnumQualityLevel.Off,
		[EnumQualitySetting.Resolution] = EnumQualityLevel.High,
		[EnumQualitySetting.Terrain] = EnumQualityLevel.Low,
	},

	LowGflops = 250.0,
	HighGflops = 450.0,
	LowPassMark = 5300.0,
	HighPassMark = 12000.0,
	LowBenchmark = 1000.0,
	HighBenchmark = 2000.0,
	CurrentGraphicLv = EnumQualityLevel.High,
}

function QualitySettingUtil.Init()
 if CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC() then
	CS.UnityEngine.QualitySettings.SetQualityLevel(3);
    --return;
 end
	if not QualitySettingUtil.isInit then
		QualitySettingUtil.isInit = true
		SceneQualitySetting.SetPixelWidthMax(_kPixelWidthMax)
		if CS.SDKManager.IS_IPhonePlayer() then
			SetTargetFrameRate(60)
		else
			SetTargetFrameRate(60)
		end
		UpdateManager:GetInstance():AddUpdate(QualitySettingUtil.Update)
		QualitySettingUtil.CheckSetting()
	end
end

function QualitySettingUtil.Uninit()
 --if CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC() then
 --   return;
 --end
	if QualitySettingUtil.isInit then
		QualitySettingUtil.isInit = false
		UpdateManager:GetInstance():RemoveUpdate(QualitySettingUtil.Update)
	end
end

function QualitySettingUtil.OnLowFps()
	QualitySettingUtil.SetSettingGroup(EnumQualityLevel.Middle)
end

function QualitySettingUtil.CheckSetting()
	local recommendLevel = QualitySettingUtil.GetRecommendLevel()
	local frameLevel = Setting:GetInt(SettingKeys.SCENE_FPS_LEVEL, recommendLevel)
	QualitySettingUtil.SetSetting(SettingKeys.SCENE_FPS_LEVEL, frameLevel)
	local graphicLevel = Setting:GetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, recommendLevel)
	QualitySettingUtil.SetSettingGroup(graphicLevel)
	Logger.Log(string.format("CheckSetting frameLevel:%d graphicLevel:%d", frameLevel, graphicLevel))
end

function QualitySettingUtil.GetRecommendLevel()
	local dev_model = tolower(Setting:GetString("DEVICE_MODEL", SystemInfo.deviceModel))
	local soc_model = tolower(Setting:GetString("SOC_MODEL", ""))
	local cpu_freq = Setting:GetInt("CPU_FREQ", SystemInfo.processorFrequency)
	local spec = DeviceModelSpecConfigs[dev_model]
	local passmark = 0.0 
	if spec == nil then 
		spec = SocModelSpecConfigs[soc_model]
	else
		passmark = spec.bm_passmark
	end
	local lv = EnumQualityLevel.Middle
	--if spec ~= nil then
	--	-- [Humphrey] check BM_PassMark first, then check GFlops, then CPU_Freq
	--	if passmark > 100.0 then
	--		if passmark < QualitySettingUtil.LowPassMark then lv = EnumQualityLevel.Low
	--		elseif passmark < QualitySettingUtil.HighPassMark then lv = EnumQualityLevel.Middle
	--		end
	--	else
	--		local gflops = spec.gpu_gflops
	--		if gflops < QualitySettingUtil.LowGflops then lv = EnumQualityLevel.Low
	--		elseif gflops < QualitySettingUtil.HighGflops then lv = EnumQualityLevel.Middle
	--		end
	--	end
	--elseif cpu_freq ~=nil and cpu_freq > 100 and cpu_freq <= 2400 then
	--	-- [Humphrey] mark low end device is the cpu_freq is less than 1.6GHz
	--	lv = EnumQualityLevel.Low
	--end
	-- [Humphrey] mark low end device if device's memory is less than 2GB
	if SystemInfo.systemMemorySize <= 5000 then
		lv = EnumQualityLevel.Low
    end
	Logger.Log(string.format("Device Model: %s Board: %s CPU freq: %d RecommendQuality: %d", dev_model, soc_model, cpu_freq, lv))
	return lv
end

function QualitySettingUtil.GetSetting(inType)
	local setting = QualitySettingUtil.GetSettingGroup(QualitySettingUtil.CurrentGraphicLv)
	return setting[inType]
end

function QualitySettingUtil.SetSetting(inType, inLevel)
	Setting:SetInt(inType, inLevel)
	if inType == EnumQualitySetting.FPS then
		--local isHighLevel = (inLevel == EnumQualityLevel.High)
		--QualitySettingUtil.SetEnableUpdateTargetFrameRate(isHighLevel)
	end
end

function QualitySettingUtil.GetSettingGroup(inLevel)
	local setting = QualitySettingUtil.High
	if inLevel == EnumQualityLevel.Low then
		setting = QualitySettingUtil.Low
	elseif inLevel == EnumQualityLevel.Middle then
		setting = QualitySettingUtil.Middle 
	elseif inLevel == EnumQualityLevel.High then
		setting = QualitySettingUtil.High
	end
	return setting
end

function QualitySettingUtil.SetSettingGroup(inLevel)
	local setting = QualitySettingUtil.GetSettingGroup(inLevel)
	for k, v in pairs(setting) do
		QualitySettingUtil.SetSetting(k, v)
	end
	QualitySettingUtil.CurrentGraphicLv = inLevel
	Setting:SetInt(SettingKeys.SCENE_GRAPHIC_LEVEL, inLevel)
	QualitySettingUtil.SaveSetting()

end
function QualitySettingUtil.TogglePostProcess(toggle)
	if MainCamera == nil then
		MainCamera = CS.UnityEngine.Camera.main
	end
	local cameraStack = MainCamera:GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData))
	cameraStack.renderPostProcessing = toggle
end

function QualitySettingUtil.SaveSetting()
	Setting:Save()
	if CS.SceneManager.World then
		CS.SceneManager.World:ChangeQualitySetting();
	end
	QualitySettingUtil.SetResolutionQuality()
	QualitySettingUtil.SetHDR()
	QualitySettingUtil.SetOutLine()
	QualitySettingUtil.SetShader()
	QualitySettingUtil.SetPlaneShadow()
	EventManager:GetInstance():Broadcast(EventId.QualityChange)
end

function QualitySettingUtil.SetResolutionQuality()
 if CS.SDKManager.IS_UNITY_PC~=nil and CS.SDKManager.IS_UNITY_PC() then
    return;
 end
	local renderScale = 0.9;
	if Screen.width > _kPixelWidthMax then
		renderScale = _kPixelWidthMax / Screen.width
	end
	
	local pipeline = QualitySettings.GetRenderPipelineAssetAt(QualitySettings.GetQualityLevel())
	cast(pipeline, typeof(CS.UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset))

	local lv = Setting:GetInt(EnumQualitySetting.Resolution, EnumQualityLevel.Low)
	if lv == EnumQualityLevel.Low then
		renderScale = renderScale * _kRenderScaleLow
		local width = renderScale * Screen.width
		if width > _kPixelWidthMaxLow then
			renderScale = _kPixelWidthMaxLow / Screen.width
		end
		pipeline.renderScale = renderScale
		--if SystemInfo.systemMemorySize <= 4000 and CS.SDKManager.IS_UNITY_ANDROID() then
		--	local width = math.ceil(Screen.width * renderScale);
		--	local height1 = math.ceil(Screen.height * renderScale);
		--	Screen.SetResolution(width, height1, true);
		--	Logger.Log(string.format("SetResolution from %s_%s to %s_%s %s_%s", Screen.width, Screen.height, width, height1, Screen.width, Screen.height))
		--end
	else
		pipeline.renderScale = renderScale
	end
end

function QualitySettingUtil.SetHDR()
	--[[if QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.Low then
		RenderSetting.SetHDR(false)
	else
		RenderSetting.SetHDR(true)
	end]]
end

function QualitySettingUtil.SetOutLine()
	if QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.Low then
		RenderSetting.SetOutLine(false)
	else
		RenderSetting.SetOutLine(true)
	end
end

function QualitySettingUtil.SetPlaneShadow()
	if QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.Low then
		RenderSetting.SetPlaneShadow(false)
	else
		RenderSetting.SetPlaneShadow(true)
	end
end

function QualitySettingUtil.SetShader()
	if QualitySettingUtil.CurrentGraphicLv == EnumQualityLevel.Low then
		CS.UnityEngine.Shader.EnableKeyword('LOW_DEVICE')
	else
		CS.UnityEngine.Shader.DisableKeyword('LOW_DEVICE')
	end
	
end

-- FPS
function QualitySettingUtil.SetEnableUpdateTargetFrameRate(isEnable)
	_isEnableUpdateTargetFrameRate = isEnable
	if not isEnable then
		_curTargetFrameRate = _kMiddleQualityTargetFrameRate
		SetTargetFrameRate(_kMiddleQualityTargetFrameRate)
	end
end

function QualitySettingUtil.Update()
	if not _isEnableUpdateTargetFrameRate then
		return
	end

	local combatUnitsCount = 0 --luaEntityAdminInst.MapUnitComp.curUpdateCombatUnitsCount
	if combatUnitsCount > _combatUnitsThreshhold then
		if _curTargetFrameRate > _kCompareTargetFrameRate then
			_curTargetFrameRate = _kLowTargetFrameRate
			SetTargetFrameRate(_curTargetFrameRate)
		end
	else
		if _curTargetFrameRate < _kCompareTargetFrameRate then
			_curTargetFrameRate = _kHighTargetFrameRate
			SetTargetFrameRate(_curTargetFrameRate)
		end
	end
end

return QualitySettingUtil