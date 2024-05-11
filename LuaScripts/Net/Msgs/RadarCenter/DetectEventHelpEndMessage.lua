---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/4/28 14:52
---

local DetectEventHelpEndMessage = BaseClass("DetectEventHelpEndMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, uuid)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else

    end
end

DetectEventHelpEndMessage.OnCreate = OnCreate
DetectEventHelpEndMessage.HandleMessage = HandleMessage

return DetectEventHelpEndMessage