---
--- Created by shimin.
--- DateTime: 2021/10/26 00:21
---
local FreeBuildingPlaceNewMessage = BaseClass("FreeBuildingPlaceNewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("buildingId", param.buildingId)
        if param.pointId ~= nil then
            self.sfsObj:PutInt("pointId", param.pointId)
        end
      
        self.sfsObj:PutInt("pathTime", param.pathTime)
        if param.itemUuid ~= nil and  param.itemUuid ~= "" then
            self.sfsObj:PutUtfString("itemUuid", param.itemUuid)
        end
        self.sfsObj:PutLong("robotUuid", param.robotUuid)
        self.sfsObj:PutInt("targetServer", param.targetServerId)

        if param.armyDict then
            local formationArr = SFSArray.New()
            for armyId, count in pairs(param.armyDict) do
                local obj = SFSObject.New()
                obj:PutUtfString("armyId", armyId)
                obj:PutInt("count", count)
                formationArr:AddSFSObject(obj)
            end
            self.sfsObj:PutSFSArray("formations", formationArr)
        end
        if param.worldId~=nil then
            self.sfsObj:PutInt("worldId",param.worldId)
        end
        
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:FreeBuildingPlaceNewHandle(message)
end

FreeBuildingPlaceNewMessage.OnCreate = OnCreate
FreeBuildingPlaceNewMessage.HandleMessage = HandleMessage

return FreeBuildingPlaceNewMessage