-- APP信息功能类
-- 

local App = {}

-- 用来缓存App的各种变量使用
local self = {}

-- 返回analyticID
function App.GetAnalyticID()
	if self.analyticID == nil then
		self.analyticID = tostring(CS.GameEntry.GlobalData.analyticID)
	end

	return self.analyticID or ''
end

-- 返回来源国家
function App.GetFromCountry()
	if self.fromCountry == nil then
		self.fromCountry = tostring(CS.GameEntry.GlobalData.fromCountry)
	end

	return self.fromCountry or ''
end

-- 获取语言信息
function App.GetLanguageName()
	if self.languageName == nil then
		self.languageName = tostring(CS.GameEntry.Localization:GetLanguageName())
	end
	
	return self.languageName or ''
end

-- 返回版本号
function App.GetVersion()
	if self.version == nil then
		self.version = tostring(CS.GameEntry.Sdk.Version)
	end

	return self.version or ''
end

-- 返回版本号
function App.GetVersionCode()
	if self.versionCode == nil then
		self.versionCode = tonumber(CS.GameEntry.Sdk.VersionCode)
	end

	return self.versionCode or 1
end

-- 返回资源版本 x.y
function App.GetResVersion()
	if self.resVersion == nil then
		self.resVersion = tostring(CS.GameEntry.Resource:GetResVersion())
	end
	
	return self.resVersion or "0.0"
end

-- 返回设备ID
function App.GetDeviceUid()
	if string.IsNullOrEmpty(self.deviceUid) then
		self.deviceUid = tostring(CS.GameEntry.Device:GetDeviceUid())
	end

	return self.deviceUid or ''
end

-- 是否为调试状态
function App.IsDebug()
	if self.isDebug == nil then
		self.isDebug = CS.CommonUtils.IsDebug()
	end

	return self.isDebug or false
end

-- 是否为编辑器状态
function App.IsEditor()
	if self.isEditor == nil then
		self.isEditor = CS.CommonUtils.IsEditor()
	end

	return self.isEditor or false
end

-- 是否为GPTest
function App.IsGPTest()
	local t = App.GetPackageName()
	
	-- GPTest规则是包名末尾是xx.xxx.xxx.xxtest
	if string.endswith(t, "test") then
		return true
	end
	
	--if App.GetPackageName() == package_name_gptest then
		--return true
	--end

	return false
end

-- 获取当前的包名
function App.GetPackageName()
	if self.packageName == nil then
		self.packageName = tostring(CS.GameEntry.Sdk:GetPackageName())
	end

	return self.packageName or ''
end

-- 获取平台名字
function App.GetPlatformName()
	if self.platformName == nil then
		self.platformName = tostring(CS.VEngine.Versions.PlatformName)
	end
	
	return self.platformName or ''
end

function App.IS_ANDROID()
	if self.isAndroid == nil then
		self.isAndroid = CS.SDKManager.IS_UNITY_ANDROID()
	end
	
	return self.isAndroid
end

function App.IS_IOS()
	return false
end


function App.IsFinalRelease()
	if self.isFinalRelease == nil then
		self.isFinalRelease = CS.CommonUtils.IS_FINAL_RELEASE()
	end

	return self.isFinalRelease or false
end

return App
