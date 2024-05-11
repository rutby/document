--- Created by shimin
--- DateTime: 2021/9/22 22:32
---
local ReceivePveTriggerDropItemMessage = BaseClass("ReceivePveTriggerDropItemMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ReceivePveTriggerDropItemMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("level", param.level)
        self.sfsObj:PutLong("uuid", param.uuid)
    end
end

function ReceivePveTriggerDropItemMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    
end

return ReceivePveTriggerDropItemMessage