---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/28 15:02
---

local DomainAlDeclareWarMessage = BaseClass("DomainAlDeclareWarMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, allianceId, type)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("allianceId", allianceId)
    self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.GloryManager:HandleDeclareWar(t)
end

DomainAlDeclareWarMessage.OnCreate = OnCreate
DomainAlDeclareWarMessage.HandleMessage = HandleMessage

return DomainAlDeclareWarMessage