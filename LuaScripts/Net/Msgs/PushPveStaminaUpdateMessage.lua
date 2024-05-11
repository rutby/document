---
--- Created by shimin.
--- DateTime: 2022/7/29 15:48
--- 推送pve体力
---
local PushPveStaminaUpdateMessage = BaseClass("PushPveStaminaUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPveStaminaUpdateMessage:OnCreate()
    base.OnCreate(self)
end

function PushPveStaminaUpdateMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    LuaEntry.Player:SetPveStaminaData(t)
    EventManager:GetInstance():Broadcast(EventId.PveStaminaUpdate)
end

return PushPveStaminaUpdateMessage