local UIEventTrigger = BaseClass("UIEventTrigger", UIBaseContainer)
local base = UIBaseContainer
local CSUIEventTrigger = typeof(CS.UIEventTrigger)

local function OnCreate(self, ...)
	base.OnCreate(self)
	self.unity_event_trigger = self.gameObject:GetComponent(CSUIEventTrigger)
end

local function OnDestroy(self)
	self.unity_event_trigger.onDrag = nil
	self.unity_event_trigger.onBeginDrag = nil
	self.unity_event_trigger.onEndDrag = nil
	self.unity_event_trigger.onPointerDown = nil
	self.unity_event_trigger.onPointerUp  = nil
	self.unity_event_trigger.onPointerEnter = nil
	self.unity_event_trigger.onPointerExit = nil
	self.unity_event_trigger.onPointerClick = nil
	self.unity_event_trigger.onLongPress = nil
	self.unity_event_trigger = nil
	base.OnDestroy(self)
end

local function OnDrag(self,onDrag)
	self.unity_event_trigger.onDrag = onDrag
end

local function OnBeginDrag(self,onBeginDrag)
	self.unity_event_trigger.onBeginDrag = onBeginDrag
end

local function OnEndDrag(self,onEndDrag)
	self.unity_event_trigger.onEndDrag = onEndDrag
end

local function OnPointerDown(self,onPointerDown)
	self.unity_event_trigger.onPointerDown = onPointerDown
end

local function OnPointerUp(self,onPointerUp)
	self.unity_event_trigger.onPointerUp = onPointerUp
end
local function OnPointerEnter(self,onPointerEnter)
	self.unity_event_trigger.onPointerEnter = onPointerEnter
end

local function OnPointerExit(self,onPointerExit)
	self.unity_event_trigger.onPointerExit = onPointerExit
end
local function OnPointerClick(self,onPointerClick)
	self.unity_event_trigger.onPointerClick = onPointerClick
end
local function onLongPress(self,onLongPress)
	self.unity_event_trigger.onLongPress = onLongPress
end

UIEventTrigger.OnCreate = OnCreate
UIEventTrigger.OnDestroy = OnDestroy
UIEventTrigger.OnDrag = OnDrag
UIEventTrigger.OnBeginDrag = OnBeginDrag
UIEventTrigger.OnEndDrag = OnEndDrag
UIEventTrigger.OnPointerDown = OnPointerDown
UIEventTrigger.OnPointerUp = OnPointerUp
UIEventTrigger.OnPointerEnter = OnPointerEnter
UIEventTrigger.OnPointerExit = OnPointerExit
UIEventTrigger.OnPointerClick = OnPointerClick
UIEventTrigger.onLongPress = onLongPress
return UIEventTrigger