--- 推送家具
--- Created by shimin.
--- DateTime: 2023/11/9 20:54
local PushUsrAddFurnitureMessage = BaseClass("PushUsrAddFurnitureMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUsrAddFurnitureMessage:OnCreate()
    base.OnCreate(self)
end

function PushUsrAddFurnitureMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.FurnitureManager:PushUsrAddFurnitureHandle(t)
end

return PushUsrAddFurnitureMessage