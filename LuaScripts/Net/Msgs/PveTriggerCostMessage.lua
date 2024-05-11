--- Created by shimin.
--- DateTime: 2022/8/10 11:23
--- pve trigger消耗（trigger不完成一直购买）

local PveTriggerCostMessage = BaseClass("PveTriggerCostMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PveTriggerCostMessage:OnCreate(param)
    base.OnCreate(self)
    if param ~= nil then
        self.sfsObj:PutInt("level", param.level)
        self.sfsObj:PutInt("trigger", param.trigger)
    end
end

function PveTriggerCostMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    --走push 不需要处理
end

return PveTriggerCostMessage