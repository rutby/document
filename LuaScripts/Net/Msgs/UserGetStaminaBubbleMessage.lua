---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/6/25 15:55
---
local UserGetStaminaBubbleMessage = BaseClass("UserGetStaminaBubbleMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        UIUtil.ShowTips(Localization:GetString(t["errorCode"]))
    else
        DataCenter.StaminaBallManager:InitStaminaData(t)
        EventManager:GetInstance():Broadcast(EventId.StaminaBallData)
    end

end

UserGetStaminaBubbleMessage.OnCreate = OnCreate
UserGetStaminaBubbleMessage.HandleMessage = HandleMessage

return UserGetStaminaBubbleMessage