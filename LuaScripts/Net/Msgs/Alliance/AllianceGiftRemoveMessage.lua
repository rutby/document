---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/6/24 10:27
---
local AllianceGiftRemoveMessage = BaseClass("AllianceGiftRemoveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization
local function OnCreate(self,uuid)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("uuid", uuid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        UIUtil.ShowTipsId(120082) 
    end
end

AllianceGiftRemoveMessage.OnCreate = OnCreate
AllianceGiftRemoveMessage.HandleMessage = HandleMessage

return AllianceGiftRemoveMessage