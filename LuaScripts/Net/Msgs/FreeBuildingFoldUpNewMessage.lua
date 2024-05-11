---
--- Created by shimin.
--- DateTime: 2021/4/7 18:32
---
local FreeBuildingFoldUpNewMessage = BaseClass("FreeBuildingFoldUpNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("buildUuid", param.buildUuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:FreeBuildingFoldUpNewHandle(t)
end

FreeBuildingFoldUpNewMessage.OnCreate = OnCreate
FreeBuildingFoldUpNewMessage.HandleMessage = HandleMessage

return FreeBuildingFoldUpNewMessage