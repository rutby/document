---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/28 15:05
---

local DomainAlMatchVsMessage = BaseClass("DomainAlMatchVsMessage", SFSBaseMessage)
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

    DataCenter.GloryManager:HandleMatch(t)
end

DomainAlMatchVsMessage.OnCreate = OnCreate
DomainAlMatchVsMessage.HandleMessage = HandleMessage

return DomainAlMatchVsMessage