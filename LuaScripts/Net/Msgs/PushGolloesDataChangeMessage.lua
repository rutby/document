---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/11/8 15:43
---

local PushGolloesDataChangeMessage = BaseClass("PushGolloesDataChangeMessage", SFSBaseMessage)
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
        DataCenter.GolloesCampManager:UpdateGolloesInfo(t)
    end
end

PushGolloesDataChangeMessage.OnCreate = OnCreate
PushGolloesDataChangeMessage.HandleMessage = HandleMessage

return PushGolloesDataChangeMessage