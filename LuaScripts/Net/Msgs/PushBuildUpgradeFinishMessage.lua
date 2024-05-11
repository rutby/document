---
--- Created by shimin.
--- DateTime: 2021/6/24 10:50
---
local PushBuildUpgradeFinishMessage = BaseClass("PushBuildUpgradeFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:PushBuildUpgradeFinishHandle(t)
end

PushBuildUpgradeFinishMessage.OnCreate = OnCreate
PushBuildUpgradeFinishMessage.HandleMessage = HandleMessage

return PushBuildUpgradeFinishMessage