---
--- Created by shimin.
--- DateTime: 2021/6/22 20:39
---
local PushInitBuildMessage = BaseClass("PushInitBuildMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:PushInitBuildHandle(t)
end

PushInitBuildMessage.OnCreate = OnCreate
PushInitBuildMessage.HandleMessage = HandleMessage

return PushInitBuildMessage