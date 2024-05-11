--- 建造家具
--- Created by shimin.
--- DateTime: 2023/11/7 16:34
local UserBuildFurnitureMessage = BaseClass("UserBuildFurnitureMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserBuildFurnitureMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("buildUuid",param.buildUuid)
        self.sfsObj:PutInt("furnitureId",param.furnitureId)
        self.sfsObj:PutInt("index",param.index)
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UpgradeFurniture, true)
end

function UserBuildFurnitureMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.FurnitureManager:UserBuildFurnitureHandle(t)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UpgradeFurniture, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

return UserBuildFurnitureMessage