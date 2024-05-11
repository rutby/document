---
--- Created by shimin.
--- DateTime: 2022/10/28 14:23
--- 
---
local BackBuildingCollectTimeMessage = BaseClass("BackBuildingCollectTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function BackBuildingCollectTimeMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

function BackBuildingCollectTimeMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.BuildManager:BackBuildingCollectTimeMessageHandle(message)
end

return BackBuildingCollectTimeMessage