---
--- Created by shimin.
--- DateTime: 2021/9/18 12:25
---
local BuildCityBuildingMessage = BaseClass("BuildCityBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:BuildCityBuildingHandle(t)
end

BuildCityBuildingMessage.OnCreate = OnCreate
BuildCityBuildingMessage.HandleMessage = HandleMessage

return BuildCityBuildingMessage