---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/5/7 18:56
---

local ReceiveDetectLevelRewardMessage = BaseClass("ReceiveDetectLevelRewardMessage", SFSBaseMessage)
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

    end
end

ReceiveDetectLevelRewardMessage.OnCreate = OnCreate
ReceiveDetectLevelRewardMessage.HandleMessage = HandleMessage

return ReceiveDetectLevelRewardMessage