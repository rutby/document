---
--- Created by shimin.
--- DateTime: 2020/8/3 18:27
---
local ArmyAddMessage = BaseClass("ArmyAddMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutUtfString("id", tostring(param.id))
        self.sfsObj:PutBool("gold", param.gold)
        self.sfsObj:PutInt("num", param.num)
        self.sfsObj:PutInt("prepare", param.prepare or 0)
        if param.isGuide then
            self.sfsObj:PutBool("isGuide", true)
        end
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.ArmyManager:ArmyAddMessageHandle(t)
    DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.TrainSoldier, nil)
    EventManager:GetInstance():Broadcast(EventId.GuideWaitMessage)
end

ArmyAddMessage.OnCreate = OnCreate
ArmyAddMessage.HandleMessage = HandleMessage

return ArmyAddMessage