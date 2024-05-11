---
--- Created by shimin.
--- DateTime: 2020/8/26 15:56
---
local QueueFinishMessage = BaseClass("QueueFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.QueueDataManager:QueueFinishHandle(t)
end

QueueFinishMessage.OnCreate = OnCreate
QueueFinishMessage.HandleMessage = HandleMessage

return QueueFinishMessage