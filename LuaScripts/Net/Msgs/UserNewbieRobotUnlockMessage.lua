--- Created by shimin.
--- DateTime: 2023/12/20 23:16
---
local UserNewbieRobotUnlockMessage = BaseClass("UserNewbieRobotUnlockMessage", SFSBaseMessage)
local base = SFSBaseMessage
function UserNewbieRobotUnlockMessage:OnCreate()
    base.OnCreate(self)
end

function UserNewbieRobotUnlockMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    DataCenter.BuildQueueManager:UserNewbieRobotUnlockHandle(t)
end

return UserNewbieRobotUnlockMessage