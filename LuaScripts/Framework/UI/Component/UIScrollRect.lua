local UIScrollRect = BaseClass("UIScrollRect", UIBaseContainer)
local base = UIBaseContainer
local UnityScrollRect = typeof(CS.UnityEngine.UI.ScrollRect)

local function OnCreate(self, ...)
	base.OnCreate(self)
	self.unity_uiscrollRect = self.gameObject:GetComponent(UnityScrollRect)
end

local function GetScrollRect(self)
	return self.unity_uiscrollRect
end

local function OnDestroy(self)
	pcall(function() self.unity_uiscrollRect.onValueChanged:Clear() end)
	self.unity_uiscrollRect = nil
	base.OnDestroy(self)
end

local function OnBeginDrag(self,eventData)
	self.unity_uiscrollRect:OnBeginDrag(eventData)
end

local function OnEndDrag(self,eventData)
	self.unity_uiscrollRect:OnEndDrag(eventData)
end

local function OnDrag(self,eventData)
	self.unity_uiscrollRect:OnDrag(eventData)
end

local function SetScrollEndDrag(self)
	self.unity_uiscrollRect:ScrollRect_EndDrag()
end

local function SetEnable(self, value) 
	self.unity_uiscrollRect.enabled = value
end

local function StopMovement(self) 
	self.unity_uiscrollRect:StopMovement()
end

local function AddValueChangeListener( self, callback )
	self.unity_uiscrollRect.onValueChanged:AddListener(callback)
end

local function RemoveAllListeners(self)
	self.unity_uiscrollRect.onValueChanged:RemoveAllListeners()
end

local function SetHorizontalNormalizedPosition( self, data )
	self.unity_uiscrollRect:SetHorizontalNormalizedPosition( data )
end

local function GetHorizontalNormalizedPosition( self )
	return self.unity_uiscrollRect:GetHorizontalNormalizedPosition()
end

local function SetVerticalNormalizedPosition( self ,value)
	self.unity_uiscrollRect.verticalNormalizedPosition = value
end

local function GetVerticalNormalizedPosition(self)
	return self.unity_uiscrollRect.verticalNormalizedPosition
end

UIScrollRect.SetScrollEndDrag = SetScrollEndDrag
UIScrollRect.OnCreate = OnCreate
UIScrollRect.OnDestroy = OnDestroy
UIScrollRect.OnBeginDrag = OnBeginDrag
UIScrollRect.OnEndDrag = OnEndDrag
UIScrollRect.OnDrag = OnDrag
UIScrollRect.SetEnable = SetEnable
UIScrollRect.StopMovement = StopMovement
UIScrollRect.AddValueChangeListener = AddValueChangeListener
UIScrollRect.RemoveAllListeners = RemoveAllListeners
UIScrollRect.SetHorizontalNormalizedPosition = SetHorizontalNormalizedPosition
UIScrollRect.GetHorizontalNormalizedPosition = GetHorizontalNormalizedPosition
UIScrollRect.GetScrollRect = GetScrollRect
UIScrollRect.SetVerticalNormalizedPosition = SetVerticalNormalizedPosition
UIScrollRect.GetVerticalNormalizedPosition = GetVerticalNormalizedPosition



return UIScrollRect