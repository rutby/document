--- 升级家具
--- Created by shimin.
--- DateTime: 2023/11/7 16:37
local UserLevelUpFurnitureMessage = BaseClass("UserLevelUpFurnitureMessage", SFSBaseMessage)
local base = SFSBaseMessage

function UserLevelUpFurnitureMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutLong("uuid",param.uuid)
        self.sfsObj:PutBool("isGold",param.isGold)
    end
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UpgradeFurniture, true)
end

function UserLevelUpFurnitureMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.FurnitureManager:UserLevelUpFurnitureHandle(t)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UpgradeFurniture, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
    EventManager:GetInstance():Broadcast(EventId.FurnitureUpgrade)
end

return UserLevelUpFurnitureMessage