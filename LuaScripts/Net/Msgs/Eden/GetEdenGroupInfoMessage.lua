---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by
--- DateTim
---MoveCrossServerMessage


local GetEdenGroupInfoMessage = BaseClass("GetEdenGroupInfoMessage", SFSBaseMessage)
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
        DataCenter.GloryManager:EdenGroupInfoHandle(t)
    end
end

GetEdenGroupInfoMessage.OnCreate = OnCreate
GetEdenGroupInfoMessage.HandleMessage = HandleMessage

return GetEdenGroupInfoMessage