---
--- Created by shimin.
--- DateTime: 2021/10/26 00:56
---
local BuildWorldMoveNewMessage = BaseClass("BuildWorldMoveNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
        self.sfsObj:PutInt("pointId", param.pointId)
        if param.lastIndex ~= nil then
            DataCenter.BuildManager:AddOneChangeMoveBuild(param.lastIndex)
        end
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:BuildWorldMoveNewHandle(message)
end

BuildWorldMoveNewMessage.OnCreate = OnCreate
BuildWorldMoveNewMessage.HandleMessage = HandleMessage

return BuildWorldMoveNewMessage