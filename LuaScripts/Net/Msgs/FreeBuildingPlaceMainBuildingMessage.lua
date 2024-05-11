---
--- Created by shimin.
--- DateTime: 2021/9/15 17:09
---
local FreeBuildingPlaceMainBuildingMessage = BaseClass("FreeBuildingPlaceMainBuildingMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("pointId", param.pointId)
        if param.pointId ~= nil then
            DataCenter.BuildManager:AddOneChangeMoveBuild(param.pointId)
        end
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:FreeBuildingPlaceMainBuildingHandle(t)
end

FreeBuildingPlaceMainBuildingMessage.OnCreate = OnCreate
FreeBuildingPlaceMainBuildingMessage.HandleMessage = HandleMessage

return FreeBuildingPlaceMainBuildingMessage