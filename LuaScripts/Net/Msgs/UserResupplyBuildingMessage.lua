---
--- Created by shimin.
--- DateTime: 2021/7/13 18:47
---
local UserResupplyBuildingMessage = BaseClass("UserResupplyBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
        self.sfsObj:PutInt("resupplyNum", param.resupplyNum)
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:UserResupplyBuildingHandle(message)
end

UserResupplyBuildingMessage.OnCreate = OnCreate
UserResupplyBuildingMessage.HandleMessage = HandleMessage

return UserResupplyBuildingMessage