---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/4/25 16:52
---

local StartDetectEventPveMessage = BaseClass("StartDetectEventPveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BattleLevel:OnStartLevelMessage(message)
end

StartDetectEventPveMessage.OnCreate = OnCreate
StartDetectEventPveMessage.HandleMessage = HandleMessage

return StartDetectEventPveMessage