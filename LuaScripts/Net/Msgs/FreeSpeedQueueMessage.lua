---
--- Created by shimin.
--- DateTime: 2021/9/23 16:30
---
local FreeSpeedQueueMessage = BaseClass("FreeSpeedQueueMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,param)
    base.OnCreate(self)
    if param ~= nil then
        local array = SFSArray.New()
        table.walk(param.queueList,function (k,v)
            array:AddLong(v)
        end)
        self.sfsObj:PutSFSArray("queueList", array)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    DataCenter.QueueDataManager:FreeSpeedQueueHandle(t)
end

FreeSpeedQueueMessage.OnCreate = OnCreate
FreeSpeedQueueMessage.HandleMessage = HandleMessage

return FreeSpeedQueueMessage