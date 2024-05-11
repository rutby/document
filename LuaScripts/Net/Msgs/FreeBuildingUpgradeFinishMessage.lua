---
--- Created by shimin.
--- DateTime: 2020/7/6 21:39
---
local FreeBuildingUpgradeFinishMessage = BaseClass("FreeBuildingUpgradeFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    --记录下当前燃料值
    DataCenter.BuildManager:SetCurStamina()
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:FreeBuildingUpgradeFinishHandle(message)
end

FreeBuildingUpgradeFinishMessage.OnCreate = OnCreate
FreeBuildingUpgradeFinishMessage.HandleMessage = HandleMessage

return FreeBuildingUpgradeFinishMessage