---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/10/30 15:16
---
local GetEdenGroupSimpleInfoMessage = BaseClass("GetEdenGroupSimpleInfoMessage", SFSBaseMessage)
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

GetEdenGroupSimpleInfoMessage.OnCreate = OnCreate
GetEdenGroupSimpleInfoMessage.HandleMessage = HandleMessage

return GetEdenGroupSimpleInfoMessage