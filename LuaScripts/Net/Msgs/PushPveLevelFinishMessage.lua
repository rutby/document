---
--- 
---

local PushPveLevelFinishMessage = BaseClass("PushPveLevelFinishMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPveLevelFinishMessage:OnCreate()
    base.OnCreate(self)
end

function PushPveLevelFinishMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    DataCenter.BattleLevel:OnPushPveLevelFinish(message)
end


return PushPveLevelFinishMessage