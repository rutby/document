local GotoMoveBubbleManager = BaseClass("GotoMoveBubbleManager")
local ResourceManager = CS.GameEntry.Resource
local GotoMoveBubble = require "Scene.GotoMoveBubble.GotoMoveBubble"

local function __init(self)
	self.bubble = nil
	self.request = nil
end

local function __delete(self)
	self:DestroyUI()
end

local function RemoveUI(self)
	if self.bubble ~= nil then
		self.bubble:Hide()
	end
end

local function DestroyUI(self)
	if self.bubble ~= nil then
		self.bubble:OnDestroy()
		self.bubble = nil
	end
	if self.request ~= nil then
		self.request:Destroy()
		self.request = nil
	end
end

local function ShowUI(self,posIndex)
	local param = {}
	param.posIndex = posIndex
	if self.bubble == nil then
		self.request = ResourceManager:InstantiateAsync(UIAssets.GoToMoveBubble)
		self.request:completed('+', function()
			if self.request.isError then
				return
			end
			self.request.gameObject:SetActive(true)
			self.request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

			local effect = GotoMoveBubble.New()
			effect:OnCreate(self.request)
			self.bubble = effect
			self.bubble:ReInit(param)
		end)
	else
		self.bubble:ReInit(param)
	end
end

local function OnClickCallBack(self,param)
	local needParam = {}
	needParam.click = true
	DataCenter.GuideManager:SetCompleteNeedParam(needParam)
	DataCenter.GuideManager:CheckGuideComplete()
	self:RemoveUI()
end

local function GetObject(self)
	if self.bubble ~= nil then
		return self.bubble:GetGuideBtn()
	end
end

GotoMoveBubbleManager.__init = __init
GotoMoveBubbleManager.__delete = __delete
GotoMoveBubbleManager.ShowUI = ShowUI
GotoMoveBubbleManager.OnClickCallBack = OnClickCallBack
GotoMoveBubbleManager.RemoveUI = RemoveUI
GotoMoveBubbleManager.GetObject = GetObject
GotoMoveBubbleManager.DestroyUI = DestroyUI

return GotoMoveBubbleManager