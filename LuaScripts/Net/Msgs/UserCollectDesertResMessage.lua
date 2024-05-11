---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/12/6 16:15
---
local UserCollectDesertResMessage = BaseClass("UserCollectDesertResMessage", SFSBaseMessage)
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
        if t["resource"] ~= nil then
            LuaEntry.Resource:UpdateResource(t["resource"])
            EventManager:GetInstance():Broadcast(EventId.UserDesertResCollect)
        end
        
    end
    
end

UserCollectDesertResMessage.OnCreate = OnCreate
UserCollectDesertResMessage.HandleMessage = HandleMessage

return UserCollectDesertResMessage