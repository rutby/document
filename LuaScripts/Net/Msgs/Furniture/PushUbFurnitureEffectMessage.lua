--- 推送一个建筑的家具提供的作用号
--- Created by shimin.
--- DateTime: 2023/11/9 20:54
local PushUbFurnitureEffectMessage = BaseClass("PushUbFurnitureEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUbFurnitureEffectMessage:OnCreate()
    base.OnCreate(self)
end

function PushUbFurnitureEffectMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    LuaEntry.Effect:UpdateOneBuildEffectFurniture(t)
end

return PushUbFurnitureEffectMessage