
local Messenger = require "Framework.Common.Messenger"
local EventNotify = CS.EventNotify

local EventManager = BaseClass("EventManager", Singleton)

local function __init(self)
    self.messenger = Messenger.New()
end

local function __delete(self)
    self.messenger = nil
end

local function AddListener(self, eventId, handler)
    self.messenger:AddListener(eventId, handler)
end

local function RemoveListener(self, eventId, handler)
    self.messenger:RemoveListener(eventId, handler)
end

local function Broadcast(self, eventId, userData)
    if userData == nil then
        EventNotify.Fire(eventId)
        return
    end
    
    local t = type(userData)
    if t == "number" then
        EventNotify.FireLong(eventId, userData)
    elseif t == "boolean" then
        EventNotify.FireBool(eventId, userData)
    elseif t == "string" then
        EventNotify.FireString(eventId, userData)
    elseif t == "table" and userData.ToBinary then
        EventNotify.FireSFSObject(eventId, userData:ToBinary())
    elseif t == "table" then
        EventNotify.FireLuaTable(eventId, userData)
    else
    Logger.LogError("broadcast type error ", eventId)
    end
end

local function DispatchCSEvent(self, eventId, userData)
    self.messenger:Broadcast(eventId, userData)
end

local function DispatchCSEventSFSObject(self, eventId, userData)
    local sfsObj = SFSObject.NewFromBinary(userData)
    self.messenger:Broadcast(eventId, sfsObj)
end

EventManager.__init = __init
EventManager.__delete = __delete
EventManager.AddListener = AddListener
EventManager.RemoveListener = RemoveListener
EventManager.Broadcast = Broadcast
EventManager.DispatchCSEvent = DispatchCSEvent
EventManager.DispatchCSEventSFSObject = DispatchCSEventSFSObject

return EventManager