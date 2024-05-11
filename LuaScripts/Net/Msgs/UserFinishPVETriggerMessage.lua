---
--- 
---

local UserFinishPVETriggerMessage = BaseClass("UserFinishPVETriggerMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("level", param.level)
        self.sfsObj:PutInt("trigger", param.trigger)
        if param.x ~= nil and param.y ~= nil then
            self.sfsObj:PutFloat("x", param.x)
            self.sfsObj:PutFloat("y", param.y)
        end
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    DataCenter.BattleLevel:OnFinishTriggerMessage(message)
end

UserFinishPVETriggerMessage.OnCreate = OnCreate
UserFinishPVETriggerMessage.HandleMessage = HandleMessage

return UserFinishPVETriggerMessage