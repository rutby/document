---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/7 15:03
---
local WorldDelAllianceMarkPushMessage = BaseClass("WorldDelAllianceMarkPushMessage", SFSBaseMessage)
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
        DataCenter.WorldFavoDataManager:OnDelAllianceMarkPush(t)
        EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
        --UIUtil.ShowTipsId(280154) 
    end
end

WorldDelAllianceMarkPushMessage.OnCreate = OnCreate
WorldDelAllianceMarkPushMessage.HandleMessage = HandleMessage

return WorldDelAllianceMarkPushMessage