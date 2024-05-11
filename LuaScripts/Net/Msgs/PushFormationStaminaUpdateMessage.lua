---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/30 14:23
---
local PushFormationStaminaUpdateMessage = BaseClass("PushFormationStaminaUpdateMessage", SFSBaseMessage)
-- 基类，用来调用基类方法
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    LuaEntry.Player:SetStaminaData(t)
    EventManager:GetInstance():Broadcast(EventId.FormationStaminaUpdate)
end

PushFormationStaminaUpdateMessage.OnCreate = OnCreate
PushFormationStaminaUpdateMessage.HandleMessage = HandleMessage

return PushFormationStaminaUpdateMessage