---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/3 15:18
---

local GetDeclareTargetAlliancePositionMessage = BaseClass("GetDeclareTargetAlliancePositionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        UIUtil.ShowTipsId(t["errorCode"])
        return
    end

    DataCenter.GloryManager:HandleGoToOpponent(t)
end

GetDeclareTargetAlliancePositionMessage.OnCreate = OnCreate
GetDeclareTargetAlliancePositionMessage.HandleMessage = HandleMessage

return GetDeclareTargetAlliancePositionMessage