---
--- Created by shimin.
--- DateTime: 2021/4/22 11:20
---
local FreeBuildingUpNewMessage = BaseClass("FreeBuildingUpNewMessage", SFSBaseMessage)
local base = SFSBaseMessage
local function OnCreate(self, param)
    base.OnCreate(self)
    --记录下当前燃料值
    DataCenter.BuildManager:SetCurStamina()
    if param ~= nil then
        self.sfsObj:PutUtfString("uuid", param.uuid)
        self.sfsObj:PutInt("gold", param.gold)
        self.sfsObj:PutInt("upLevel", param.upLevel)
        self.sfsObj:PutInt("truckId", param.truckId)
        self.sfsObj:PutUtfString("clientParam", param.clientParam)
        self.sfsObj:PutInt("pathTime", param.pathTime)
        if param.goldCost ~= nil and param.goldCost > 0 then
            self.sfsObj:PutInt("goldCost", param.goldCost)
        end
        self.sfsObj:PutLong("robotUuid", param.robotUuid)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.BuildManager:FreeBuildingUpNewHandle(t)
end

FreeBuildingUpNewMessage.OnCreate = OnCreate
FreeBuildingUpNewMessage.HandleMessage = HandleMessage

return FreeBuildingUpNewMessage