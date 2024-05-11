---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/5/6 11:30
---


local RefreshMineCaveListMessage = BaseClass("RefreshMineCaveListMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        if t["gold"] then
            LuaEntry.Player.gold = t["gold"]
            EventManager:GetInstance():Broadcast(EventId.UpdateGold)
        end
        DataCenter.MineCaveManager:UpdateMineCaveInfo(t)
    end
end

RefreshMineCaveListMessage.OnCreate = OnCreate
RefreshMineCaveListMessage.HandleMessage = HandleMessage

return RefreshMineCaveListMessage