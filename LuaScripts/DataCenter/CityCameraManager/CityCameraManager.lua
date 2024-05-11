--- Created by shimin.
--- DateTime: 2023/2/16 21:19
--- 主城相机初始高度管理器

local CityCameraManager = BaseClass("CityCameraManager")

function CityCameraManager:__init()
	self.cacheZoomValue = -1
	self.cacheZoomPos = nil
	self:AddListener()
end

function CityCameraManager:__delete()
	self:RemoveListener()
end

function CityCameraManager:Startup()
end

function CityCameraManager:AddListener()
	if self.onEnterCitySignal == nil then
		self.onEnterCitySignal = function()
			self:OnEnterCitySignal()
		end
		EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.onEnterCitySignal)
	end
	if self.onEnterGameSignal == nil then
		self.onEnterGameSignal = function()
			self:OnEnterGameSignal()
		end
		EventManager:GetInstance():AddListener(EventId.LOAD_COMPLETE, self.onEnterGameSignal)
	end
	if self.mainLvUpSignal == nil then
		self.mainLvUpSignal = function()
			self:MainLvUpSignal()
		end
		EventManager:GetInstance():AddListener(EventId.MainLvUp, self.mainLvUpSignal)
	end
end

function CityCameraManager:RemoveListener()
	if self.onEnterCitySignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.onEnterCitySignal)
		self.onEnterCitySignal = nil
	end
	if self.mainLvUpSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.mainLvUpSignal)
		self.mainLvUpSignal = nil
	end
	if self.onEnterGameSignal ~= nil then
		EventManager:GetInstance():RemoveListener(EventId.LOAD_COMPLETE, self.onEnterGameSignal)
		self.onEnterGameSignal = nil
	end
end

function CityCameraManager:InitData()
	local mainLv = DataCenter.BuildManager.MainLv or 0
	local cameraData = nil
	local height = 25
	if mainLv>0 then
		for i = mainLv,1,-1 do
			cameraData = LocalController:instance():getLine("camera_unlock",i)
			if cameraData~=nil then
				break
			end
		end
	end
	if cameraData ~= nil then
		local zoom = cameraData:getValue("zoom")
		if zoom~=nil then
			local arr = string.split(zoom, "|")
			if #arr == 3 then
				local initArr = string.split(arr[2], ";")
				if #initArr == 3 then
					height = tonumber(initArr[1])
				end
			end
		end
	end
	self:SetCurZoom(height)
end

function CityCameraManager:OnEnterCitySignal()
	if CS.SceneManager.World == nil then
		return
	end
	self:UpdateCamera()
end

function CityCameraManager:OnEnterGameSignal()
	if SceneUtils.GetIsInCity() then
		if CS.SceneManager.World == nil then
			return
		end
		
		self:UpdateCamera()
	end
end
function CityCameraManager:SetCurZoom(value)
	self.zoom = value
end

function CityCameraManager:GetCurZoom()
	if self.cacheZoomValue>0 then
		local value = self.cacheZoomValue
		return value
	end
	return self.zoom
end
function CityCameraManager:MainLvUpSignal()
	if SceneUtils.GetIsInCity()==false then
		return
	end
	if CS.SceneManager.World == nil or (not CS.SceneManager.World:IsBuildFinish()) then
		return
	end
	self:UpdateCamera()
end
function CityCameraManager:UpdateCamera()
	if not DataCenter.GuideManager:IsUseGuideCameraConfig() then
		local scene = CS.SceneManager.World
		local mainLv = DataCenter.BuildManager.MainLv or 0
		local cameraData = nil
		if mainLv>0 then
			for i = mainLv,1,-1 do
				cameraData = LocalController:instance():getLine("camera_unlock",i)
				if cameraData~=nil then
					break
				end
			end
		end

		if cameraData ~= nil then
			local range = cameraData:getValue("range")
			if range~=nil then
				local arr = string.split(range, "|")
				if #arr == 2 then
					local arr1 = string.split(arr[1],";")
					local arr2 = string.split(arr[2],";")
					if #arr1 ==2 and #arr2 ==2 then
						scene:SetRangeValue(toInt(arr1[1]),toInt(arr1[2]),toInt(arr2[1]),toInt(arr2[2]))
					end
				end
			end

			local zoom = cameraData:getValue("zoom")
			if zoom~=nil then
				local arr = string.split(zoom, "|")
				if #arr == 3 then
					local minArr = string.split(arr[1], ";")
					local initArr = string.split(arr[2], ";")
					local maxArr = string.split(arr[3], ";")
					if #minArr == 3 then
						local height = tonumber(minArr[1])
						local ZValue = tonumber(minArr[2])
						local sensitivity = tonumber(minArr[3])
						scene:SetCameraMinHeight(height)
						scene:SetZoomParams(1,height,ZValue,sensitivity)
					end
					if #initArr == 3 then
						local height = tonumber(initArr[1])
						local ZValue = tonumber(initArr[2])
						local sensitivity = tonumber(initArr[3])
						self:SetCurZoom(height)
						EventManager:GetInstance():Broadcast(EventId.ChangeCameraInitZoom,  self.zoom)
						scene:SetZoomParams(2,height,ZValue,sensitivity)
					end
					if #maxArr == 3 then
						local height = tonumber(maxArr[1])
						local ZValue = tonumber(maxArr[2])
						local sensitivity = tonumber(maxArr[3])
						scene:SetCameraMaxHeight(height)
						scene:SetZoomParams(3,height,ZValue,sensitivity)
						scene:SetZoomParams(4,height,ZValue,sensitivity)
						scene:SetZoomParams(5,height,ZValue,sensitivity)
						scene:SetZoomParams(6,height,ZValue,sensitivity)
					end
				end
			end

		end
	end
end

function CityCameraManager:GetDecorationMainViewCameraZoom()
	--if self.zoom == NewInitZoom then
	--	return 28
	--end
	return 26
end

function CityCameraManager:GetDecorationWorldViewCameraZoom()
	return 16
end

function CityCameraManager:GetDecorationMarchViewCameraZoom()
	return 10
end

function CityCameraManager:SetCacheZoomValue(value,pos)
	self.cacheZoomValue = value
	self.cacheZoomPos = pos
end
function CityCameraManager:GetCacheZoomPos()
	return self.cacheZoomPos
end
return CityCameraManager