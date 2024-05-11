---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/2/23 14:56
---


local PushAlWaitMergeMessage = BaseClass("PushAlWaitMergeMessage", SFSBaseMessage)
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
        if t["waitMerge"] then
            DataCenter.AllianceBaseDataManager:UpdateAlWaitMergeStatus(t["waitMerge"])
        end
        
    end
end

PushAlWaitMergeMessage.OnCreate = OnCreate
PushAlWaitMergeMessage.HandleMessage = HandleMessage

return PushAlWaitMergeMessage